function f = features_GLHA(im, flist, mask)
% Gray-level histogram analysis 
% Sintax:
%     f = features_GLHA(im, flist)
%     f = features_GLHA(im, flist, mas)
%     
% Features:
% {'imin', 'imax', 'iavg',...
%     'ient', 'istd', 'ip05',...
%     'ip95', 'iba1', 'iba2',...
%     'ip30', 'ip70', 'iske',...
%     'ikur','iran'};
% 
% S. Pertuz
% Jul11/2017
% modified by Hai Shu Sep2/2020 based on the paper: Parenchymal texture analysis in digital mammography: A fully automated pipeline for breast cancer risk assessment

if nargin<3
    mask = true(size(im));
end

f = zeros(length(flist), 1);
x = im(mask(:));

for n = 1:length(flist)
    switch lower(flist{n})
        case 'imin'
            f(n) = min(x);
        case 'imax'
            f(n) = max(x);
        case 'iavg'
            f(n) = mean(x);
        case 'isum'
            f(n) = sum(x); %by Hai
        case 'ient'
            c = hist(x, 128);%by Hai
            p = c/sum(c);
            f(n) = -sum(p(p~=0).*log2(p(p~=0)));
        case 'istd'
            f(n) = std(x);
        case 'ip05'
            f(n) = prctile(x, 5);
        case 'ip95'
            f(n) = prctile(x, 95);
        case 'ip05mean'
            ip5 = prctile(x, 5);
            f(n) = mean(x(x<=ip5)); %by Hai
        case 'ip95mean'
            ip95 = prctile(x, 95);
            f(n) = mean(x(x>=ip95)); %by Hai
        case 'iske'
            f(n) = skewness(double(x));
            %if isnan(f(n)), f(n)=0; end
        case 'ikur'
            f(n) = kurtosis(double(x));
            %if isnan(f(n)), f(n)=0; end
        otherwise
            error('unknown feature %s', upper(flist{n}))
    end
end
