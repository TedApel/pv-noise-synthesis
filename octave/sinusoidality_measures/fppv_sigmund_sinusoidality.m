% fppv_sigmund_sinusoidality
%  Sigmund~ method.: window by half cosine wave. zero pad 2/1 so for 1024 2048. 
%	- Xk > (Xk-2) + (Xk+2), 
%	- should be three over in theory, but he uses two. and a threshold of .6. 
%	- Should the bins around the peak also be turned on.
%
% The inputs are the complex spectra f.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_sigmund_sinusoidality(f)
r		= abs(f);
r_m2	= shift(r, -2);
r_p2	= shift(r, +2);

sigmund = r ./ .6 .* ((r_m2) + (r_p2)) ; 
max_sigmund	= max(sigmund);	
SM = ( sigmund ./ max_sigmund );

