function map_result = disparity_mapping(Pl, Pr, t_height, t_width)

[P_height, P_width] = size(Pl);
map_result = ones(P_height, P_width);

t_height_center = idivide(t_height,int32(2));
t_width_center = idivide(t_width, int32(2));

% define search constraint to small values of disparity (<15).
s_limit = 14;

% Iterate through all pixels in Pl
for y = t_height_center+1 : P_height-t_height_center
    for x = t_width_center+1 : P_width-t_width_center
        % Extract image patch T region around the pixel
        T = Pr(y-t_height_center : y+t_height_center, x-t_width_center : x+t_width_center);
        T_flipped = rot90(T,2);
        % Extract template region of image I around the pixel
        I = Pl(y-t_height_center : y+t_height_center, max(x-s_limit,t_width_center)  : min(x+s_limit,P_width));
        % Compute SSD using the alternative approach 
        S = conv2(I.^2, ones(t_height, t_width), 'same') ... % 1st part
            + sum(sum(T_flipped.^2)) ...   % 2nd part
            - 2*conv2(I, T_flipped, 'same'); %3rd part
        % Use `find` function to get the indices (relative x-coord) of 
        % minimum SSD within the specified search range
        xr = find(S(t_width_center+1, :) == min(S(t_width_center+1, :)), 1);
        % Get the disparity value, which in our case is how far our point
        % from (x-s_limit: x+s_limit) to midpoint indices 
        map_result(y, x) = idivide(size(S,2),int8(2))-xr;
    end
end