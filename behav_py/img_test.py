# import pandas as p
import numpy as np
# from PIL import Image
# from PIL import ImageFilter
# from pathlib import Path
import math
# from matplotlib import pyplot as plt
import cv2 as cv

# try: 
#     corgi  = cv.imread("corgi.jpg") 
# except IOError:
#     pass

try: 
    goldi  = cv.imread("64x64_test_in.png",1) 
except IOError:
    pass


def rgb2gray(img):
    height = img.shape[0]
    width = img.shape[1]
    Y = np.zeros((height,width), np.uint8)
    print(Y.shape)

    for i in range(height):
        for j in range(width):
            Y[i,j] = 0.28125 * img[i,j][0] + 0.5625 * img[i,j][1] + 0.1171875 * img[i,j][2] 
    return Y

def rgb2gray_bit(img):
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
            if ( (i+k-1)>0 and (j+l-1)>0 and (i+k-1)<h and (j+l-1)<w ):
                result += np.floor(img[i+k-1,j+l-1] * kernel[k, l])
    result = math.fabs(result)
    return result if (result < 255) else 255

def sobel_bit(img):
    height = img.shape[0]
    width = img.shape[1]

    blur_kernel = 0.09375 * np.array([[1, 1, 1],
                                      [1, 2, 1],
                                      [1, 1, 1]])
    kernel_x = np.array([[-1, 0, 1],
                        [-2, 0, 2],
                        [-1, 0, 1]])
    kernel_y = -kernel_x.transpose()

    gb =  np.zeros((height,width), np.uint8)
    new_image = np.zeros((height,width), np.uint8)

    gray = rgb2gray_bit(img)

    for i in range(height):
        for j in range(width):
            gb[i,j] = convolution(blur_kernel, gray, i, j)

    for i in range(height):
        for j in range(width):
            new_image[i,j] = 0.5 * convolution(kernel_x, gray, i, j) + 0.5 * convolution(kernel_y, gray, i, j)

    return new_image

def sobel_my(img):
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
    new_image = np.zeros((height,width), np.uint8)

    gray = rgb2gray(img)

    for i in range(height):
        for j in range(width):
            gb[i,j] = convolution(blur_kernel, gray, i, j)

    for i in range(height):
        for j in range(width):
            new_image[i,j] = 0.5 * convolution(kernel_x, gray, i, j) + 0.5 * convolution(kernel_y, gray, i, j)

    return new_image

def sobel_net(img):
    
    window_name = ('Sobel Demo - Simple Edge Detector')
    scale = 1
    delta = 0
    ddepth = cv.CV_16S

    src = img.copy()
    # Check if image is loaded fine
        
    src = cv.GaussianBlur(src, (3, 3), 0)
    
    gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY)
    
    grad_x = cv.Sobel(gray, ddepth, 1, 0, ksize=3, scale=scale, delta=delta, borderType=cv.BORDER_DEFAULT)
    grad_y = cv.Sobel(gray, ddepth, 0, 1, ksize=3, scale=scale, delta=delta, borderType=cv.BORDER_DEFAULT)
    
    abs_grad_x = cv.convertScaleAbs(grad_x)
    abs_grad_y = cv.convertScaleAbs(grad_y)

    grad = cv.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)
    return grad



cv.imshow('startpick', goldi)
# goldi_bit = sobel_bit(goldi)
# cv.imshow('goldi_bit', goldi_bit)
goldi_net = sobel_net(goldi)
# cv.imshow('goldi_net', goldi_net)
# goldi_my = sobel_my(goldi)
# cv.imshow('goldi_my', goldi_my)

height = goldi.shape[0]
width = goldi.shape[1]

print(height, width)

# diff_net_my =  np.zeros((height,width), np.uint8)
# diff_my_bit =  np.zeros((height,width), np.uint8)
# diff_my_bit_5x =  np.zeros((height,width), np.uint8)

# for i in range(height):
#     for j in range(width):
#         diff_net_my[i,j] = (goldi_net[i,j] - goldi_my[i,j]) if (goldi_net[i,j] > goldi_my[i,j]) else (goldi_my[i,j] - goldi_net[i,j])
#         diff_my_bit[i,j] = (goldi_my[i,j] - goldi_bit[i,j]) if (goldi_my[i,j] > goldi_bit[i,j]) else (goldi_bit[i,j] - goldi_my[i,j])
#         diff_my_bit_5x[i,j] = diff_my_bit[i,j]*200


# cv.imshow('diff_net_my', diff_net_my)
# cv.imshow('diff_my_bit', diff_my_bit)
# cv.imshow('diff_my_bit_5x', diff_my_bit_5x)


with open('pic_input.txt', 'w') as f:
    for y in range(goldi.shape[0]):
        for x in range(goldi.shape[1]):
            f.write(f'[{x},{y}]: red: {goldi[x][y][0]}, green: {goldi[x][y][1]}, blue: {goldi[x][y][2]}')
            f.write('\n')

with open('pic_output.txt', 'w') as f:
    for y in range(goldi_net.shape[0]):
        for x in range(goldi_net.shape[1]):
            f.write(f'[{x},{y}]: {goldi_net[x][y]}')
            f.write('\n')


duv =  np.zeros((height,width), np.uint8)

with open('duv.txt', 'r') as f:
    for y in range(63):
        for x in range(63):
            duv[x][y] = f.readline()

cv.imshow('duv', duv)
cv.waitKey(0)

