%Task 1: MDC

%a) 
declare
fun {Lex Input}
   {String.tokens Input & } % Splits a string using spaces as delimiters
end

{Browse {Lex "1 2 + 3 *"}} 

%b)
declare
fun {Tokenize Lexemes} % Converts each lexeme into a record
    case Lexemes
    of nil then nil
    [] Lx|Rest then
        Tok =
            case Lx
            of "+" then operator(plus)
            [] "-" then operator(minus)
            [] "*" then operator(multiply)
            [] "/" then operator(divide)
            else number({String.toInt Lx})
            end
        in
        Tok|{Tokenize Rest}
    end
end

declare
local
   L = ["1" "2" "+" "3" "*"]
in
    {Browse {Tokenize L}}
end

%c - g) 

declare
fun {Lex Input}
   {String.tokens Input & }
end
fun {Tokenize Lexemes} 
   case Lexemes
   of nil then nil
   [] Lx|Rest then
      Tok =
      case Lx
      of "+" then operator(type:plus)
      [] "-" then operator(type:minus)
      [] "*" then operator(type:multiply)
      [] "/" then operator(type:divide)
      [] "p" then command(print) % d) new case for print command
      [] "d" then command(dup)  % e) new case for dup command
      [] "i" then command(inv) % f) new case for inv command
      [] "c" then command(clear) % g) new case for clear command
      else number({String.toInt Lx})
      end
   in
      Tok | {Tokenize Rest}
   end
end

% c)
fun {Interpret Tokens}
   fun {Iterate Tokens Stack}
      case Tokens
      of nil then Stack

      [] number(N)|Rest then
         {Iterate Rest N|Stack}

      [] operator(type:plus)|Rest then  % Pop two numbers, apply operator, push result
         case Stack of B|A|SRest then
            {Iterate Rest (A+B)|SRest}
         end

      [] operator(type:minus)|Rest then % Pop two numbers, compute subtraction
         case Stack of B|A|SRest then
            {Iterate Rest (A-B)|SRest}
         end

      [] operator(type:multiply)|Rest then % Pop two numbers, compute multiplication
         case Stack of B|A|SRest then
            {Iterate Rest (A*B)|SRest}
         end

      [] operator(type:divide)|Rest then % Pop two numbers, compute division
         case Stack of B|A|SRest then
            {Iterate Rest (A.0 / B.0)|SRest} % force float division
         end

      [] command(print)|Rest then  % d) new case for print command
         {System.show Stack}
         {Iterate Rest Stack}       % stack unchanged

      [] command(dup)|Rest then    % e) new case for dup command
         case Stack of Top|SRest then
            {Iterate Rest Top|Top|SRest} % duplicate top of stack
         end

      [] command(inv)|Rest then    % f) new case for inv command
         case Stack of Top|SRest then
            {Iterate Rest (~Top)|SRest}  % flip sign of top element
         end

      [] command(clear)|Rest then  % g) new case for clear command
         {Iterate Rest nil}        % clear the stack (set it to nil)
      end
   end
in
   {Iterate Tokens nil}
end


% --- Tests ---
local

%Test task c)
{Browse {Interpret [number(1) number(2) number(3) operator(type:plus)]}}

%Test task d)
   Tokens = {Tokenize {Lex "1 2 p 3 +"}}
   Result = {Interpret Tokens}
in
   {Browse Result}

%Test task e)
   Tokens = {Tokenize {Lex "1 2 3 + d"}}
   Result = {Interpret Tokens}
in
   {Browse Result}

%Test task f)
   Tokens = {Tokenize {Lex "1 2 3 + i"}}
   Result = {Interpret Tokens}
in
   {Browse Result}

%Test task g)
   Tokens2 = {Tokenize {Lex "1 2 3 p c p"}}
   Result2 = {Interpret Tokens2}
in
   {Browse Result2}
end

%Task 2: Convert postfix notation into an expression tree

% a) 
%   Recursive helper that consumes a list of tokens (postfix)
%   and builds an expression tree using a stack of expressions.
declare
fun {ExpressionTreeInternal Tokens ExprStack} 
   case Tokens
   of nil then 
      case ExprStack
      of Top | then Top   % return root of expression tree
      end
   [] number(N)|Rest then % Token is a number, push onto stack
      {ExpressionTreeInternal Rest number(N)|ExprStack} 
   [] operator(type:plus)|Rest then % Token is plus operator
      case ExprStack of Right|Left|SRest then
         NewExpr = plus(Left Right)
      in
         {ExpressionTreeInternal Rest NewExpr|SRest}
      end
   [] operator(type:minus)|Rest then % Token is minus operator
      case ExprStack of Right|Left|SRest then
         NewExpr = minus(Left Right)
      in
         {ExpressionTreeInternal Rest NewExpr|SRest}
      end
   [] operator(type:multiply)|Rest then % Token is multiply operator
      case ExprStack of Right|Left|SRest then
         NewExpr = multiply(Left Right)
      in
         {ExpressionTreeInternal Rest NewExpr|SRest}
      end
   [] operator(type:divide)|Rest then % Token is divide operator
      case ExprStack of Right|Left|SRest then
         NewExpr = divide(Left Right)
      in
         {ExpressionTreeInternal Rest NewExpr|SRest}
      end
   end
end

%   Public function — initializes the expression stack as empty
%   and calls the recursive helper to process all tokens.
fun {ExpressionTree Tokens}
   {ExpressionTreeInternal Tokens nil}
end

% --- Test ---
% Results are unsure, should get different format but Oz gives raw tree structure with records preserved.
local
   Tokens = [number(2) number(3) operator(type:plus) number(5) operator(type:divide)]
in
   {Browse {ExpressionTree Tokens}}
end

%b) 
declare
% Wrapper function: starts with an empty stack
fun {ExpressionTree Tokens}
   {ExpressionTreeInternal Tokens nil}
end

% Explicit tokens
local
   Tokens = [number(3) number(10) number(9) operator(type:multiply)
   operator(type:minus) number(7) operator(type:plus)]
in
   {Browse {ExpressionTree Tokens}}
end

% Using Lex + Tokenize
local
   Tokens = {Tokenize {Lex "3 10 9 * - 7 +"}}
in
   {Browse {ExpressionTree Tokens}}
end


%Task 3: Theory
% a) Formal grammer for lexemes
   A lexeme is either 1 a number (one or more digits) or 2 and operator (+, -, *, /) or 3 a command (p, d, i, c).
   We want a grammer that can generate exactly the lexemes used in the mdc assignment, so we define:
   numerals (positive integers): 
      digit ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

      and operators/commands:
      operator ::= "+" | "-" | "*" | "/"
      command ::= "p" | "d" | "i" | "c"

% b) Grammer for the expression-tree records
   We describe the shape of records produced by the expression tree function. The trees use labels plus, minus, multiply, divide and number
   as leaves. 

   <expression> ::= number(<int>) 
                  | plus(<expression> <expression>) 
                  | minus(<expression> <expression>) 
                  | multiply(<expression> <expression>) 
                  | divide(<expression> <expression>)
   <number> ::= <digits> { <digit> }
   <digits> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

   
% c) Classification of the two grammers
   Grammer a uses regular expressions to define the lexemes. It is a regular grammer. The reason is that
   number is described as by digit, which is a regular language where operators and commands are just single characters.
   All productions have the right from for a regular grammer.

   Grammer b is a not a regular grammer, because the productions are recursive and allow arbitrary nesting of expressions which
   requires a context-free grammer. The nested parenthesized structure cannot in general be recognize by a regular grammer, so it
   is context-free but not regular.