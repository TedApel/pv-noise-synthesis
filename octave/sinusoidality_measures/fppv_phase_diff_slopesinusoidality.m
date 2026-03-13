% fppv_phase_diff_slopesinusoidality
% Calculate sinusoidality using the slope of the phases across bins. 
% Not across time. The slope should be flat around sinusoidal peaks.
% Here the zero slope is inverted to one while positive slopes tend toward zero.
% This gives a sinsoidality measure of 1 for no slope.
% The inputs are the complex spectra f.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_phase_diff_slopesinusoidality(f)
deltatheta = zeros(1,length(f));
%theta  		= angle(f);
%thetaunwrap = unwrap(theta);
% thetashift = shift(f, -1);
deltatheta(1:(length(f) - 1)) 	= diff(f);
posdelta 	= abs(deltatheta);
SM			= (1 - (posdelta ./ max(posdelta)))';

