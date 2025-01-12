# wetland-workflow
A collection of notebooks describing a repeatable workflow for predicting mapping wetland extent and types using the Digital Earth Africa platform

### Training data preparation
The purpose of this notebook is to create training samples for a wetland classification model. It focuses on generating representative samples of both wetland and non-wetland areas to facilitate the training of an accurate and robust model.
### Terrain fearures from DEM
The notebook computes and exports a range of terrain indices, including elevation, slope*, curvature*, planform curvature*, profile curvature*, Multi-resolution Valley Bottom Flatness (MrVBF), Multi-resolution Ridge Top Flatness (MrRTF), Topographic Wetness Index (TWI), Terrain Profile Index (TPI)* and Cartographic Depth-to-Water (DTW). These indices provide key information related to slope, orientation, shape, hydrology, water flow patterns, and various other factors that are critical in the context of wetlands. The terrain attributes with a * are computed at multiple scales using a moving window approach.
### Feature extraction
This notebook is dedicated to the extraction of training data (feature layers) from the open-data-cube using predefined geometries from a GeoJSON file. It provides a step-by-step approach to guide users in effectively using the "collect_training_data" function. The objective is to enable users to extract the relevant training data for their specific use cases.
### Train classification algorithm
The main objective of this notebook is to train and evaluate a Random Forest classifier for wetland mapping and classification.
### Wetland type classification
The main function of this notebook is to utilise the trained Random Forest classifier to predict the landscape’s wetland intrinsic potential and then classify wetland areas into classes for a specific area of interest.
