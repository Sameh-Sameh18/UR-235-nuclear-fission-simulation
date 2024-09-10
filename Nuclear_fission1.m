clear;
clc;

%% Constants 
amu_unit = 1.66054e-27; % atomic mass unit (amu) in KG
one_ur235_atom_mass = 235.043929 * amu_unit; % mass of one U-235 atom in KG
ur235_neutron_mass = 1.008665 * amu_unit; % neutron mass in KG
gamma_freq = 2.2941e21; % gamma frequency in Hz
Ke_ur235_fragments = 170; % kinetic energy of U-235 fragments in MeV
Ke_fastNeutron = 5; % kinetic energy of fast neutrons in MeV
Energy_Neutrons = 15; % energy of neutrons in MeV
Plank_const = 6.62607015e-34; % Planck's constant in J*s
elec = 1.6018e-19; % electron charge in coulombs
speed_of_light = 3e8; % speed of light in m/s
av_const = 6.02214e23; % Avogadro's number
energy_density_TNT = 4.18e6; % energy density of TNT in J/kg

%% Inputs
Mass = input('Please enter the mass in grams: ');
n0 = input('Please enter the number of neutrons (suggested 1e6 or higher): ');

%% Equations
Energy_gamma = Plank_const * gamma_freq * 1e-6 / elec; % gamma energy in MeV
Energy_per_fission = Ke_fastNeutron + Ke_ur235_fragments + Energy_gamma + Energy_Neutrons; % total energy in MeV
Energy_per_fission_j = Energy_per_fission * 1.6018e-13; % energy per fission in joules
Mass_deficit = Energy_per_fission_j / (speed_of_light^2); % mass deficit per fission in Kg
Num_of_moles = (Mass / 1000) / one_ur235_atom_mass; % number of moles of U-235
Num_of_atoms = Num_of_moles * av_const; % number of U-235 atoms

%% Steps Calculation
steps_num = floor(log2(Num_of_atoms) + 1); % number of steps for the chain reaction

%% Preallocation
neutrons = zeros(1, steps_num);
mass_loss = zeros(1, steps_num);
energy_output = zeros(1, steps_num);

%% Modeling
neutrons(1) = n0;

for i = 2:steps_num
    energy_output(i) = neutrons(i-1) * Energy_per_fission_j;
    neutrons(i) = neutrons(i-1) * 1.222; % reproduction factor for U-235
    mass_loss(i) = neutrons(i-1) * Mass_deficit;
end

total_energy = sum(energy_output); % Total energy in joules
fprintf('The output energy = %0.9f joules \n', total_energy);

%% Energy Destruction Calculation
mass_destroyed = total_energy / energy_density_TNT; % Mass of TNT equivalent to the energy output in kg

% Assuming the area affected by the energy is circular
radius_destroyed_km = sqrt(mass_destroyed * 1e-3 / pi); % radius in kilometers
area_destroyed_km2 = pi * (radius_destroyed_km^2); % area in square kilometers

%% Earth Surface Area Calculation
earth_radius_km = 6371; % Earth's radius in kilometers
earth_surface_area_km2 = 4 * pi * earth_radius_km^2; % Surface area of Earth in km^2

%% Display Results
fprintf('The energy output can destroy an area of approximately %0.3f square kilometers \n', area_destroyed_km2);
fprintf('The surface area of the Earth is approximately %0.2e square kilometers \n', earth_surface_area_km2);
fprintf("The percentage of the Earth\'s surface area affected = %0.6f%% \n", (area_destroyed_km2 / earth_surface_area_km2) * 100);

%% Plotting
figure();
subplot(2, 2, 1);
plot(1:steps_num, neutrons, '-g');
grid on;
xlabel('Number of steps');
ylabel('Number of Neutrons');

subplot(2, 2, 2);
plot(1:steps_num, mass_loss, '-g');
grid on;
xlabel('Number of steps');
ylabel('Mass loss (Kg)');

subplot(2, 2, 3);
plot(1:steps_num, energy_output, '-g');
grid on;
xlabel('Number of steps');
ylabel('Energy per Step (joules)');

subplot(2, 2, 4);
total_energy = cumsum(energy_output);
plot(1:steps_num, total_energy, '-c');
xlabel('Number of Steps');
ylabel('Total Energy (joules)');
grid on;


% Create the sphere representing the Earth
[earthX, earthY, earthZ] = sphere(50);

% Load Earth's texture map (an image of Earth's surface)
earthTexture = imread('sam.jpg');  % Replace with the path to your image

% Create the figure
figure;

% Create the surface and apply the texture
earth = surf(earthX, earthY, earthZ);
set(earth, 'FaceColor', 'texturemap', 'CData', earthTexture, 'EdgeColor', 'none');

% Set the view and axis properties
axis equal;
view(3);
axis off;

% Add lighting
light;
lighting gouraud; % Smooth lighting

%% Calculate Destruction Percentage
% Calculate the percentage of Earth's surface area to destroy dynamically
percent_destroyed = (area_destroyed_km2 / earth_surface_area_km2) * 100;

% Translate percentage destroyed into a z-threshold (Z-coordinates on the sphere)
threshold = (1 - (percent_destroyed / 100)) * max(earthZ(:));

% Create the mask where Z >= threshold (destroying the top portion)
mask = earthZ >= threshold;  % Retain the portion below the threshold

% Apply the mask to the texture and the coordinates
earthX(mask) = NaN;
earthY(mask) = NaN;
earthZ(mask) = NaN;

% Update the surface data with the masked values (removing destroyed part)
set(earth, 'XData', earthX, 'YData', earthY, 'ZData', earthZ);

% Rotate the sphere to simulate a 3D view
rotate(earth, [0 1 0], 45);

% Add lighting
light;
lighting gouraud; % Use smoother lighting
