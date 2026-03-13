function SFM = fppv_spectral_flatness(spectrum)

% Determine SFM for each window in x:
%xBlock = blockX2(x,windowSize,frameRate,fs); % Convert x into COLUMNS of analysis windows
%xBlock = xBlock.*repmat(hamming(windowSize),1,size(xBlock,2)); % Window by Hamming
%XBlock = abs(fft(xBlock,2^nextpow2(windowSize)));
XBlock = abs(spectrum);		% get magnitude spectrum
XBlock = XBlock(1:end/2,:); % Keep only first half of fft magnitude
geoMean = exp(mean(log(XBlock),1)); % Mean along each column
arithMean = mean(XBlock,1); % Mean along each column
SFM = geoMean./arithMean; % Spectral flatness measure for each window in x
