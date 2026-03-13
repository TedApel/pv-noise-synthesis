% fppv_irregularity_sinusoidality
% Calculate the Spectral Irregularity using the Krimphoff method
% Do not add results to give a bin by bin measure of irregularity
% Scale the results to our normal sinusoidality measures
%
% The inputs are the complex spectra f.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_irregularity_sinusoidality(f)
r		= abs(f);
r_m1	= shift(r, -1);
r_p1	= shift(r, +1);
r_ave	= (r + r_m1 + r_p1) / 3;
irr		= abs( r - r_ave );
max_irr	= max(irr);				% find maximum value in mag spectrum.
SM 		= ( (irr ./ max_irr) );			% divide to scale between 1 and 0.

%SM 		= (1 - (irr ./ max_irr) );	