import os
from PIL import Image
import cv2 as cv
import numpy as np
from sklearn.cluster import KMeans
from sklearn.svm import LinearSVC
from sklearn.metrics import accuracy_score
from SpatialPyramidMatching import SpatialPyramidMatching

from paper_implementation.test import get_spatial_pyramid

images_path = "./101_ObjectCategories"
categories = os.listdir(images_path)
# Number of train images and test images used based on paper
num_train = 5
num_test = 10
# Number of categories to be used
num_cat = 100

train_descriptors = dict()
test_descriptors = dict()
train_kp = dict()
test_kp = dict()
train_img_sizes = dict()
test_img_sizes = dict()

for cat_idx, category in enumerate(categories):
    if cat_idx >= num_cat:
        break
    print("Processing category {}".format(category))
    train_descriptors[category] = list()
    test_descriptors[category] = list()
    train_kp[category] = list()
    test_kp[category] = list()
    train_img_sizes[category] = list()
    test_img_sizes[category] = list()

    image_category_path = os.path.join(images_path, category)
    image_categories = os.listdir(image_category_path)
    for idx, image_name in enumerate(image_categories):
        if idx >= num_train + num_test:
            break
        # Load and change rgb to grayscale as per paper description
        image = cv.imread(os.path.join(image_category_path, image_name))
        gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
        width, height, channels = image.shape
        kp, descriptors = SpatialPyramidMatching.get_sift_features(image)
        if idx < num_train:
            train_descriptors[category].append(descriptors)
            train_kp[category].append(kp)
            train_img_sizes[category].append((height, width))
        else:
            test_descriptors[category].append(descriptors)
            test_kp[category].append(kp)
            test_img_sizes[category].append((width, height))


features = []
for category in train_descriptors.keys():
    for img in train_descriptors[category]:
        for f in img:
            features.append(f)

features = np.array(features)
# print(features)

# Set visual vocabulary size, 200 is used in Table 2 as strong features
M = 5
clusters = KMeans(n_clusters=M)
clusters.fit(features)
print("Clustering completed!")

# Set the level L
for L in range(3):
    print("Starting building level {}".format(L))
    X_train1, Y_train1 = get_spatial_pyramid(train_descriptors, train_kp, train_img_sizes, clusters, L, M)
    X_test1, Y_test1 = get_spatial_pyramid(train_descriptors, train_kp, train_img_sizes, clusters, L, M)
    model = LinearSVC()
    model.fit(X_train1, Y_train1)
    print("Level {} result: {}".format(L, accuracy_score(Y_test1, model.predict(X_test1))))
