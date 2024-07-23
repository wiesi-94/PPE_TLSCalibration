function disp_unknown_vector_std(x_vec, sigma_x, ap_count, scan_count)
%disp_unknown_vector_std: display each element of the unknown vector and
%its standard deviation
% input: 
% - x_vec: unknown parameters (aps + eps of each scan)
% - sigma_x: unknown parameters' standard deviation
% - ap_count: number of aps
% - scan_count: number of scans

global unknown_name
deg2rad_ratio=pi/180;

disp('APs:');
for i=1:ap_count
    fprintf('%s = %8.8f (rad)\t+-%5.8f (rad)\n', string(unknown_name(i)),x_vec(i), sigma_x(i));
end
fprintf('\n'); 

%disp('APs:')
%fprintf('A0 = %8.8f ( m )\t+-%5.8f ( m )\n\n',x_vec(1), sigma_x(1));
%fprintf('B2 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(1), sigma_x(1));
%fprintf('B3 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(2), sigma_x(2));
%fprintf('B4 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(3), sigma_x(3));
%fprintf('B5 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(4), sigma_x(4));
%fprintf('B6 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(5), sigma_x(5));
%fprintf('B7 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(6), sigma_x(6));
%fprintf('B8 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(7), sigma_x(7));
%fprintf('B9 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(8), sigma_x(8));
%fprintf('B10 = %8.8f (rad)\t+-%5.8f (rad)\n\n',x_vec(9), sigma_x(9));
%fprintf('C0 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(10), sigma_x(10));
%fprintf('C2 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(11), sigma_x(11));
%fprintf('C3 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(12), sigma_x(12));
%fprintf('C4 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(13), sigma_x(13));
%fprintf('C5 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(14), sigma_x(14));
%fprintf('C6 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(15), sigma_x(15));
%fprintf('C7 = %8.8f (rad)\t+-%5.8f (rad)\n',x_vec(16), sigma_x(16));
%fprintf('C8 = %8.8f (rad)\t+-%5.8f (rad)\n\n',x_vec(17), sigma_x(17));



for i=1:scan_count
    disp(['EPs of scan [', num2str(i), ']:']); 
    fprintf('omega = %8.3f (deg)\t+-%5.2f (mdeg)\n',x_vec(ap_count+6*i-5)/deg2rad_ratio, sigma_x(ap_count+6*i-5)/deg2rad_ratio*1e3);
    fprintf('phi   = %8.3f (deg)\t+-%5.2f (mdeg)\n',x_vec(ap_count+6*i-4)/deg2rad_ratio, sigma_x(ap_count+6*i-4)/deg2rad_ratio*1e3);
    fprintf('kappa = %8.3f (deg)\t+-%5.2f (mdeg)\n',x_vec(ap_count+6*i-3)/deg2rad_ratio, sigma_x(ap_count+6*i-3)/deg2rad_ratio*1e3);
    fprintf('X_s   = %8.3f ( m )\t+-%5.2f ( mm )\n',x_vec(ap_count+6*i-2), sigma_x(ap_count+6*i-2)*1e3);
    fprintf('Y_s   = %8.3f ( m )\t+-%5.2f ( mm )\n',x_vec(ap_count+6*i-1), sigma_x(ap_count+6*i-1)*1e3);
    fprintf('Z_s   = %8.3f ( m )\t+-%5.2f ( mm )\n\n',x_vec(ap_count+6*i), sigma_x(ap_count+6*i)*1e3);
end

end
