import cv2
import numpy as np

load = cv2.imread('Python.jpg', 1 )
width, height = load.shape[1],load.shape[0]

trans = np.float32([[1, 0, 100], [0,1,50]])
img_trans = cv2.warpAffine(load,trans (width, height))

cv2.inshow('Image yang digeser', img_trans)

cv2.waitKey(0)
cv2.destroyAllWindows()