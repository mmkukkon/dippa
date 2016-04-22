function [output1, output2] = aroundj(x, val, mu, sigma)
%poistetaan ei-mepit
   ind = find(val>50);
   x = x(ind);
   val = val(ind);
   
   %lasketaan painokerroin
   n = normpdf([-0.0006-abs(-0.0006-x),x,0.0006+abs(0.0006-x)],mu,sigma);
   
   ind2 = sort(1:1:length(val));
   
   %kerrotaan painokertoimella
   size(n)
   size([val(ind2), val, val(ind2)])
   o = n.*[val(ind2), val, val(ind2)];
   output1 = sum(o)/sum(n);
   
   output2 = sum(n);
 
end
