%Task 1: Procedural abstraction

% a)
declare
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
   local
      D = B*B - 4.0*A*C    % discriminant Δ = b² - 4ac
   in
      if D < 0.0 then
         % No real solutions
         RealSol = false
         X1 = unit
         X2 = unit
      elseif D == 0.0 then
         % One real solution (double root)
         RealSol = true
         X1 = ~B / (2.0*A)
         X2 = X1
      else
         % Two distinct real solutions
         RealSol = true
         X1 = (~B + {Float.sqrt D}) / (2.0*A)
         X2 = (~B - {Float.sqrt D}) / (2.0*A)
      end
   end
end

% b)
local RealSol X1 X2 in
   {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
   {System.show 'Case 1: A=2 B=1 C=-1'}
   {System.show RealSol}
   {System.show X1}
   {System.show X2}
end

local RealSol X1 X2 in
   {QuadraticEquation 2.0 1.0 2.0 RealSol X1 X2}
   {System.show 'Case 2: A=2 B=1 C=2'}
   {System.show RealSol}
   {System.show X1}
   {System.show X2}
end

% c) Procedural abstractions are useful because it allows us to separate what a procedure oes from how it is implemented. There are multiple reasons why this is useful:
%    1. It reduces repetition like common patterns (like quadratic formula) can be implemented once and reused multiple times.
%    2. It improves readability by allowing us to use meaningful names for procedures that describe their purpose.
%    3. It enables modularity, maintainability and flexibility. If the implementation changes, the rest of the program does not need to change.

%d) The difference between a procedure and a function in oz is that a function takes arguments and returns a value, while a procedure takes arguments but does not return a 
%   value. Instead, it can bind output arguments using variables. In short functions are used for expressions to evaluate something, while procedure are use for
%   actions with side-effect or when multiple outputs are needed.

% function example: fun {Square X} X*X end = Square(3) % returns 9
% procedure example: proc {Swap A B ?A1 ?B1} A1 = B B1 = A end % swaps values of A and B

%Task 2: Sum list
declare
fun {Sum List}
   case List
   of nil then 0 % base case: sum of empty list is 0
   [] X|Xs then X + {Sum Xs} % recursive case: sum is head + sum of tail
   end
end

% Test
{System.show {Sum [1 2 3 4]}}   % expected: 10
{System.show {Sum nil}}         % expected: 0
{System.show {Sum [5]}}         % expected: 5
