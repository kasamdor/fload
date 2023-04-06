% The function is much faster analog of default `load` MATLAB function.
% `fp` - file path, `hl` - header lines to skip (optional argument).
% `data` - double array.
function data = fload(fp, hl)
    if ~exist('hl','var'), hl = 0; end
    assert((hl >= 0) && (hl == round(hl)), 'Number of header lines is incorrect.');
    assert(exist(fp, 'file'), 'File "%s" does not exist.', fp);
    fid = fopen(fp, 'r');
    assert(fid ~= -1, 'File "%s" can not be read.', fp);
    cuo = onCleanup(@() fclose(fid));
    for k = 1:hl, fgetl(fid); end % skipping of header lines
    acols = 0;
    while acols == 0
      tline = fgetl(fid);
      [~, acols] = sscanf(tline, '%f');
    end
    c = textscan(fid, '%f', 'CommentStyle', '%');
    data_wo_blanks = reshape(cell2mat(c), acols, [])';
    data          = zeros(size(data_wo_blanks,1)+1, acols);
    data(1,    :) = sscanf(tline, '%f');
    data(2:end,:) = data_wo_blanks;
end