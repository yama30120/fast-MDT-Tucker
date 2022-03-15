# fast MDT-Tucker

This code implements fast algorithm for low-rank tensor completion in delay embedded space.

```data/image/``` contains the original and missing(90%/95%) airplane images and they are compacted by the "mat" file.
```Function_Fast_MDT_Tucker/``` contains the function for the proposed method.
```completion_fast_mdt_tucker.m``` and ```fast_mdt_tucker_rank_inc.m``` are main functions.
The others are utility functions to implement our proposed algorithm.

```demo_image.m```, ```demo_mri.m```, ```demo_video.m``` are sample MATLAB codes with fast-MDT-Tucker.

```movie2gif.m``` is a function to make gif animation. 

## Demo results
demo program results following:

### image
This result can be obtained by ```demo_image.m```.

- 90% missing airplane image (Original/Missing/Recovered)

![image_original](./data/image/airplane.png)![image_missing](./data/image/airplane_90_missing.png)![image_recover](./result/image/completed_airplane_90_missing.png)

- 95% missing airplane image (Original/Missing/Recovered)

![image_original](./data/image/airplane.png)![image_missing](./data/image/airplane_95_missing.png)![image_recover](./result/image/completed_airplane_95_missing.png)

### MRI
This result can be obtained by ```demo_mri.m```.

- Original 
![mri_original](./result/mri/original.png)

- Missing(90%)
![mri_original](./result/mri/missing.png)

- Recovered
![mri_original](./result/mri/recovered.png)

### video
This result can be obtained by ```demo_video.m```.

- Result gif (Original/Missing/Recovered)
![hoge](./result/video/result.gif)