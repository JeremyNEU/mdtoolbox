function [x, com] = decenter(x, index, mass)
%%decenter 
% remove the center of mass from coordinates or velocities
%
%% Syntax
%# [x, com] = decenter(x);
%# [x, com] = decenter(x, index);
%# [x, com] = decenter(x, index, mass);
%# [x, com] = decenter(x, [], mass);
%
%% Description
% Calculate the center of 'mass' from given coordinates
% specified by 'index'.
% When 'index' is omitted, the center of all the coordinates are
% calculated.
% When 'mass' is ommited, uniform weights are assumed. 
%
% * x          - XYZ coordinates of atoms in order
%                (x(1) y(1) z(1) x(2) y(2) z(2) ... x(natom))
%                [nstep x natom3 double]
% * index      - index of atoms from which the center of mass are
%                calculated [1 x n integer]
% * mass       - atom masses [1 x natom double]
% * x (output) - XYZ coordinates of atoms where the centers of mass
%                are removed. [nstep x natom3 double]
% * com        - centers of mass [nstep x 3]
%
%% Example
% trj = readdcd('ak.dcd');
% 
% 
%
%% References
% 
%

%% setup
nstep = size(x, 1);
natom3 = size(x, 2);
natom = natom3/3;
com = zeros(nstep, 3);

if nargin == 1
  mass = ones(1, natom);
end

if nargin <= 2
  index = 1:natom;
end

assert(isequal(size(x, 2)/3, numel(mass)), ...
       ['sizes of coordinates and masses are not consistent'])

indexx = 3.*(index-1) + 1;
indexy = 3.*(index-1) + 2;
indexz = 3.*(index-1) + 3;

totalMass = sum(mass(index));

%% calculate the center of mass
com(:, 1) = sum(bsxfun(@times, mass(index), x(:, indexx)), 2) ./ totalMass;
com(:, 2) = sum(bsxfun(@times, mass(index), x(:, indexy)), 2) ./ totalMass;
com(:, 3) = sum(bsxfun(@times, mass(index), x(:, indexz)), 2) ./ totalMass;

%% subtract the center of mass
x(:, 1:3:end) = bsxfun(@minus, x(:, 1:3:end), com(:, 1));
x(:, 2:3:end) = bsxfun(@minus, x(:, 2:3:end), com(:, 2));
x(:, 3:3:end) = bsxfun(@minus, x(:, 3:3:end), com(:, 3));
