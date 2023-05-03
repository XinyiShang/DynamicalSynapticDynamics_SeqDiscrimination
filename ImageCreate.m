% Load the images
image1 = imread('ImageSave/Threshold/1.png');
image2 = imread('ImageSave/Threshold/2.png');
image3 = imread('ImageSave/Threshold/3.png');
image4 = imread('ImageSave/Threshold/4.png');

% Create a figure with 2 rows and 2 columns
figure;
subplot(2, 2, 1);
imshow(image1);
title('Image 1');
xlabel('X Label 1');
ylabel('Y Label 1');

subplot(2, 2, 2);
imshow(image2);
title('Image 2');
xlabel('X Label 2');
ylabel('Y Label 2');

subplot(2, 2, 3);
imshow(image3);
title('Image 3');
xlabel('X Label 3');
ylabel('Y Label 3');

subplot(2, 2, 4);
imshow(image4);
title('Image 4');
xlabel('X Label 4');
ylabel('Y Label 4');

% Concatenate the images into a large image
%large_image = [horzcat(image1, image2); horzcat(image3, image4)];

% Display the large image
figure;
imshow(large_image);
title('Concatenated Image');
