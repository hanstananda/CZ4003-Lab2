%% 3.2 Line Finding using Hough Transform
%% a. Load Image
Pc = imread('macritchie.jpg');
% Change Image to grayscale
P = rgb2gray(Pc);
% Image computed via the Canny algorithm with sigma=1.0
tl = 0.04;
th = 0.1;
sigma = 1.0;

E = edge(P, 'canny', [tl th], sigma);
figure;
imshow(E);
title('Image of edges filtered by Canny with \sigma=1');
%% B. Radon transform
[H, xp] = radon(E);
figure;
imshow(uint8(H));
title('Image of Hough transform');
%% C. Find location of maximum pixel intensity in Hough image
[radius, theta]=find(H>=max(max(H)));
radius,theta
%% D. Derive the equations to convert the [theta, radius] line representation to the normal line equation form Ax + By = C
radius = xp(radius);
[A, B] = pol2cart(theta*pi/180, radius);
% negated because the y-axis is pointing downwards for image coordinates.
B = - B;
%% Find C 
% We need to convert back from hough transform with respect to origin at centre to image coordinates where the origin is in the top-left corner of the image
% Calculate center of image
[sY, sX]= size(P);
tX = sX/2;
tY = sY/2;
C = A*(A+tX) + B*(B+tY);
C

%% E. compute yl and yr values for corresponding xl = 0 and xr = width of image - 1
% define xl and xr
xl = 0;
xr = sX-1;
% calculate yl and yr
yl = (C - A * xl) / B;
yr = (C - A * xr) / B;
yl,yr
%% F. Display the original ‘macritchie.jpg’ superimposed with estimated line 
figure;
imshow(P);
line([xl xr], [yl yr]);
title('Original image superimposed with estimated line');
%% Fix the line to match up more closely with the edge 

% Image computed via the Canny algorithm with sigma=5.0
tl = 0.04;
th = 0.1;
sigma = 5.0;

E = edge(P, 'canny', [tl th], sigma);

% Radon transform
[H, xp] = radon(E);

% Find maximum pixel intensity 
[radius, theta]=find(H>=max(max(H)));
radius = xp(radius);
% Find C 
[A, B] = pol2cart(theta*pi/180, radius);
B = - B;
[sY, sX]= size(P);
tX = sX/2;
tY = sY/2;
C = A*(A+tX) + B*(B+tY);

% compute yl and yr values for corresponding xl = 0 and xr = width of image - 1
% define xl and xr
xl = 0;
xr = sX-1;
% calculate yl and yr
yl = (C - A * xl) / B;
yr = (C - A * xr) / B;

% Display the original ‘macritchie.jpg’ superimposed with estimated line 
figure;
imshow(P);
line([xl xr], [yl yr]);
title('Original image superimposed with estimated line');