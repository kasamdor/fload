% The function is more faster analog of default MATLAB load function. 
% Inputs:
% * fp - file path
% * hl - number of header lines to ignore
% Output:
% * a  - double array
function [a] = fload(fp, hl)
    %% arguments check 
    assert(hl >= 0, 'Number of header lines is incorrect.');
    assert(exist(fp, 'file') > 0, 'File %s does not exist.', fp);
    %% file opening
    fid = fopen(fp, 'r');
    assert(fid ~= -1, 'File %s can not be read.', fp);
    cuo = onCleanup(@() fclose(fid));
    %% total file lines
    tfl = 0;
    while ~feof(fid)
        tfl = tfl + sum(fread(fid, 16384, 'char') == char(10));
    end
    assert(tfl > hl, 'Allowed header lines number is exceeded.');
    %% columns number
    frewind(fid);
    % skipping of header lines
    for k = 1:hl, fgetl(fid); end
    tline = fgetl(fid);
    [~, acols] = sscanf(tline, '%f');
    %% memory pre-allocation for array
    arows = tfl - hl; 
    a = zeros(arows, acols);
    %% array formation
    a(1,:) = sscanf(tline, '%f');
    a(2:end,:) = reshape(cell2mat(textscan(fid, '%f')), acols, [])';
end