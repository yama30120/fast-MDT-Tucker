# fast MDT-Tucker

This code implements fast algorithm for low-rank tensor completion in delay embedded space.

This directory contains the MATLAB code of the proposed method (Fast-MDT-Tucker) as following:
  - data/
  - Function_Fast_MDT_Tucker/
  - demo.m
  - README.md (this file)

"data" contains the original and missing Lena images and they are compacted by the "mat" file.
"Function_Fast_MDT_Tucker" contains the function for the proposed method.
"demo.m" is a sample MATLAB code of completing 95% random voxel missing lena image.


## demo
### image
![image_original](./data/image/airplane.png)
![image_missing](./data/image/airplane_90_missing.png)
![image_recover](./result/image/completed_airplane_90_missing.png)
### mri
![mri_original](./result/mri/original.png)
![mri_original](./result/mri/missing.png)
![mri_original](./result/mri/recovered.png)
### video
![hoge](./result/video/result.gif)