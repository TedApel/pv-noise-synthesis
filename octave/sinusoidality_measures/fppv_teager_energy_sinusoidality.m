% fppv_teager_energy_sinusoidality
% This is my method of finding sinusoidality.
% The Teager energy of a band is used to determine the sinusoidal energy
% of a bin. Sinusoidal peaks show high energy and noise peaks show low energy.
% The inputs are the complex spectra f.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.
% Ted Apel 2006. 
%
function [SM] = fppv_teager_energy_sinusoidality(f,w2);

numsamp 		= length(f);
binnum 			= 3;  %2  This is not the width of the bins.
varspectrum 	= zeros(1,numsamp);
energyspectrum 	= zeros(1,numsamp);

while binnum < numsamp/2   						% make loop.
	outbin 				= zeros(1, numsamp);  	% start with zero spectrum.
 	outbin(binnum) 		= f(binnum);  			% put one bin in.
 	outbin(binnum+1) 	= f(binnum+1);			% but next bin in.
 	outbin(binnum-1) 	= f(binnum-1);			% but prior bin in.
 	outbin(binnum+2) 	= f(binnum+2);			% but next bin in.
 	outbin(binnum-2) 	= f(binnum-2);			% but prior bin in.
 %	outbin(binnum+3) 	= f(binnum+3);			% but next bin in.
% 	outbin(binnum-3) 	= f(binnum-3);			% but prior bin in.
% 	outbin(binnum+4) 	= f(binnum+4);			% but next bin in.
% 	outbin(binnum-4) 	= f(binnum-4);			% but prior bin in.
% 	 outbin(binnum+5) 	= f(binnum+5);			% but next bin in.
% 	outbin(binnum-5) 	= f(binnum-5);			% but prior bin in.
% 	 outbin(binnum+6) 	= f(binnum+6);			% but next bin in.
% 	outbin(binnum-6) 	= f(binnum-6);			% but prior bin in.
% 	 	outbin(binnum+7) 	= f(binnum+7);			% but next bin in.
% 	outbin(binnum-7) 	= f(binnum-7);			% but prior bin in.
% 	 	outbin(binnum+8) 	= f(binnum+8);			% but next bin in.
% 	outbin(binnum-8) 	= f(binnum-8);			% but prior bin in.
 	
%plot(abs(outbin)); 	pause(.00001);
 	grain  			= (real(ifft((outbin)  ))); % get time signal for those bins .*w2'

 	wingrain = grain .* w2' ;
 %	 	normwingrain = wingrain ./ max(wingrain);
 %	 	plot( normwingrain );
% 	axis([1,512,-1,1]);
% 	pause(.0001);
 	% 	plot([-1:1] , wingrain([1:512])  );   %([1:512])


 	[am, fm, energy]	= amfm_sep(wingrain,0,0);% teager energy of windowed sig.
 	 	energysum 			= var(am);
% 	 	energysum 		= kurtosis(am,1);
 %	energysum 			= sum(energy);   		% sum the energy.
 	varspectrum(binnum) = energysum;  			% put summed energy in spectrum.
 	binnum 				= binnum + 1;			% advance bin number.
end
 
SM = (varspectrum ./ max(varspectrum) )';			% output the spectrum.

%SM =  varspectrum;
 
 
