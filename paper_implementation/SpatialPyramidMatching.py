import cv2 as cv


class SpatialPyramidMatching:

    @staticmethod
    def get_grid(level, x, y, cols, rows):
        """
        Get the specified grid of the images
        """
        window_size = 2 ** level
        col_grid_size = cols // window_size
        row_grid_size = rows // window_size
        nx = int(x // col_grid_size)
        ny = int(y // row_grid_size)

        return ny * window_size + nx
    
    def __init__(self, descriptors, kp, image_sizes, clusters, L=3, M=200):
        self.features = []
        self.labels = []
        for des in descriptors:
            for idx, descriptor in enumerate(descriptors[des]):
                if descriptor is None:
                    self.features.append([0 for i in range((M * (-1 + 4 ** (L + 1))) // 3)])
                    self.labels.append(des)
                    continue
                v = []

                channels = {}
                channels_coordinates = {}
                # width, height = image_sizes[des][idx]
                cols = image_sizes[des][idx][0]
                rows = image_sizes[des][idx][1]

                # Get K-means prediction of current image descriptor
                predictions = clusters.predict(descriptor)

                for i, prediction in enumerate(predictions):
                    if prediction not in channels:
                        channels[prediction] = []
                        channels_coordinates[prediction] = []
                    channels[prediction].append(descriptors[des][idx][i].tolist())
                    channels_coordinates[prediction].append(kp[des][idx][i])

                for c in range(M):
                    if c not in channels:
                        v += [0 for i in range(((-1 + 4 ** (L + 1))) // 3)]
                        continue

                    for l in range(L + 1):
                        w = 0

                        if l == 0:
                            w = 1 / (1 << L)
                        else:
                            w = 1 / (1 << (L - l + 1))

                        hist = [0 for i in range(4 ** l)]

                        for i in range(len(channels_coordinates[c])):
                            x = channels_coordinates[c][i][0]
                            y = channels_coordinates[c][i][1]

                            grid = self.get_grid(l, x, y, cols, rows)

                            hist[grid] += 1

                        hist = [it * w for it in hist]

                        v += hist

                self.features.append([it / (((M / 200) * 25) * (1 << L)) for it in v])
                self.labels.append(des)

    @staticmethod
    def get_sift_features(gray_image):
        """
        Generate sift features
        https://docs.opencv.org/master/da/df5/tutorial_py_sift_intro.html
        """
        sift = cv.SIFT_create()
        kp, des = sift.detectAndCompute(gray_image, None)
        kp = [i.pt for i in kp]
        return kp, des

    def get_spatial_pyramid(self):
        # print(self.features)
        # print(self.labels)
        return self.features, self.labels
