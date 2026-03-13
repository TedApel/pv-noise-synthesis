% fppv_phase_ave_sinusoidality
% Average sinusoidality measures across three time frames by taking
% the minimum value at each bin.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_phase_ave_sinusoidality(SM,SM1,SM2)
%r		= abs(f) .^p;
%r1		= abs(f1) .^p;
%r2		= abs(f2) .^p;

SM_mat = [SM  SM1  SM2];
%size(SM_mat)
SM = min(SM_mat')';
%size(SM)


%SM_combined = SM + SM1 + SM2;
%max_SM	= max(SM_combined);				% find maximum value in mag spectrum.
%SM 		= SM_combined ./ (max_SM + .000000001);			% divide to scale between 1 and 0.

