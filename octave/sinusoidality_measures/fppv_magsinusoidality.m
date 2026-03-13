% fppv_magsinusoidality
% Calculate sinusoidality using the scaled magnitude of the 
% amplitude spectrum.
% The inputs are the complex spectra f.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_magsinusoidality(f)
r		= abs(f);
max_r	= max(r);				% find maximum value in mag spectrum.
SM 		= r ./ max_r;			% divide to scale between 1 and 0.

