function [edge_bin] = edge_detect(input_image_gray,sobel_kx,sobel_ky,threshold)

% Apply convolution to detect edges in both directions
edge_x = conv2(input_image_gray, sobel_kx, 'same');
edge_y = conv2(input_image_gray, sobel_ky, 'same');

% Combine the gradients to get edge magnitude
edge_mag = sqrt(edge_x.^2 + edge_y.^2);

% Normalize to [0, 1] range
edge_mag = edge_mag / max(edge_mag(:));

% Apply threshold to create binary edge map
edge_bin = edge_mag > threshold;

end