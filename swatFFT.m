function [sfftmag, sfftphase, f]=swatFFT(x,dt)
%This function returns the magnitude, phase, and frequencies
%of the cosine waves that make up the function x.  The function
%x should have an even number of points.  The angle is given
%in radians, frequency (f) is in Hz.

sfft=fft(x);
N=length(sfft);
sfftmag=abs(sfft(1:((N/2)+1)));
sfftphase=angle(sfft(1:((N/2)+1)));
f=(0:(N/2))/(N*dt);

