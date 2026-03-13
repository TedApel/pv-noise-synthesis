% fppv_variance_sinusoidality
% This is my method of finding sinusoidality.
% Based on the desante variance method.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.
% Ted Apel 2006. 
%
function [SM] = fppv_variance_sinusoidality(ingrain,w2);

numsamp 		= length(ingrain);
binnum 			= 7;  %2  This is not the width of the bins.
varspectrum 	= zeros(1,numsamp);
energyspectrum 	= zeros(1,numsamp);

%plot(ingrain); 	pause(.00001);
f = abs(fft(abs(hilbert(ingrain))));
%f_test = abs(fft(ingrain));
%plot(f); 	pause(.00001);
%plot(f_test); 	pause(.00001);
while binnum < numsamp/2   						% make loop.
	outbin 				= zeros(1, numsamp);  	% start with zero spectrum.
 	outbin(binnum) 		= (f(binnum));  			% put one bin in.
 	outbin(binnum+1) 	= (f(binnum+1));			% but next bin in.
 	outbin(binnum-1) 	= (f(binnum-1));			% but prior bin in.
% 	outbin(binnum+2) 	= (f(binnum+2));			% but next bin in.
% 	outbin(binnum-2) 	= (f(binnum-2));			% but prior bin in.
%	outbin(binnum+3) 	= (f(binnum+3));			% but next bin in.
% 	outbin(binnum-3) 	= (f(binnum-3));			% but prior bin in.
% 	outbin(binnum+4) 	= f(binnum+4);			% but next bin in.
% 	outbin(binnum-4) 	= f(binnum-4);			% but prior bin in.
% 	outbin(binnum+5) 	= f(binnum+5);			% but next bin in.
% 	outbin(binnum-5) 	= f(binnum-5);			% but prior bin in.
% 	outbin(binnum+6) 	= f(binnum+6);			% but next bin in.
% 	outbin(binnum-6) 	= f(binnum-6);			% but prior bin in.
% 	outbin(binnum+7) 	= f(binnum+7);			% but next bin in.
% 	outbin(binnum-7) 	= f(binnum-7);			% but prior bin in.
% 	outbin(binnum+8) 	= f(binnum+8);			% but next bin in.
% 	outbin(binnum-8) 	= f(binnum-8);			% but prior bin in.
 	
%	plot(abs(outbin)); 	pause(.00001);
% need to go back to rectangular 
psi = ones(1,numsamp);
rect_outbin		= (outbin.* exp(i*psi));	
 	grain  			= (real(ifft((rect_outbin)  ))); % get time signal for those bins .*w2'
% 	plot(grain); 	pause(.00001);
 %	wingrain = abs(hilbert(grain));  %  .* w2' ;
 	wingrain = grain;
% 		wingrain = wingrain ./ max(wingrain);
 %	plot( wingrain );
 %	axis([1,512,-1,1]);
 %	pause(.0001);
 		
 		
% 	plot(abs(hilbert(wingrain))); 	pause(.00001);
%	wingrain = wingrain ./ max(wingrain);
% 	wingrain = abs(hilbert(wingrain));
%	normwingrain = wingrain ./ max(wingrain);
%	plot( normwingrain );
% 	axis([1,512,-1,1]);
% 	pause(.0001);
% 	plot([-1:1] , wingrain([1:512])  );   %([1:512])


 %	[am, fm, energy]	= amfm_sep(wingrain,0,0);% teager energy of windowed sig.
 %	 	energysum 			= var(fm);   		% TEMP AM TEST
% 	 	energysum 		= kurtosis(am,1);

 	energysum 			= var(wingrain);   		% var the energy.
% 	energysum			= sum(abs(wingrain));
 	varspectrum(binnum) = energysum;  			% put summed energy in spectrum.
 	binnum 				= binnum + 1;			% advance bin number.

end

varspectrum([1:8]) = 0;
SM = (varspectrum ./ max(varspectrum) )';			% output the spectrum.

%SM =  varspectrum;
 
 
