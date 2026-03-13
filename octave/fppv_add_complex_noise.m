% fppv_add_complex_noise(f)
% Add gaussian complex noise to each spectral bin.
% Takes the magnitude spectrum of input spectrum.

function [f_noise] = fppv_add_complex_noise(f)
l = length(f);
%x_random		= randn(WLen,1) / (3.14159)	;% generate new random numbers.
f_complex_random = complex( randn(l,1) / (3.14159) ,randn(l,1) / (3.14159) );
f_noise 		= (abs(f)) .* f_complex_random;		% mult noise spectra by noise. 
