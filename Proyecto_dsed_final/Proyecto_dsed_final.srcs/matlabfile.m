
testPB = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
testPA = filter([-0.0078, -0.2031, 0.6015, -0.2031,-0.0078],[1, 0, 0, 0, 0], data);

vhdlout2=load('C:\Users\dasba\Desktop\teleco\dsed\proyecto_dsed\DSED_VHDL_NEXUSDDR\Proyecto_dsed_final\sample_outPA.dat')/127;
vhdlout=load('C:\Users\dasba\Desktop\teleco\dsed\proyecto_dsed\DSED_VHDL_NEXUSDDR\Proyecto_dsed_final\sample_out.dat')/127;

subplot(3,2,1);
plot(testPB);
subplot(3,2,2);
plot(testPA);
subplot(3,2,3);
plot(vhdlout);
subplot(3,2,4);
plot(vhdlout2);
subplot(3,2,5);
plot(abs(testPB-vhdlout));
subplot(3,2,6);
plot(abs(testPA-vhdlout2));