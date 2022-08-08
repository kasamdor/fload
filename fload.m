% The function is a much faster analog of default MATLAB load function. 
% Inputs:
% * fp - file path
% * hl - number of header lines to ignore
% Output:
% * a  - double array
function a = fload(fp, hl)
    %% arguments check 
    assert(hl >= 0, 'Number of header lines is incorrect.');
    assert(exist(fp, 'file') > 0, 'File %s does not exist.', fp);
    %% file opening
    fid = fopen(fp, 'r');
    assert(fid ~= -1, 'File %s can not be read.', fp);
    cuo = onCleanup(@() fclose(fid));
    %% columns number
    % skipping of header lines
    for k = 1:hl, fgetl(fid); end
    tline = fgetl(fid);
    [~, acols] = sscanf(tline, '%f');
    data_wo_blanks = reshape(cell2mat(textscan(fid, '%f')), acols, [])';
    %% memory pre-allocation for array
    a = zeros(size(data_wo_blanks,1)+1, acols);
    %% array formation
    a(1,:)     = sscanf(tline, '%f');
    a(2:end,:) = data_wo_blanks;
end