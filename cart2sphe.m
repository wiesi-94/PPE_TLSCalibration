function pol_points= cart2sphe(cart_points)
% cart2sphe: transformation from cartesian to polar (spherical) coordinates system.
%   Input:  xyz (n x 3) 'cart_points' in cartesian coordinate system
%   Output: rho theta alpha (n x 3) 'pol_points' in polar coordinate
%   system, angle unit: rad

rho = batchnorm(cart_points);                                  % range

%theta = atan2(cart_points(:,2),cart_points(:,1));               % horizontal angle (rad) 
theta = atan(cart_points(:,2)*-1./cart_points(:,1));               % horizontal angle (rad)
for i=1:size(cart_points,1) %correction for Faro Laser Scanner
    if (cart_points(i,1) < 0 && cart_points(i,2) < 0 && theta(i,1) < 0)
        theta(i,1) = theta(i,1) + pi;
    end
    if (cart_points(i,1) > 0 && cart_points(i,2) > 0 && theta(i,1) < 0)
        theta(i,1) = theta(i,1) + pi;
    end
end

%alpha = atan2(cart_points(:,3),batchnorm(cart_points(:,1:2))); % vertical (elevation) angle (rad)
alpha = atan(cart_points(:,3)./batchnorm(cart_points(:,1:2))); % vertical (elevation) angle (rad)
for i=1:size(cart_points,1) %correction for Faro Laser Scanner
    if (cart_points(i,2) > 0)
        alpha(i,1) = pi - alpha(i,1); 
    end
end



pol_points= [rho,theta,alpha];

end