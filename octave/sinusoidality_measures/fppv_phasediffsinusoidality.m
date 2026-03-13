% fppv_phasediffsinusoidality
% Calculate sinusoidality using the phase difference method.
% This method compares the phase sectrum to the two prior phase
% spectra in order to predict the expected phase advance for each bin.
% The inputs are the complex spectra f and the two prior complex spectra
% f1 and f2.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_phasediffsinusoidality(f,f1,f2)
phases	= angle(f);							% create phase spectrum 
phases1	= angle(f1);						% create phase spectrum 
phases2	= angle(f2);						% create phase spectrum 
dev		= princarg(phases-(2*phases1)+phases2); % phase differences over time.
%dev = phases - phases1;
%SM =  abs(dev);
SM = (3.1416 - (abs(dev))) / 3.1416; % sinusoidality Measure (SM) scale 0-1.
%SM = abs(dev);
%SM2 = exp(SM1*10) 	;

%maxSM =  max(SM2);
%SM = SM2 ./ maxSM;