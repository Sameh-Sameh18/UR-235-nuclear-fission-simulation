%% Initialize figure 
figure();
hold on; 
axis equal;
grid on;
view(3);
lighting gouraud;
camlight headlight;
ur1 = imread('5006.jpg');  % Replace with the path to your image

%% Properties of the ur_235 nucleus
ur_radius = 2;
[u, v, w] = sphere(70);

%% Position of ur_235 nucleus
centerx = 0;
centery = 0;
centerz = 0;

%% Plot ur_235 nucleus
ur = surf(centerx + u*ur_radius, centery + v*ur_radius, centerz + w*ur_radius);
set(ur, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');

%% release the first nuetron to start the fission
nu_rad = 0.3;
% Position of the neutron
centerx_nu = 5;
centery_nu = 0;
centerz_nu = 0;

% Plot the neutron at the start position
nu_1st = surf(centerx_nu + u*nu_rad, centery_nu + v*nu_rad, centerz_nu + w*nu_rad);
set(nu_1st, 'FaceColor', 'y', 'EdgeColor', 'none');

% Animate the neutron moving towards the target position
numSteps = 100; % Number of steps in the animation
for i = 1:numSteps
    update = i / numSteps; % Interpolation factor
    
    % Compute the current position of the neutron
    new_centerx_nu = centerx_nu + update * (0 - centerx_nu);
    new_centery_nu = centery_nu + update * (0 - centery_nu);
    new_centerz_nu = centerz_nu + update * (0 - centerz_nu);
    
    % Update the neutron's position
    set(nu_1st, 'XData', new_centerx_nu + u*nu_rad);
    set(nu_1st, 'YData', new_centery_nu + v*nu_rad);
    set(nu_1st, 'ZData', new_centerz_nu + w*nu_rad);
    
    % Pause to create the animation effect
    pause(0.05);
end

% Delete the neutron
delete(nu_1st);

%% Split the nucleus into two nuclei

% Define the nuclei and neutron objects
objectsToFadeStage1 = {ur}; % List of objects to fade out in the first stage

% Fade out the initial nucleus
fadeOutAndDelete(objectsToFadeStage1, 10, 0.05);

% Make the two nuclei
ur_radius_new = ur_radius * 0.6; 
nuclei1 = surf(centerx + u*ur_radius_new - 3*ur_radius_new, centery + v*ur_radius_new, centerz + w*ur_radius_new);
nuclei2 = surf(centerx + u*ur_radius_new + 3*ur_radius_new, centery + v*ur_radius_new, centerz + w*ur_radius_new);

set(nuclei1, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');
set(nuclei2, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');


%% Emit neutrons at the first stage of fission (the most small spheres)
neutron_radius = 0.3;

for i = 1:3
    theta = rand * 2 * pi;
    phi = rand * pi; 
    neutronx = centerx + 5 * cos(theta) * sin(phi);
    neutrony = centery + 5 * sin(theta) * sin(phi);
    neutronz = centerz + 5 * cos(phi);

    neutron = surf(neutronx + neutron_radius*u, neutrony + neutron_radius*v, neutronz + neutron_radius*w);
    set(neutron, 'FaceColor', 'y', 'EdgeColor', 'none');
    comet3(neutronx, neutrony, neutronz);
end

pause(0.5);

%% Split the two nuclei into four smaller nuclei
% Define the nuclei and neutron objects
objectsToFadeStage2 = {nuclei1, nuclei2}; % List of objects to fade out in the second stage

% Fade out the two nuclei
fadeOutAndDelete(objectsToFadeStage2, 10, 0.05);

% Create the four smaller nuclei
ur_radius_new2 = neutron_radius * 2; 
nuclei1_1 = surf(centerx + u*ur_radius_new2 - 3*ur_radius_new2, centery + v*ur_radius_new2, centerz + w*ur_radius_new2);
nuclei1_2 = surf(centerx + u*ur_radius_new2, centery + v*ur_radius_new2, centerz + w*ur_radius_new2 + 3*ur_radius_new2);
nuclei2_1 = surf(centerx + u*ur_radius_new2, centery + v*ur_radius_new2 - 2*ur_radius_new2, centerz + w*ur_radius_new2);
nuclei2_2 = surf(centerx + u*ur_radius_new2 + 2*ur_radius_new2, centery + v*ur_radius_new2, centerz + w*ur_radius_new2);

set(nuclei1_1, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');
set(nuclei1_2, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');
set(nuclei2_1, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');
set(nuclei2_2, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');


%% Emit neutrons at the second stage of fission
for j = 1:8
    theta = rand * 2 * pi;
    phi = rand * pi; 
    neutronx_2 = centerx + 5 * cos(theta) * sin(phi);
    neutrony_2 = centery + 5 * sin(theta) * sin(phi);
    neutronz_2 = centerz + 5 * cos(phi);

    neutron = surf(neutronx_2 + neutron_radius*u, neutrony_2 + neutron_radius*v, neutronz_2 + neutron_radius*w);
    set(neutron, 'FaceColor', 'y', 'EdgeColor', 'none');
    comet3(neutronx_2, neutrony_2, neutronz_2);
end

pause(0.5);

%% Split the rest nuclei into uranium-235 neutrons
% Define the nuclei and neutron objects
objectsToFadeStage3 = {nuclei1_1, nuclei1_2, nuclei2_1, nuclei2_2}; % List of objects to fade out in the third stage

% Fade out the four nuclei
fadeOutAndDelete(objectsToFadeStage3, 10, 0.05);

% Create uranium-235 neutrons
ur_radius_new3 = neutron_radius;
for k = 1:8
    theta = rand * 2 * pi;
    phi = rand * pi; 
    ur_neutronx_3 = centerx + 3 * cos(theta) * sin(phi);
    ur_neutrony_3 = centery + 3 * sin(theta) * sin(phi);
    ur_neutronz_3 = centerz + 3 * cos(phi);

    ur_neutron = surf(ur_neutronx_3 + neutron_radius*u, ur_neutrony_3 + neutron_radius*v, ur_neutronz_3 + neutron_radius*w);

    set(ur_neutron, 'FaceColor', 'texturemap', 'CData', ur1,'EdgeColor', 'none');

    comet3(ur_neutronx_3, ur_neutrony_3, ur_neutronz_3);
end

%% Emit neutrons at the third stage of fission
for j = 1:16
    theta = rand * 2 * pi;
    phi = rand * pi; 
    neutronx_3 = centerx + 5 * cos(theta) * sin(phi);
    neutrony_3 = centery + 5 * sin(theta) * sin(phi);
    neutronz_3 = centerz + 5 * cos(phi);

    neutron = surf(neutronx_3 + neutron_radius*u, neutrony_3 + neutron_radius*v, neutronz_3 + neutron_radius*w);
    set(neutron, 'FaceColor', 'y', 'EdgeColor', 'none');
    comet3(neutronx_3, neutrony_3, neutronz_3);
end

%% Function to fade out and delete objects
function fadeOutAndDelete(objects, steps, pauseDuration)
    numObjects = length(objects);
    for k = 1:steps
        alpha = 1 - k/steps; % Calculate the new alpha value
        for i = 1:numObjects
            if isvalid(objects{i}) && isprop(objects{i}, 'FaceAlpha')
                set(objects{i}, 'FaceAlpha', alpha); % Set the new alpha value
            end
        end
        pause(pauseDuration); % Pause to create the fading effect
    end
    for i = 1:numObjects
        if isvalid(objects{i})
            delete(objects{i}); % Finally delete the object
        end
    end
end