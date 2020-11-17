%% 3.1 Edge Detection
%% a. Load Image
Pc = imread('macritchie.jpg');
% Change Image to grayscale
P = rgb2gray(Pc);
whos P
%% Display the Image 
figure;
imshow(P);
title('Original image P in grayscale');
%% b. Create 3x3 horizontal and vertical Sobel masks
sobel_horizontal_mask = [-1 -2 -1; 0 0 0; 1 2 1];
sobel_vertical_mask = [-1 0 1; -2 0 2; -1 0 1];

%% filter the image using conv2 and display the filtered images
Gx = conv2(P,sobel_horizontal_mask);

figure;
imshow(uint8(Gx));
title('Image of Gx, value of image filtered by horizontal mask');
figure;
imshow(uint8(Gy));
title('Image of Gy, value of image filtered by vertical mask');

%% Display the absolute value of the filtered images 

figure;
imshow(uint8(abs(Gx)));
title('Image of |Gx|, absolute value of image after filtered by horizontal mask');

Gy = conv2(P,sobel_vertical_mask);
figure;
imshow(uint8(abs(Gy)));
title('Image of |Gy|, absolute value of image after filtered by vertical mask');


%% Generate a combined edge image by squaring (i.e. .^2) Gx and Gy
combined_Gx_Gy = Gx.^2 + Gy.^2;
figure;
imshow(uint8(combined_Gx_Gy));
title('Image of Gx^2+Gy^2');

combined_Gx_Gy_sqrt = sqrt(combined_Gx_Gy);
figure;
imshow(uint8(combined_Gx_Gy_sqrt));
title('Image of \surd (Gx^2+Gy^2)');

%% linar stretch/squeeze the resulting values of sqrt(Gx^2+Gy^2) to 0-255 to display it correctly in an image
min_E_threshold = min(combined_Gx_Gy_sqrt(:));
max_E_threshold = max(combined_Gx_Gy_sqrt(:));

E = 255*(combined_Gx_Gy_sqrt - min_E_threshold)/(max_E_threshold-min_E_threshold);
figure;
imshow(uint8(E));
title('Image of \surd(Gx^2+Gy^2) after linear image stretching');

%% d. Threshold the edge image E

Et = E > 10;
figure;
imshow(Et);
title('Image of Et=E>t, where t>10');

Et = E > 25; 
figure;
imshow(Et);
title('Image of Et=E>t, where t>25');

Et = E > 50;
figure;
imshow(Et);
title('Image of Et=E>t, where t>50');

Et = E > 100;
figure;
imshow(Et);
title('Image of Et=E>t, where t>100');

%% e. Using Canny edge detection

tl = 0.04;
th = 0.1;
sigma = 1.0;

P_canny_s1 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s1);
title('Image of edges filtered by Canny');

%% (i) Canny edge detection with different values of sigma ranging from 1.0 to 5.0
%% %% \sigma=1 (original)
sigma = 1;
P_canny_s1_5 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s1_5);
title('Image of edges filtered by Canny with \sigma=1');
%% \sigma=1.5
sigma = 1.5;
P_canny_s1_5 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s1_5);
title('Image of edges filtered by Canny with \sigma=1.5');
%% \sigma=2
sigma = 2.0;
P_canny_s2 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s2);
title('Image of edges filtered by Canny with \sigma=2');
%% \sigma=3
sigma = 3.0;
P_canny_s3 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s3);
title('Image of edges filtered by Canny with \sigma=3');
%% \sigma=4
sigma = 4.0;
P_canny_s4 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s4);
title('Image of edges filtered by Canny with \sigma=4');
%% \sigma=5
sigma = 5.0;
P_canny_s5 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_s5);
title('Image of edges filtered by Canny with \sigma=5');

%% (ii) Canny edge detection with different values of tl. 
sigma = 1.0;
%% tl=0.01
tl = 0.01;
P_canny_tl_1 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_tl_1);
title('Image of edges filtered by Canny with \tl=0.01');
%% tl=0.02
tl = 0.02;
P_canny_tl_2 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_tl_2);
title('Image of edges filtered by Canny with \tl=0.02');
%% tl=0.06
tl = 0.06;
P_canny_tl_6 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_tl_6);
title('Image of edges filtered by Canny with \tl=0.06');
%% tl=0.08
tl = 0.08;
P_canny_tl_8 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_tl_8);
title('Image of edges filtered by Canny with \tl=0.08');
%% tl=0.09
tl = 0.09;
P_canny_tl_9 = edge(P, 'canny', [tl th], sigma);
figure;
imshow(P_canny_tl_9);
title('Image of edges filtered by Canny with \tl=0.09');

