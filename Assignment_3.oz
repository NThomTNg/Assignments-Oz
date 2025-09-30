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

% Genericity: The ability to pass procedure values as arguments to a procedure call
%Task 2
declare
fun {Sum List}
   case List
   of nil then 0 % base case: sum of empty list is 0
   [] X|Xs then X + {Sum Xs} % recursive case: sum is head + sum of tail
   end
end

% Test
{System.show {Sum [1 2 3 4]}}  
{System.show {Sum nil}}         
{System.show {Sum [5]}}         

%Task 3

%a and b)
declare
fun {RightFold List Op U} % Function named RightFold with three parameters: List, Op (binary operation), and U (neutral element)
   case List % Pattern matching on List, meaning its either empty or a head element with a tail (X|Xs)
   of nil then U                          % Base case: empty list returns neutral element (U)
   [] X|Xs then {Op X {RightFold Xs Op U}} % Recursive case: apply Op to head and folded tail (fold right to left). This combine the head with the result of the recursive call.
   end
end % Closes the case expression and the RightFold function.

%test case
local
   Op = fun {$ X Y} X + Y end
in
   {System.show {RightFold [1 2 3 4] Op 0}}  %1 + (2 + (3 + (4 + 0))) = 10
end

%c)
declare
% RightFold (from Task 3a)
fun {RightFold List Op U}
   case List
   of nil then U
   [] X|Xs then {Op X {RightFold Xs Op U}}
   end
end

% Length using RightFold
fun {Length List}
   {RightFold List fun {$ _ Acc} 1 + Acc end 0} % ignore the element value _ and just add 1 to the accumulator Acc. Start with 0 as the initial value because of list length.
end

% Sum using RightFold
fun {Sum List}
   {RightFold List fun {$ X Acc} X + Acc end 0} % add the element value X to the accumulator Acc. Start with 0 as the initial value because of sum of empty list.
end

%Test cases
{System.show {Length [1 2 3 4]}}  
{System.show {Sum [1 2 3 4]}}      
{System.show {Length nil}}         
{System.show {Sum nil}}           


%d) For Sum and Length in a LeftFold implementation, the answer would be the same as in RightFold. This is because:
   % Addition (+) is associative: (a + b) + c = a + (b + c)
   % Counting elements (length) is also associative, since it just increments for each element.
      %Example: RightFold: 1 + (2 + (3 + 4)) = 10 & LeftFold: ((1 + 2) + 3) + 4 = 10

% However, for non-associative operations like subtraction (-) or division (/), the results would differ between LeftFold and RightFold.

%Example:
declare
fun {LeftFold List Op U}
   case List
   of nil then U
   [] X|Xs then {LeftFold Xs Op {Op U X}}
   end
end

% Test with subtraction
local
   Op = fun {$ X Y} X - Y end
in
   {System.show {RightFold [1 2 3] Op 0}}
   {System.show {LeftFold [1 2 3] Op 0}}   % Outputs will differ
end

% For Sum and Length, results will be the same since operations are associative. However, for non-associative operations like subtraction 
%   or division, results will differ between LeftFold and RightFold.

%e)
% For a fold operation, the neutral element is the value that does not change the result when combined with 
% any element. For muliplication, the neutral element is 1 because multiplying any number by 1 leaves it unchanged (e.g., a * 1 = a).
% If we used 0, then any number multiplies would be 0, which is wrong.

%Example:
declare
fun {Product List}
   {RightFold List fun {$ X Acc} X * Acc end 1}
end

{System.show {Product [1 2 3 4]}}   
{System.show {Product nil}}         

%This is why the correct element for the product of list elements is 1.

%Task 4: Instantiation
%Quadratic is a higher-order function. In the function bellow, it takes three argumens A, B and C.

declare
fun {Quadratic A B C}
   fun {$ X}
      A*X*X + B*X + C
   end
end

%test case
{System.show {{Quadratic 3 2 1} 2}}    % output: 17
{System.show {{Quadratic 1 0 0} 5}}    % output: 25 (f(x) = x²)
{System.show {{Quadratic 1 2 1} 3}}    % output: 16 (f(x) = (x+1)²)

