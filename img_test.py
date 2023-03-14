# import pandas as p
import numpy as np
# from PIL import Image
# from PIL import ImageFilter
# from pathlib import Path
import math
# from matplotlib import pyplot as plt
import cv2 as cv

try: 
    corgi  = cv.imread("corgi.jpg") 
except IOError:
    pass

try: 
    goldi  = cv.imread("goldi.jpg", 1) 
except IOError:
    pass


def rgb2gray(img):
    height = img.shape[0]
    width = img.shape[1]
    Y = np.zeros((height,width), np.uint8)
    print(Y.shape)

    for i in range(height):
        for j in range(width):
            Y[i,j] = 0.2989 * img[i,j][0] + 0.5870 * img[i,j][1] + 0.1140 * img[i,j][2] 
    return Y

def convolution(kernel, img, i, j):
    h = img.shape[0]-1
    w = img.shape[1]-1
    kh = kernel.shape[0]
    kw = kernel.shape[1]
    result = 0

    for k in range(kh):
        for l in range(kw):
            result += (img[i+k-1,j+l-1] * kernel[k, l]) if (i%h and j%w) else 0
    return result if (result > 0) else -result

def sobel(img):
    height = img.shape[0]
    width = img.shape[1]

    blur_kernel = 0.1 * np.array([[1, 1, 1],
                                  [1, 2, 1],
                                  [1, 1, 1]])
    kernel_x = np.array([[-1, 0, 1],
                        [-2, 0, 2],
                        [-1, 0, 1]])
    kernel_y = -kernel_x.transpose()

    gb =  np.zeros((height,width,3), np.uint8)
    new_image = np.zeros((height,width,3), np.uint8)

    gray = rgb2gray(img)

    for i in range(height):
        for j in range(width):
            gb[i,j] = convolution(blur_kernel, gray, i, j)

    for i in range(height):
        for j in range(width):
            new_image[i,j] = 0.5 * convolution(kernel_x, gray, i, j) + 0.5 * convolution(kernel_y, gray, i, j)

    return new_image


cv.imshow('startpick', goldi)
cv.imshow('my_sobel', sobel(goldi))


cv.waitKey(0)

