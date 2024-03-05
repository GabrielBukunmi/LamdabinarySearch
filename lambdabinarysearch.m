
clc
clear
close all
syms p1 p2 p3 L
%Generator max and min outputs
p1_min = 150;
p1_max = 600;

p2_min = 100;
p2_max = 400;

p3_min = 50;
p3_max = 200;
%Enter desired load here
Pload=input('Enter the Load value:');


tolerance=0.01;

h1=510+7.2*p1+0.00142*p1.^2;
h2=310+7.85*p2+0.00194*p2.^2;
h3=78+7.97*p3+0.00482*p3.^2;

%Fuel cost for each generator
fuel_cost1=1.1;
fuel_cost2=1.0;
fuel_cost3=1.0;

%Get the cost function
 f1=fuel_cost1*h1;
 f2=fuel_cost2*h2;
 f3=fuel_cost3*h3;

 %Differentiate cost function
d1=diff(f1,p1);
d2=diff(f2,p2);
d3=diff(f3,p3);

%substitute the values of the max and min for each generator to get lambda
lmax1 = double(subs(d1,p1,p1_max));
lmax2 = double(subs(d2,p2,p2_max));
lmax3 = double(subs(d3,p3,p3_max));
lmax=max([lmax1 lmax2 lmax3]);

disp(['lmax:' num2str(lmax)]);



lmin1 = double(subs(d1,p1,p1_min));
lmin2 = double(subs(d2,p2,p2_min));
lmin3 = double(subs(d3,p3,p3_min));
lmin=min([lmin1 lmin2 lmin3]);

disp(['lmin:' num2str(lmin)]);


while true

    %find new lambda and use in the cost functions
deltalambda= (lmax-lmin)/2;
lambdai= lmin + deltalambda;

    P1new=double(solve(lambdai - diff(f1),p1));
    P2new=double(solve(lambdai - diff(f2),p2));
    P3new=double(solve(lambdai - diff(f3),p3));

    % For P1new:
P1new = min(max(P1new, p1_min), p1_max);

% For P2new:
P2new = min(max(P2new, p2_min), p2_max);

% For P3new:
P3new = min(max(P3new, p3_min), p3_max);


      %total power
      sumP=P1new + P2new +P3new;
      if   abs(sumP - Pload) <= tolerance
        break;

      elseif sumP > Pload
            lmax= lambdai;
    else
            lmin= lambdai;
   
      end

end

      lambda=lambdai;
      P1=P1new;
      P2=P2new;
      P3=P3new;

    
% Calculate the minimum cost at the last value of lambda and Ps
cost = double(subs(f1, {p1, L}, {P1, lambda})) + double(subs(f2, {p2, L}, {P2, lambda})) + double(subs(f3, {p3, L}, {P3, lambda}));

disp(['Minimum Cost: $' num2str(cost) ' per hour | Lambda: ' num2str(lambda) ' | P1: ' num2str(P1) ' MW | P2: ' num2str(P2) ' MW | P3: ' num2str(P3) ' MW']);

