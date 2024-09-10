% Create the sphere representing the Earth
[earthX, earthY, earthZ] = sphere(50);

% Load Earth's texture map (an image of Earth's surface)
earthTexture = imread('sam.jpg');  % Replace with the path to your image

% Create the figure
figure;

% Create the surface and apply the texture
earth = surf(earthX, earthY, earthZ);
set(earth, 'FaceColor', 'texturemap', 'CData', earthTexture,'EdgeColor', 'none');

% Set the view and axis properties
axis equal;
view(3);
axis off;

% Apply rotation to the sphere (e.g., rotate 45 degrees around the Y-axis)
rotate(earth, [0 1 0], 45);

% Add lighting
light;
lighting none;
% 
% % Continuous rotation (animation)
% for angle = 1:360
%     rotate(earth, [0 1 0], 1);  % Rotate by 1 degree around the Y-axis
%     pause(0.01);  % Adjust the pause for smoother/slower animation
% end

