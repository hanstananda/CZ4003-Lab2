%% 3.2 Disparity Map Estimation
%% A. Disparity map algorithm (Implemented in disparity_mapping.m)

% This is done in disparity_mapping.m file

%% B. Load stereo pair images and convert to grayscale

Pc_left = imread('corridorl.jpg');
P_left = rgb2gray(Pc_left);
Pc_right = imread('corridorr.jpg');
P_right = rgb2gray(Pc_right);
figure; 
imshowpair(P_left, P_right, 'montage');
title('Stereo pair images');

%% C. Obtain a disparity map D, and see the result
D = disparity_mapping(im2double(P_left), im2double(P_right), 11, 11);
% D = disparity_mapping(P_left, P_right);
figure;
imshow(-D, [-15 15]);
title('Disparity image result');
P_disp = imread('corridor_disp.jpg');
figure;
imshow(P_disp);
title('Base disparity image');

%% D. Rerun algorithm on the real images of 'triclops-i2l.jpg' and 'triclops-i2r.jpg'

Ptc_left = imread('triclops-i2l.jpg');
Pt_left = rgb2gray(Ptc_left);
Ptc_right = imread('triclops-i2r.jpg');
Pt_right = rgb2gray(Ptc_right);

figure; 
imshowpair(Pt_left, Pt_right, 'montage');
title('Stereo pair images');

D = disparity_mapping(im2double(Pt_left), im2double(Pt_right), 11, 11);
figure;
imshow(-D, [-15 15]);
title('Disparity image result');
Pt_disp = imread('triclops-id.jpg');
figure;
imshow(Pt_disp);
title('Base disparity image');