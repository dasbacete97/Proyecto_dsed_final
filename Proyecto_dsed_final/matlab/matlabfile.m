[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*127));


testPB = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
testPA = filter([-0.0078, -0.2031, 0.6015, -0.2031,-0.0078],[1, 0, 0, 0, 0], data);

vhdloutPA=load('sample_out_alto.dat')/127;
vhdloutPB=load('sample_out_bajo.dat')/127;

subplot(3,2,1);
plot(testPB);
title('test paso bajo');

subplot(3,2,2);
plot(testPA);
title('test paso alto');

subplot(3,2,3);
plot(vhdloutPB);
title('salida vhdl paso bajo');

subplot(3,2,4);
plot(vhdloutPA);
title('salida vhdl paso alto');

subplot(3,2,5);
plot(abs(testPB-vhdloutPB));
title('error paso bajo');

subplot(3,2,6);
plot(abs(testPA-vhdloutPA));
title('error paso alto');

%sound(vhdloutPB,fs);
%sound(testPB,fs);
%sound(vhdloutPA,fs);
%sound(testPB,fs);
