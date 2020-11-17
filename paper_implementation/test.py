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


def get_spatial_pyramid(descriptors, kp, image_sizes, clusters, L=3, M=200):
    """
    Transforms the images into spatial pyramid
    """
    X = []
    Y = []

    for des in descriptors:
        for idx, descriptor in enumerate(descriptors[des]):
            sigma_L = (-1 + 4 ** (L + 1)) // 3
            if descriptor is None:
                X.append([0]* (M * sigma_L))
                Y.append(des)
                continue
            result_vector = []
            channels = {}
            channels_kp = {}
            width, height = image_sizes[des][idx]

            # Get K-means prediction of current image descriptor
            predictions = clusters.predict(descriptor)

            for pred_idx, prediction in enumerate(predictions):
                if prediction not in channels:
                    channels[prediction] = []
                    channels_kp[prediction] = []
                channels[prediction].append(descriptors[des][idx][pred_idx].tolist())
                channels_kp[prediction].append(kp[des][idx][pred_idx])

            # Iterate through all channel m
            for channel in range(M):
                if channel not in channels:
                    result_vector += [0] * sigma_L
                    continue
                for l in range(L + 1):
                    w = 1 / (2 ** min((L - l + 1), L))

                    # Define histogram
                    hist = [0] * (4 ** l)

                    # Fill the histogram
                    for position in channels_kp[channel]:
                        x = position[0]
                        y = position[1]
                        # Get the grid location of (x,y) position in image
                        grid = get_grid(l, x, y, width, height)
                        try:
                            hist[grid] += 1
                        except IndexError:
                            hist[-1] += 1

                    hist = [it * w for it in hist]

                    result_vector += hist

            X.append([it / (((M / 200) * 25) * (2 ** L)) for it in result_vector])
            Y.append(des)
    return X, Y
