%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script for making plasma shape, wall countour and passive structure
%for tokamaks
%Written under contract to Tokamak Energy, UK
%S. Woodruff 
%May 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Contents
%
%1.1 Plasma shape
%1.2 First wall contour
%1.2.1 Plasma chamber first wall
%1.2.2 Divetor plate
%1.3 Passive structure
%1.3.1 Stabilizing shell
%1.3.2 Vessel
%start452MA_13_pass_sxPeter3.sav

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.1 Plasma shape
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = 0.07;
a = r/1.3;
delta= 0.3;  	%triangularity
si = 0; 		%upper squareness
k = 0.5 ;		%elongation
sj = 0; 		%lower squareness
po = 64;

for i = 1:po    %poloidal angle
R(i) = r + a * cos(pi + i*pi/po + asin(delta) * sin(pi+ i*pi/po));
Z(i) = a*k*sin(pi + i*pi/po + si * sin(pi+2*i*pi/po)); %for θ < π/2
end
for i=po+1:2*po 
R(i) = r + a * cos(pi+i*pi/po + asin(delta) * sin(pi+i*pi/po));
Z(i) = a*k*sin(pi+i*pi/po + sj * sin(pi+2*i*pi/po)); %for θ > π/2
end

figure(1)
plot(R, Z, 'k')
m1=max(R)+0.05;
m2=max(Z)+0.05;
axis([0 m1 -m2 m2])
set(gca,'DataAspectRatio',[1 1 1])


fid = fopen('shape.in', 'w');

fprintf(fid, '# R [m] Z[m] \n')
for i=1:128
fprintf(fid, '%.3f %.3f \n', R(i), Z(i))
end
fclose(fid)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.2 First wall contour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.2.1 Chamber 1st wall
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.2.1 Divertor target plates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
a = a+0.04;%delta= 0.45;  	%triangularity
%si = 0; 		%upper squareness
%sj = 0; 		%lower squareness
%k = 2.5 ;		%elongation
po = 54;

for i = 1:po    %poloidal angle
R1(i) = r + a * cos(pi + i*pi/po + asin(delta) * sin(pi+ i*pi/po));
Z1(i) = a*k*sin(pi + i*pi/po + si * sin(pi+2*i*pi/po)); %for θ < π/2
end
for i=(po+1):(2*po) 
R1(i) = r + a * cos(pi+i*pi/po + asin(delta) * sin(pi+i*pi/po));
Z1(i) = a*k*sin(pi+i*pi/po + sj * sin(pi+2*i*pi/po)); %for θ > π/2
end

R2=R1(1:po*2);
Z2=Z1(1:po*2);
fid = fopen('wall.in', 'w');


%outboard contour
fprintf(fid, '# R [m] Z[m] \n')
for i=po-19:po+19
fprintf(fid, '%.3f %.3f \n', R2(i), Z2(i))
end

%divertor up top
fprintf(fid, '%.3f %.3f \n', 1.8, 1.15)
fprintf(fid, '%.3f %.3f \n', 0.9, 1.25)
fprintf(fid, '%.3f %.3f \n', 1.1, 1.25)
fprintf(fid, '%.3f %.3f \n', 1.2, 1.4)
fprintf(fid, '%.3f %.3f \n', 0.7, 1.4)
fprintf(fid, '%.3f %.3f \n', 0.4, 1.1) 
fprintf(fid, '%.3f %.3f \n', 0.3, 1.1)
fprintf(fid, '%.3f %.3f \n', 0.2, 1.2)
fprintf(fid, '%.3f %.3f \n', 0.1, 1.1)

%+z inboard contour
for i=2*po-18:2*po
fprintf(fid, '%.3f %.3f \n', R2(i), Z2(i))
end

%-z inboard contour
for i=1:18
fprintf(fid, '%.3f %.3f \n', R2(i), Z2(i))
end
%divertor down below
fprintf(fid, '%.3f %.3f \n', 0.1, -1.1)
fprintf(fid, '%.3f %.3f \n', 0.2, -1.2)
fprintf(fid, '%.3f %.3f \n', 0.3, -1.1)
fprintf(fid, '%.3f %.3f \n', 0.4, -1.1) 
fprintf(fid, '%.3f %.3f \n', 0.7, -1.4)
fprintf(fid, '%.3f %.3f \n', 1.2, -1.4)
fprintf(fid, '%.3f %.3f \n', 1.1, -1.25)
fprintf(fid, '%.3f %.3f \n', 0.9, -1.25)
fprintf(fid, '%.3f %.3f \n', min(R2(po-19:po+19)), min(Z2(po-19:po+19)))

