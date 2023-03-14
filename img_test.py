# import pandas as p
import numpy as np
# from PIL import Image
# from PIL import ImageFilter
# from pathlib import Path
import math
# from matplotlib import pyplot as plt
import cv2 as cv

# legacy code :d

# print(goldi.format, f"{goldi.size}x{goldi.mode}")
# new_size = (math.ceil(goldi.size[0] / goldi.size[1] * 640), 640)
# out = goldi.resize(new_size)
# out.save("goldi.jpg")

# crop_box = (goldi.size[0] / 2 - 320, goldi.size[1] / 2 - 320, goldi.size[0] / 2 + 320, goldi.size[1] / 2 + 320 )
# new_im = goldi.crop(crop_box)
# ket_kutya = merge(corgi, goldi)
# ket_kutya.show()

# out = im.filter(ImageFilter.DETAIL)
# out = im.point(lambda i: i * 1.2)

# source = im.split()
# mask = source[R].point(lambda i: i < 100 and 255)
# out = source[G].point(lambda i: i * 0.7)
# source[G].paste(out, None, mask)
# im = Image.merge(im.mode, source)


# def roll(im, delta):
#     """Roll an image sideways."""
#     xsize, ysize = im.size

#     delta = delta % xsize
#     if delta == 0:
#         return im

#     part1 = im.crop((0, 0, delta, ysize))
#     part2 = im.crop((delta, 0, xsize, ysize))
#     im.paste(part1, (xsize - delta, 0, xsize, ysize))
#     im.paste(part2, (0, 0, xsize - delta, ysize))

#     return im

def filter(im, filter):
    return im
    

# def merge(im1, im2):
#     w = im1.size[0] + im2.size[0]
#     h = max(im1.size[1], im2.size[1])
#     im = Image.new("RGBA", (w, h))

#     im.paste(im1)
#     im.paste(im2, (im1.size[0], 0))

#     return im

# print(Path.cwd())

try: 
    corgi  = cv.imread("corgi.jpg") 
except IOError:
    pass

try: 
    goldi  = cv.imread("goldi.jpg", 1) 
except IOError:
    pass


# corgi.show()
# goldi.show()
cv.imshow('image', goldi)

img = goldi.copy()

# rows,cols,_ = img.shape

# for i in range(rows):
#     for j in range(cols):
#         img[i,j] = [1,2,1]


# im.show()


# # kernel = np.ones((5,5),np.float32)/25
# kernel = np.array([[-1, 0, 1],
#                    [-2, 0, 2],
#                    [-1, 0, 1]])
# dst = cv.filter2D(img,-1,kernel)

# cv.imshow('dst', dst)
# cv.imshow('goldi', img)

# plt.subplot(121),plt.imshow(goldi),plt.title('Original')
# plt.xticks([]), plt.yticks([])
# plt.subplot(122),plt.imshow(dst),plt.title('Averaging')
# plt.xticks([]), plt.yticks([])
# plt.show()


# blur = cv.blur(img,(5,5))

# plt.subplot(121),plt.imshow(img),plt.title('Original')
# plt.xticks([]), plt.yticks([])
# plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
# plt.xticks([]), plt.yticks([])
# plt.show()

    # for i in range():
    #     for j in range():

def convolution(kernel, img, i, j):
    h = img.shape[0]-1
    w = img.shape[1]-1
    kh = kernel.shape[0]
    kw = kernel.shape[1]
    result = 0

    for k in range(kh):
        for l in range(kw):
            result += (img[i+k-1,j+l-1] * kernel[k, l]) if (i%h and j%w) else 0
            # print(f"kernel[{y},{x}] = {kernel[y,x]}")
            # print(f"img[{i+x-1},{j+y-1}] = {img[i+x-1,j+y-1]}")
            # print(f"result = {result}\n")
    return result if (result > 0) else -result

def sobel(img):
    height = img.shape[0]
    width = img.shape[1]

    grad_x = np.zeros((height,width,3), np.uint8)
    grad_y = np.zeros((height,width,3), np.uint8)

    gray = cv.cvtColor(cv.GaussianBlur(img, (3, 3), 0), cv.COLOR_BGR2GRAY)
    cv.imshow('image gray', gray)

    new_image = np.zeros((height,width,3), np.uint8)

    blur_kernel = 0.1 * np.array([[1, 1, 1],
                                  [1, 2, 1],
                                  [1, 1, 1]])
    
    kernel_x = np.array([[-1, 0, 1],
                        [-2, 0, 2],
                        [-1, 0, 1]])
    kernel_y = -kernel_x.transpose()

    for i in range(height):
        for j in range(width):
            grad_x[i,j] = convolution(kernel_x, gray, i, j)
            grad_y[i,j] = convolution(kernel_y, gray, i, j)
            new_image[i,j] = 0.5 * grad_x[i,j] + 0.5 * grad_y[i,j]
    
    # abs_grad_x = cv.convertScaleAbs(grad_x)
    # abs_grad_y = cv.convertScaleAbs(grad_y)
    # new_image = cv.addWeighted(grad_x, 0.5, grad_y, 0.5, 0)
    return new_image

cv.imshow('final', sobel(img))
cv.waitKey(0)

# TODO:
# milyen interfészek vannak
# milyen gyorsan mennek, MHz


# használhatjuk szinkron, aszinkron fifot

# lehetőleg platform független legyen


# cycle accuratemodelling

# meg kell nézni hogy 

# fix pontos modelling
