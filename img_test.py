# import pandas as p
import numpy as np
# from PIL import Image
# from PIL import ImageFilter
# from pathlib import Path
# import math
from matplotlib import pyplot as plt
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


# kernel = np.ones((5,5),np.float32)/25
kernel = np.array([[1, 0, -1],
                   [2, 0, -2],
                   [1, 0, -1]])
dst = cv.filter2D(img,-1,kernel)

cv.imshow('dst', dst)
cv.imshow('goldi', img)

plt.subplot(121),plt.imshow(goldi),plt.title('Original')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(dst),plt.title('Averaging')
plt.xticks([]), plt.yticks([])
plt.show()


blur = cv.blur(img,(5,5))

plt.subplot(121),plt.imshow(img),plt.title('Original')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(blur),plt.title('Blurred')
plt.xticks([]), plt.yticks([])
plt.show()

def 

for i in range(rows):
    for j in range(cols):
        new_image[i,j] = convolution(kernel, img, i, j)


# TODO:
# milyen interfészek vannak
# milyen gyorsan mennek, MHz