%last point to close the loop
fprintf(fid, '%.3f %.3f \n', R2(po-17),Z2(po-17))

fclose(fid)


 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.3 Passive structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.3.1 Stabilizers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Passive structure shape
%r = 0.7;
a = a+0.02;
%delta= 0.4;  	%triangularity
%si = 0; 		%upper squareness
%sj = 0; 		%lower squareness
%k = 2.5 ;		%elongation
%po = 60;

for i = 1:po    %poloidal angle
R3(i) = r + a * cos(pi + i*pi/po + asin(delta) * sin(pi+ i*pi/po));
Z3(i) = a*k*sin(pi + i*pi/po + si * sin(pi+2*i*pi/po)); %for θ < π/2
end
for i=po+1:(2*po) 
R3(i) = r + a * cos(pi+i*pi/po + asin(delta) * sin(pi+i*pi/po));
Z3(i) = a*k*sin(pi+i*pi/po + sj * sin(pi+2*i*pi/po)); %for θ > π/2
end

R4=R3(1:po*2);
Z4=Z3(1:po*2);
drwires=0.02;
dzwires=0.02;
resist=0.01;

fid = fopen('passive.in', 'w');

fprintf(fid, '# R [m] Z[m] Thick Resist  ID \n')

%lower stabilizer OUTER
%fprintf(fid, '%.3f %.3f %.3f %.3e LowerStab\n', R4(i), Z4(i), drwires, resist)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabO\n', 0.4, 1.25, 0.02, 30 )
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabO\n', 0.07, 1.25, 0.02, 30)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabO\n', 0.07, -1.25, 0.02, 40)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabO\n', 0.4, -1.25, 0.02, 50)


%upper stabilizer OUTER
%fprintf(fid, '%.3f %.3f %.3f %.3e LowerStab\n', R4(i), Z4(i), drwires, resist)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabO\n', 0.4, 1.25, 0.02, 30 )
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabO\n', 0.07, 1.25, 0.02, 30)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabO\n', 0.07, -1.25, 0.02, 40)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabO\n', 0.4, -1.25, 0.02, 50)

%lower stabilizer INNER
%fprintf(fid, '%.3f %.3f %.3f %.3e LowerStab\n', R4(i), Z4(i), drwires, resist)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabI\n', 0.4, 1.25, 0.02, 30 )
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabI\n', 0.07, 1.25, 0.02, 30)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabI\n', 0.07, -1.25, 0.02, 40)
fprintf(fid, '%.3f %.3f %.3f %.3e LowerStabI\n', 0.4, -1.25, 0.02, 50)


%upper stabilizer INNER
%fprintf(fid, '%.3f %.3f %.3f %.3e LowerStab\n', R4(i), Z4(i), drwires, resist)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabI\n', 0.4, 1.25, 0.02, 30 )
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabI\n', 0.07, 1.25, 0.02, 30)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabI\n', 0.07, -1.25, 0.02, 40)
fprintf(fid, '%.3f %.3f %.3f %.3e UpperStabI\n', 0.4, -1.25, 0.02, 50)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.3.2 Vessel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%inner VV
fprintf(fid, '%.3f %.3f %.3f %.3e InnerVV\n', 0.4, 1.25, 0.02, 30 )
fprintf(fid, '%.3f %.3f %.3f %.3e InnerVV\n', 0.07, 1.25, 0.02, 30)
fprintf(fid, '%.3f %.3f %.3f %.3e InnerVV\n', 0.07, -1.25, 0.02, 40)
fprintf(fid, '%.3f %.3f %.3f %.3e InnerVV\n', 0.4, -1.25, 0.02, 50)


%outer VV
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 0.4, 1.35, 0.02, 50 )
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 0.4, 1.50, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.2, 1.50, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.42, 1.00, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.55, 0.5, 0.02, 50)

fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.55, -0.5, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.42, -1.00, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 1.2, -1.50, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 0.4, -1.50, 0.02, 50)
fprintf(fid, '%.3f %.3f %.3f %.3e OuterVV\n', 0.4, -1.35, 0.02, 50 )



fclose(fid)


figure(1)
plot( R2, Z2, '.', R, Z, '+', R3, Z3, '-', R4, Z4, 'k')
m1=max(R)+0.15;
m2=max(Z)+0.15;
axis([0 m1 -m2 m2])
set(gca,'DataAspectRatio',[1 1 1])

print -djpg -mo -portrait -solid ST50DNShape.jpg


