import io
import os.path
import google.auth
import rasterio
import xarray as xr
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2 import service_account

# If modifying these scopes, delete the file credentials.
SCOPES = ["https://www.googleapis.com/auth/drive"]
credential_path = os.path.expanduser('~/Supplementary_data/DriveCredentials/credentials.json')



def create_token():
    ''''
        credential: provide the json creditials you would get from google service.
    '''
    creds = None
    creds = service_account.Credentials.from_service_account_file(credential_path, scopes=SCOPES)
    return creds

   
def list_gdrive():
    '''
    List the recent files from Google Drive and return them as a list of dictionaries.
    '''
    creds = create_token()
    files = []  # Initialize an empty list to capture files
    try:
        service = build("drive", "v3", credentials=creds)
      
        results = service.files().list(pageSize=20, fields="nextPageToken, files(id, name)").execute()
        items = results.get("files", [])

        if not items:
            print("No files found.")
            return files  # Return an empty list if no files found
        
        # Collect file names and IDs into the list
        for item in items:
            files.append({"name": item['name'], "id": item['id']})
    except HttpError as error:
        print(f"An error occurred: {error}")
        
    return files  # Return the list of files    

def read_tif_from_gdrive(file_id):
    """Read a .tif file directly from Google Drive using its file ID and return as an xarray DataArray."""
    creds = create_token()  # Leverage your existing connection
    try:
        service = build("drive", "v3", credentials=creds)
        request = service.files().get_media(fileId=file_id)
        file_stream = io.BytesIO()  # Create a stream to hold the downloaded content
        downloader = MediaIoBaseDownload(file_stream, request)

        done = False
        while not done:
            status, done = downloader.next_chunk()

        # Move to the beginning of the stream
        file_stream.seek(0)

        # Load the .tif file into an xarray DataArray using rasterio
        with rasterio.open(file_stream) as src:
            data = src.read(1)  # Read the first band
            transform = src.transform  # Get the affine transform for spatial information
            
            # Create coordinates using the transform
            height, width = data.shape
            x_coords = [transform[2] + i * transform[0] for i in range(width)]  # x-coordinates
            y_coords = [transform[5] + i * transform[4] for i in range(height)]  # y-coordinates
            
            # Create the DataArray with correct spatial coordinates
            data_array = xr.DataArray(
                data,
                dims=("y", "x"),
                coords={"y": y_coords, "x": x_coords},
                attrs=src.meta  # Add metadata directly from rasterio
            )

        return data_array, transform  # Return both data_array and transform
    
    except HttpError as error:
        print(f"An error occurred: {error}")
        return None, None  # Return None for both data_array and transform


def upload_to_gdrive(file_path=None):
    '''
        Uploading files to google drive
    '''
    creds = create_token()
    try:
        # create drive api client
        service = build("drive", "v3", credentials=creds)
        folder_path = os.path.expanduser('~/Supplementary_data/DriveCredentials/credentials.json')
        #read the first line of the file
        folder_id = open(folder_path, "r").readline()

        file_metadata = {"name": file_path, "parents": [folder_id]}
        media = MediaFileUpload(file_path, resumable=True)
        # pylint: disable=maybe-no-member
        file = (service.files().create(body=file_metadata, media_body=media).execute())
        print('File Uploaded successful')
    except HttpError as error:
        print(f"An error occurred: {error}")
        file = None
    return


def delete_to_gdrive(file_id=None):
    '''
        deleting file from google drive
    '''
    creds = create_token()
    try:
        # create drive api client
        service = build("drive", "v3", credentials=creds)

        # pylint: disable=maybe-no-member
        response = service.files().delete(fileId=file_id).execute()
        print('File deleted successful')
    except HttpError as error:
        print(f"An error occurred: {error}")
        file = None
    return