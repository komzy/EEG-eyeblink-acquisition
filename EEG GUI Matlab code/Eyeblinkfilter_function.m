function [ Eyeblink ] = Eyeblinkfilter_function( signal_2 )
load 'Eyeblink_final.mat'
Eyeblink=conv(Eyeblink_final,signal_2);
end
   


