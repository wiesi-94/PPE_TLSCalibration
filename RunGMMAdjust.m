function [x_0, Q_xx_mat, res_vec] = RunGMMAdjust(adjustment_data_struct)
%RunGMMAdjust: do iterative incremental parameter estimation based on the Gauss-Markow Model(GMM)         
%input: adjustment_data_struct, whose fields are listed as follows:
%  - x: initial guess of unknown vector
%  - y: observation vector
%  - P: weight matrix
%  - sigma_0: unit weight standard deviation
%  - dt: auto-derivative increment value
%  - op: object points' coordinate in cartesian system
%  - scans: a cell storing the measurements of the object points in each
%  scan's spherical system
%  - ap_count: number of the additional parameters
%  - max_iter_count: maximum iteration number of the inner-loop
%  - incre_ratio_thre: threshold for the ratio of the unknown value's
%  increment of the adjacent iterations, once the largest increment ratio
%  among the elements in the unknown vector is smaller than this threshold,
%  the loop would be regarded as converged
%  - outlier_mask: mask vector for the measurements, 0 and 1 indicate the
%  outlier and inlier respectively


x_0=adjustment_data_struct.x;
y=adjustment_data_struct.y;
P_mat=adjustment_data_struct.P;
sigma_0=adjustment_data_struct.sigma_0;
dt=adjustment_data_struct.dt;
ops=adjustment_data_struct.op;
scans_sphe=adjustment_data_struct.scans;
ap_count=adjustment_data_struct.ap_count;
inlier_index = find(adjustment_data_struct.outlier_mask);
outlier_index = find(~adjustment_data_struct.outlier_mask);

scan_count=length(scans_sphe);        %s
op_count=size(ops,1);                 %N
unknown_count=ap_count+6*scan_count;  %u
ob_count=3*op_count*scan_count;       %n


iter_count = 1;
is_converged = 0;
d_x_last = zeros(unknown_count,1);

% Internal Iteration 
% TODO
while (iter_count < adjustment_data_struct.max_iter_count && ~is_converged)
     
    % Caculate A matrix (Jocubians) by numerical derivative 
    % Allocate
    ob_index = 1;
    A_mat = zeros(ob_count,unknown_count);
    b_vec = zeros(ob_count,1);
    
    for i = 1:scan_count  % scan i
       cur_scan_sphe = scans_sphe{1,i};
       for j = 1:op_count  % object point j
          for k = 1:unknown_count % calculate derivative for APs
              % numerical derivative
              unknown_scan_index = floor((k-ap_count-1)/ 6) +1;
              % assign A matrix (design)
              if (k <= ap_count | i==unknown_scan_index)    
                  A_mat(ob_index:ob_index+2, k) = Derivative(ops(j,:), cur_scan_sphe(j,:), ...
                     x_0(1:ap_count), x_0(ap_count+(i-1)*6+1:ap_count+i*6),dt, k);
              end
          end
          % assign b vector (observation)
          obs= ObsFunction(ops(j,:), cur_scan_sphe(j,:), x_0(1:ap_count),...
                  x_0(ap_count+(i-1)*6+1:ap_count+i*6));
          y_cur =y(ob_index:ob_index+2,1);
          b_vec(ob_index:ob_index+2 ,1) = y_cur - obs; % current residual
          ob_index = ob_index+3;

          if (x_0(6) > 0.1 || x_0(6) < -0.1)
              x_0(6) = 0.0;
              disp ('AP A0 fare off -> set to zero');
          end

         end
    end
    
    % apply the outlier mask
    A_mat_in = A_mat(inlier_index,:);
    P_mat_in = P_mat(inlier_index,inlier_index);
    b_vec_in = b_vec(inlier_index);
    
    % Conduct adjustment (get the increment of unknown vector for current iteration)
    N_mat=(A_mat_in' * P_mat_in * A_mat_in);  % normal matrix
    Q_xx_mat = N_mat^(-1);
    d_x =Q_xx_mat * (A_mat_in' * P_mat_in * b_vec_in);
    
    res_vec= A_mat*d_x -b_vec;  % residual
    %res_vec(outlier_index) = 0; % we do not want to involve them in Danish methods updating
    
    %disp(['Increment of the unknown vector of iteration [', num2str(iter_count) , ']:', num2str(x_i)]);
    
    x_0 = x_0 + d_x; % update the unknown vector
    
    disp (['adjustment iteration [', num2str(iter_count),'] done']);
    
    % judge if the convergence is reached
    if(iter_count>1 && max(abs(d_x)) < adjustment_data_struct.incre_ratio_thre) % for example : 1e-4
    %if(iter_count>1 && max(abs(d_x./d_x_last)) <
    %adjustment_data_struct.incre_ratio_thre) % for example : 1e-2
        is_converged = 1;
        disp ('Inner-loop Converged'); 
    end
    
    % update
    for i=1:scan_count % keep the angle under the bound of [-pi pi]
        x_0(ap_count+6*i-5:ap_count+6*i-3) = wrapToPi(x_0(ap_count+6*i-5:ap_count+6*i-3));
    end
    
    iter_count = iter_count + 1;
    %d_x_last = d_x;
    
end

% why do you not give out just x_0 instead of saving it separatly as x_p
% solved (directly use x_0) -- Yue
 
disp('Current adjustment results of the unknown vector:');
disp_unknown_vector(x_0,ap_count,scan_count);


        



