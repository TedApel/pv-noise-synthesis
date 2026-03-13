% fppv_IF_irr_sinusoidality
% Calculate sinusoidality using the phase difference method.
% This method compares the phase sectrum to the two prior phase
% spectra in order to predict the expected phase advance for each bin.
% The inputs are the complex spectra f and the two prior complex spectra
% f1 and f2.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_IF_irr_sinusoidality(f,f1,f2,f3)
phases	= angle(f);							% create phase spectrum 
phases1	= angle(f1);						% create phase spectrum 
phases2	= angle(f2);						% create phase spectrum 
phases3	= angle(f3);

pdiff = phases-phases1;
pdiff1 = phases1-phases2;
pdiff2 = phases2-phases3;


pdiff_ave = (princarg(pdiff + pdiff1 + pdiff2))/3;
pdiff_irr = abs(pdiff1 - pdiff_ave);

%phaseAcc = princarg(pdiff - pdiff1);
%dev = phaseAcc;

maxirr = max(pdiff_irr);
SM = pdiff_irr ./ maxirr;

%SM = (3.1416 - (abs(dev))) / 3.1416;


%dev		= princarg(phases-(2*phases1)+phases2); % phase differences over time.
%dev = phases - phases1;
%SM =  abs(dev);
%SM = (3.1416 - (abs(dev))) / 3.1416; % sinusoidality Measure (SM) scale 0-1.
%SM = abs(dev);
%SM2 = exp(SM1*10) 	;

%maxSM =  max(SM2);
%SM = SM2 ./ maxSM;