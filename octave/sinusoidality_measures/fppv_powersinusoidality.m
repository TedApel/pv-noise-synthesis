% fppv_powersinusoidality
% Calculate sinusoidality using the scaled magnitude of the 
% amplitude spectrum. To a given power p. p = 2  is the power spectrum.
% The inputs are the complex spectra f and the power p.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_powersinusoidality(f,p)
r		= abs(f) .^p;
max_r	= max(r);				% find maximum value in mag spectrum.
SM 		= r ./ max_r;			% divide to scale between 1 and 0.

