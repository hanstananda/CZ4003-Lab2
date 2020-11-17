import cv2 as cv


class SpatialPyramidMatching:

    @staticmethod
    def get_grid(level, x, y, cols, rows):
        """
        Get the specified grid of the images
        """
        denom = 1 << level
        nx, ny = 0, 0
        for numer in range(denom):
            if (numer / denom) * cols <= x <= ((numer + 1) / denom) * cols:
                nx = numer
            if (numer / denom) * rows <= y <= ((numer + 1) / denom) * rows:
                ny = numer

        return ny * denom + nx

    def __init__(self, descriptors, kp, image_sizes, clusters, L=2, M=200):
        self.features = []
        self.labels = []
        for des in descriptors:
            for idx in range(len(descriptors[des])):
                descriptor = descriptors[des][idx]
                print(des, idx)
                if descriptor is None:
                    self.features.append([0 for i in range((M * (-1 + 4 ** (L + 1))) // 3)])
                    self.labels.append(des)
                    continue
                v = []

                channels = {}
                channels_coordinates = {}
                width, height = image_sizes[des][idx]
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

                            grid = self.get_grid(l, x, y, height, width)

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
