%Task 1: Hello World!

{Show 'Hello World!'} %Shows the message "Hello World!" in Oz Emulator
{Browse 'Hello World!'} %Opens a new window and displays the message "Hello World!" in Oz Browser


%Task 2: Using other text editors

%This assignment was all done in VS Code, by installing the Oz extension from the marketplace and adding the Oz binary 
%path to the system environment variables so that VS Code can find the executables.

%Task 3: Variables

% 3a) This shows X= 300*30 = 9000 in the Oz Emulator
local X Y Z in
    Y = 300
    Z = 30
    X = Z * Y
    {Show X}
end

% 3b) I think showInfo prints Y before its assigned value because Oz uses dataflow variables, which means that the thread waits for Y to be assigned a value before it prints out the value.
% This is useful because it provides implicit synchronization between threads without locks, which means that it can help avoid race conditions and make concurrent programming easier.
% What Y = X does is that it binds Y to the same value as X, if X is bound then Y becomes bound to the same value.
local X Y in
    X = 'This is a string'
    thread {System.showInfo Y} end
    Y = X
end

%Task 4: Functions and procedures

% 4a) Max function shows 89
declare fun {Max X Y}
    if X > Y then
        X
    else
        Y
    end
end

{System.showInfo {Max 10 89}}

% 4b) PrintGreater procedure shows 100
declare proc {PrintGreater X Y}
    if X > Y then
        {System.showInfo X}
    else
        {System.showInfo Y}
    end
end

{PrintGreater 10 100}

%Task 5: Variables II

declare proc {Circle R}
   local Pi A D C in
      Pi = 355.0 / 113.0
      A = Pi * R * R
      D = 2 * R
      C = Pi * D
      {System.showInfo A}
      {System.showInfo D}  
      {System.showInfo C}
   end
end
{Circle 5} 

%Task 6: Recursion

% Factorial function using recursion
declare fun {Factorial N}
   if N == 0 then
      1  % Base case: 0! = 1
   else
      N * {Factorial N-1}  
   end
end

{System.showInfo {Factorial 5}}  
{System.showInfo {Factorial 0}}  

%Task 7: Lists

% 7a) Length function - returns the element count of List
declare fun {Length List}
   case List of
      nil then 0
   [] Head|Tail then
      1 + {Length Tail}
   end
end

{System.showInfo {Length [1 2 3 4 5]}}

% 7b) Take function - returns first Count elements
declare fun {Take List Count}
   if Count =< 0 then
      nil
   else
      case List of
         nil then nil
      [] Head|Tail then
         Head|{Take Tail Count-1}
      end
   end
end

{System.showInfo {Take [1 2 3 4 5] 3}} 

% 7c) Drop function - returns list without first Count elements
declare fun {Drop List Count}
   if Count =< 0 then
      List
   else
      case List of
         nil then nil
      [] Head|Tail then
         {Drop Tail Count-1}
      end
   end
end

{System.showInfo {Drop [1 2 3 4 5] 2}}

% 7d) Append function - concatenates List1 and List2
declare fun {Append List1 List2}
   case List1 of
      nil then List2
   [] Head|Tail then
      Head|{Append Tail List2}
   end
end

{System.showInfo {Append [1 2] [3 4 5]}} 

% 7e) Member function - returns true if Element is in List
declare fun {Member List Element}
   case List of
      nil then false
   [] Head|Tail then
      if Head == Element then
         true
      else
         {Member Tail Element}
      end
   end
end

{System.showInfo {Member [1 2 3] 2}} 
{System.showInfo {Member [1 2 3] 4}} 

% 7f) Position function - returns position of Element in List (1-based)
declare fun {Position List Element}
   fun {PositionHelper List Element Index}
      case List of
         Head|Tail then
            if Head == Element then
               Index
            else
               {PositionHelper Tail Element Index+1}
            end
      end
   end
in
   {PositionHelper List Element 1}
end

{System.showInfo {Position [a b c d] c}}


%Task 8: Stack Operations

% 8a) Push function - adds Element to the first position of List
fun {Push List Element}
   Element|List
end

% 8b) Peek function - returns first element of List, or nil if empty
declare fun {Peek List}
   case List of
      nil then nil
   [] Head|Tail then Head
   end
end

% 8c) Pop function - returns List without the first element
declare fun {Pop List}
   case List of
      nil then nil
   [] Head|Tail then Tail
   end
end

% Test the stack functions
local Stack1 Stack2 Stack3 in
   Stack1 = [1 2 3]
   Stack2 = {Push Stack1 0}              
   {System.showInfo Stack2}
   
   {System.showInfo {Peek Stack2}}      
   {System.showInfo {Peek nil}}          
   
   Stack3 = {Pop Stack2}                 
   {System.showInfo Stack3}
   {System.showInfo {Pop nil}}           
end