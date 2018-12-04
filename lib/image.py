from PIL import Image
import numpy as np

def show(arr):
  img_arr = np.array(arr)
  img = Image.fromarray(np.uint8(img_arr))
  img.show()
