import pandas as p
import numpy as np
from PIL import Image
from pathlib import Path

def roll(im, delta):
    """Roll an image sideways."""
    xsize, ysize = im.size

    delta = delta % xsize
    if delta == 0:
        return im

    part1 = im.crop((0, 0, delta, ysize))
    part2 = im.crop((delta, 0, xsize, ysize))
    im.paste(part1, (xsize - delta, 0, xsize, ysize))
    im.paste(part2, (0, 0, xsize - delta, ysize))

    return im

def filter(im, filter):
    return im


# print(Path.cwd())

try: 
    im  = Image.open("kutya.jpg") 
except IOError:
    pass

im.show()




