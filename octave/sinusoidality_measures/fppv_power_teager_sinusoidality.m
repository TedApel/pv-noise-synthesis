% fppv_power_teager_sinusoidality
% Calculate sinusoidality using the scaled magnitude of the 
% amplitude spectrum. To a given power p. p = 2  is the power spectrum.
% The inputs are the complex spectra f and the power p.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_power_teager_sinusoidality(f,f1,f2)
r		= abs(f) ;
r1		= abs(f1) .^2;
r2		= abs(f2) ;
r_combined = r1 - ( r .* r2);
max_r	= max(r_combined);				% find maximum value in mag spectrum.
SM 		= r_combined ./ (max_r + .000000001);			% divide to scale between 1 and 0.
