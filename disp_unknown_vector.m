function disp_unknown_vector(x_vec, ap_count, scan_count)
%disp_unknown_vector: display each element of the unknown vector
% input: 
% - x_vec: unknown parameters (aps + eps of each scan)
% - ap_count: number of aps
% - scan_count: number of scans


global unknown_name
deg2rad_ratio=pi/180;

 disp('APs:');
 for i=1:ap_count
    fprintf('%s = %.8f\n',string(unknown_name(i)),x_vec(i)); 
 end
 fprintf('\n'); 



for i=1:scan_count
    disp(['EPs of scan [', num2str(i), ']:']); 
    fprintf('omega = %8.3f (deg)\n',x_vec(ap_count+6*i-5)/deg2rad_ratio);
    fprintf('phi   = %8.3f (deg)\n',x_vec(ap_count+6*i-4)/deg2rad_ratio);
    fprintf('kappa = %8.3f (deg)\n',x_vec(ap_count+6*i-3)/deg2rad_ratio);
    fprintf('X_s   = %8.3f ( m )\n',x_vec(ap_count+6*i-2));
    fprintf('Y_s   = %8.3f ( m )\n',x_vec(ap_count+6*i-1));
    fprintf('Z_s   = %8.3f ( m )\n\n',x_vec(ap_count+6*i));
end

end

