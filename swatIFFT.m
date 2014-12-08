function [x,t]=swatIFFT(xmag, xphase, df)
%Given the magnitude, phase, and frequency step associatied 
%with the cosine waves that make up the function x, this function
%returns the values of x, along with the corresponding time
%vector, t.  The magnitude vector should have an odd number
%of points.  The angle should be in radians, the frequency 
%step (df) is in Hz.

i=complex(0,1);
N=length(xmag);
xmag=reshape(xmag,1,N);
xphase=reshape(xphase,1,N);
xmag=[xmag xmag((N-1):-1:2)];
xphase=[xphase -xphase((N-1):-1:2)];
y=xmag.*exp(i*xphase);
x=real(ifft(y));

t=(0:(2*(N-1)-1))/((2*(N-1))*df);
