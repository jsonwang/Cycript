/* Cycript - Remove Execution Server and Disassembler
 * Copyright (C) 2009  Jay Freeman (saurik)
*/

/* Modified BSD License {{{ */
/*
 *        Redistribution and use in source and binary
 * forms, with or without modification, are permitted
 * provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the
 *    above copyright notice, this list of conditions
 *    and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the
 *    above copyright notice, this list of conditions
 *    and the following disclaimer in the documentation
 *    and/or other materials provided with the
 *    distribution.
 * 3. The name of the author may not be used to endorse
 *    or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/* }}} */

%code top {
#include "Cycript.tab.hh"
#define scanner driver.scanner_
#define YYSTACKEXPANDABLE 1
}

%code requires {
#include "Parser.hpp"

typedef struct {
    bool newline_;

    union {
        bool bool_;

        CYDriver::Condition condition_;

        CYArgument *argument_;
        CYAssignment *assignment_;
        CYBoolean *boolean_;
        CYClause *clause_;
        CYCatch *catch_;
        CYClassName *className_;
        CYComprehension *comprehension_;
        CYCompound *compound_;
        CYDeclaration *declaration_;
        CYDeclarations *declarations_;
        CYElement *element_;
        CYExpression *expression_;
        CYFalse *false_;
        CYField *field_;
        CYFinally *finally_;
        CYForInitialiser *for_;
        CYForInInitialiser *forin_;
        CYFunctionParameter *functionParameter_;
        CYIdentifier *identifier_;
        CYInfix *infix_;
        CYLiteral *literal_;
        CYMember *member_;
        CYMessage *message_;
        CYMessageParameter *messageParameter_;
        CYNull *null_;
        CYNumber *number_;
        CYProperty *property_;
        CYPropertyName *propertyName_;
        CYSelectorPart *selector_;
        CYStatement *statement_;
        CYString *string_;
        CYThis *this_;
        CYTrue *true_;
        CYWord *word_;
    };
} YYSTYPE;

}

%code provides {
int cylex(YYSTYPE *lvalp, cy::location *llocp, void *scanner);
}

%name-prefix "cy"

%language "C++"
%locations

%initial-action {
    @$.begin.filename = @$.end.filename = &driver.filename_;
};

%defines

//%glr-parser
//%expect 1

%error-verbose

%parse-param { CYDriver &driver }
%lex-param { void *scanner }

%token At "@"

%token Ampersand "&"
%token AmpersandAmpersand "&&"
%token AmpersandEqual "&="
%token Carrot "^"
%token CarrotEqual "^="
%token Equal "="
%token EqualEqual "=="
%token EqualEqualEqual "==="
%token Exclamation "!"
%token ExclamationEqual "!="
%token ExclamationEqualEqual "!=="
%token Hyphen "-"
%token HyphenEqual "-="
%token HyphenHyphen "--"
%token HyphenHyphen_ "\n--"
%token HyphenRight "->"
%token Left "<"
%token LeftEqual "<="
%token LeftLeft "<<"
%token LeftLeftEqual "<<="
%token Percent "%"
%token PercentEqual "%="
%token Period "."
%token Pipe "|"
%token PipeEqual "|="
%token PipePipe "||"
%token Plus "+"
%token PlusEqual "+="
%token PlusPlus "++"
%token PlusPlus_ "\n++"
%token Right ">"
%token RightEqual ">="
%token RightRight ">>"
%token RightRightEqual ">>="
%token RightRightRight ">>>"
%token RightRightRightEqual ">>>="
%token Slash "/"
%token SlashEqual "/="
%token Star "*"
%token StarEqual "*="
%token Tilde "~"

%token Colon ":"
%token Comma ","
%token Question "?"
%token SemiColon ";"
%token NewLine "\n"

%token OpenParen "("
%token CloseParen ")"

%token OpenBrace "{"
%token CloseBrace "}"

%token OpenBracket "["
%token CloseBracket "]"

%token AtClass "@class"
%token AtSelector "@selector"
%token AtEnd "@end"

%token <false_> False "false"
%token <null_> Null "null"
%token <true_> True "true"

// ES3/ES5/WIE/JSC Reserved
%token <word_> Break "break"
%token <word_> Case "case"
%token <word_> Catch "catch"
%token <word_> Continue "continue"
%token <word_> Default "default"
%token <word_> Delete "delete"
%token <word_> Do "do"
%token <word_> Else "else"
%token <word_> Finally "finally"
%token <word_> For "for"
%token <word_> Function "function"
%token <word_> If "if"
%token <word_> In "in"
%token <word_> InstanceOf "instanceof"
%token <word_> New "new"
%token <word_> Return "return"
%token <word_> Switch "switch"
%token <this_> This "this"
%token <word_> Throw "throw"
%token <word_> Try "try"
%token <word_> TypeOf "typeof"
%token <word_> Var "var"
%token <word_> Void "void"
%token <word_> While "while"
%token <word_> With "with"

// ES3/IE6 Future, ES5/JSC Reserved
%token <word_> Debugger "debugger"

// ES3/ES5/IE6 Future, JSC Reserved
%token <word_> Const "const"

// ES3/ES5/IE6/JSC Future
%token <word_> Class "class"
%token <word_> Enum "enum"
%token <word_> Export "export"
%token <word_> Extends "extends"
%token <word_> Import "import"
%token <word_> Super "super"

// ES3 Future, ES5 Strict Future
%token <identifier_> Implements "implements"
%token <identifier_> Interface "interface"
%token <identifier_> Package "package"
%token <identifier_> Private "private"
%token <identifier_> Protected "protected"
%token <identifier_> Public "public"
%token <identifier_> Static "static"

// ES3 Future
%token <identifier_> Abstract "abstract"
%token <identifier_> Boolean "boolean"
%token <identifier_> Byte "byte"
%token <identifier_> Char "char"
%token <identifier_> Double "double"
%token <identifier_> Final "final"
%token <identifier_> Float "float"
%token <identifier_> Goto "goto"
%token <identifier_> Int "int"
%token <identifier_> Long "long"
%token <identifier_> Native "native"
%token <identifier_> Short "short"
%token <identifier_> Synchronized "synchronized"
%token <identifier_> Throws "throws"
%token <identifier_> Transient "transient"
%token <identifier_> Volatile "volatile"

// ES5 Strict
%token <identifier_> Let "let"
%token <identifier_> Yield "yield"

// Woah?!
%token <identifier_> Each "each"

%token <identifier_> Identifier_
%token <number_> NumericLiteral
%token <string_> StringLiteral
%token <literal_> RegularExpressionLiteral

%type <expression_> AdditiveExpression
%type <expression_> AdditiveExpressionNoBF
%type <argument_> ArgumentList
%type <argument_> ArgumentList_
%type <argument_> ArgumentListOpt
%type <argument_> Arguments
%type <literal_> ArrayLiteral
%type <expression_> AssigneeExpression
%type <expression_> AssigneeExpression_
%type <expression_> AssigneeExpressionNoBF
%type <expression_> AssignmentExpression
%type <assignment_> AssignmentExpression_
%type <expression_> AssignmentExpressionNoBF
%type <expression_> AssignmentExpressionNoIn
%type <expression_> BitwiseANDExpression
%type <expression_> BitwiseANDExpressionNoBF
%type <expression_> BitwiseANDExpressionNoIn
%type <statement_> Block
%type <statement_> Block_
%type <boolean_> BooleanLiteral
%type <expression_> BitwiseORExpression
%type <expression_> BitwiseORExpressionNoBF
%type <expression_> BitwiseORExpressionNoIn
%type <expression_> BitwiseXORExpression
%type <expression_> BitwiseXORExpressionNoBF
%type <expression_> BitwiseXORExpressionNoIn
%type <statement_> BreakStatement
%type <expression_> CallExpression
%type <expression_> CallExpressionNoBF
%type <clause_> CaseBlock
%type <clause_> CaseClause
%type <clause_> CaseClausesOpt
%type <catch_> CatchOpt
%type <statement_> CategoryStatement
%type <expression_> ClassExpression
%type <message_> ClassMessageDeclaration
%type <message_> ClassMessageDeclarationListOpt
%type <className_> ClassName
%type <className_> ClassNameOpt
%type <statement_> ClassStatement
%type <expression_> ClassSuperOpt
%type <field_> ClassFieldList
%type <comprehension_> ComprehensionList
%type <comprehension_> ComprehensionListOpt
%type <expression_> ConditionalExpression
%type <expression_> ConditionalExpressionNoBF
%type <expression_> ConditionalExpressionNoIn
%type <statement_> ContinueStatement
%type <clause_> DefaultClause
%type <statement_> DoWhileStatement
%type <expression_> Element
%type <expression_> ElementOpt
%type <element_> ElementList
%type <element_> ElementListOpt
%type <statement_> ElseStatementOpt
%type <statement_> EmptyStatement
%type <expression_> EqualityExpression
%type <expression_> EqualityExpressionNoBF
%type <expression_> EqualityExpressionNoIn
%type <expression_> Expression
%type <expression_> ExpressionOpt
%type <compound_> Expression_
%type <expression_> ExpressionNoBF
%type <expression_> ExpressionNoIn
%type <compound_> ExpressionNoIn_
%type <expression_> ExpressionNoInOpt
%type <statement_> ExpressionStatement
%type <finally_> FinallyOpt
%type <comprehension_> ForComprehension
%type <statement_> ForStatement
%type <for_> ForStatementInitialiser
%type <statement_> ForInStatement
%type <forin_> ForInStatementInitialiser
%type <functionParameter_> FormalParameterList
%type <functionParameter_> FormalParameterList_
%type <statement_> FunctionBody
%type <statement_> FunctionDeclaration
%type <expression_> FunctionExpression
%type <identifier_> Identifier
%type <identifier_> IdentifierOpt
%type <comprehension_> IfComprehension
%type <statement_> IfStatement
%type <expression_> Initialiser
%type <expression_> InitialiserOpt
%type <expression_> InitialiserNoIn
%type <expression_> InitialiserNoInOpt
%type <statement_> IterationStatement
%type <statement_> LabelledStatement
%type <expression_> LeftHandSideExpression
%type <expression_> LeftHandSideExpressionNoBF
//%type <statement_> LetStatement
%type <literal_> Literal
%type <expression_> LogicalANDExpression
%type <expression_> LogicalANDExpressionNoBF
%type <expression_> LogicalANDExpressionNoIn
%type <expression_> LogicalORExpression
%type <expression_> LogicalORExpressionNoBF
%type <expression_> LogicalORExpressionNoIn
%type <member_> MemberAccess
%type <expression_> MemberExpression
%type <expression_> MemberExpression_
%type <expression_> MemberExpressionNoBF
%type <messageParameter_> MessageParameter
%type <messageParameter_> MessageParameters
%type <messageParameter_> MessageParameterList
%type <messageParameter_> MessageParameterListOpt
%type <bool_> MessageScope
%type <expression_> MultiplicativeExpression
%type <expression_> MultiplicativeExpressionNoBF
%type <expression_> NewExpression
%type <expression_> NewExpression_
%type <expression_> NewExpressionNoBF
%type <null_> NullLiteral
%type <literal_> ObjectLiteral
%type <expression_> PostfixExpression
%type <expression_> PostfixExpressionNoBF
%type <expression_> PrimaryExpression
%type <expression_> PrimaryExpression_
%type <expression_> PrimaryExpressionNoBF
%type <statement_> Program
%type <propertyName_> PropertyName
%type <property_> PropertyNameAndValueList
%type <property_> PropertyNameAndValueList_
%type <property_> PropertyNameAndValueListOpt
%type <literal_> RegularExpressionLiteral_
%type <condition_> RegularExpressionToken
%type <expression_> RelationalExpression
%type <infix_> RelationalExpression_
%type <expression_> RelationalExpressionNoBF
%type <expression_> RelationalExpressionNoIn
%type <infix_> RelationalExpressionNoIn_
%type <statement_> ReturnStatement
%type <selector_> SelectorExpression
%type <selector_> SelectorExpression_
%type <selector_> SelectorExpressionOpt
%type <expression_> ShiftExpression
%type <expression_> ShiftExpressionNoBF
%type <statement_> SourceElement
%type <statement_> SourceElements
%type <statement_> Statement
%type <statement_> Statement_
%type <statement_> StatementList
%type <statement_> StatementListOpt
%type <statement_> SwitchStatement
%type <statement_> ThrowStatement
%type <statement_> TryStatement
%type <expression_> TypeOpt
%type <expression_> UnaryExpression
%type <expression_> UnaryExpression_
%type <expression_> UnaryExpressionNoBF
%type <declaration_> VariableDeclaration
%type <declaration_> VariableDeclarationNoIn
%type <declarations_> VariableDeclarationList
%type <declarations_> VariableDeclarationList_
%type <declarations_> VariableDeclarationListNoIn
%type <declarations_> VariableDeclarationListNoIn_
%type <statement_> VariableStatement
%type <statement_> WhileStatement
%type <statement_> WithStatement
%type <word_> Word
%type <word_> WordOpt

%type <expression_> MessageExpression
%type <argument_> SelectorCall
%type <argument_> SelectorCall_
%type <argument_> SelectorList
%type <argument_> VariadicCall

%left "*" "/" "%"
%left "+" "-"
%left "<<" ">>" ">>>"
%left "<" ">" "<=" ">=" "instanceof" "in"
%left "==" "!=" "===" "!=="
%left "&"
%left "^"
%left "|"
%left "&&"
%left "||"

%right "=" "*=" "/=" "%=" "+=" "-=" "<<=" ">>=" ">>>=" "&=" "^=" "|="

%nonassoc "if"
%nonassoc "else"

%start Program

%%

StrictSemi
    : { driver.Warning(yylloc, "warning, automatic semi-colon insertion required"); }
    ;

Terminator_
    : ";"
    | "\n" StrictSemi
    ;

TerminatorOpt
    : Terminator_
    | error { yyerrok; driver.errors_.pop_back(); } StrictSemi
    ;

Terminator
    : Terminator_
    | error { if (yychar != 0 && yychar != cy::parser::token::CloseBrace && !yylval.newline_) YYABORT; else { yyerrok; driver.errors_.pop_back(); } } StrictSemi
    ;

/*CommaOpt
    : ","
    |
    ;*/

NewLineOpt
    : "\n"
    |
    ;

WordOpt
    : Word { $$ = $1; }
    | { $$ = NULL; }
    ;

Word
    : Identifier { $$ = $1; }
    | "break" NewLineOpt { $$ = $1; }
    | "case" { $$ = $1; }
    | "catch" { $$ = $1; }
    | "class" { $$ = $1; }
    | "const" { $$ = $1; }
    | "continue" NewLineOpt { $$ = $1; }
    | "debugger" { $$ = $1; }
    | "default" { $$ = $1; }
    | "delete" { $$ = $1; }
    | "do" { $$ = $1; }
    | "else" { $$ = $1; }
    | "enum" { $$ = $1; }
    | "export" { $$ = $1; }
    | "extends" { $$ = $1; }
    | "false" { $$ = $1; }
    | "finally" { $$ = $1; }
    | "for" { $$ = $1; }
    | "function" { $$ = $1; }
    | "if" { $$ = $1; }
    | "import" { $$ = $1; }
    /* XXX: | "in" { $$ = $1; } */
    /* XXX: | "instanceof" { $$ = $1; } */
    | "new" { $$ = $1; }
    | "null" { $$ = $1; }
    | "return" NewLineOpt { $$ = $1; }
    | "super" { $$ = $1; }
    | "switch" { $$ = $1; }
    | "this" { $$ = $1; }
    | "throw" NewLineOpt { $$ = $1; }
    | "true" { $$ = $1; }
    | "try" { $$ = $1; }
    | "typeof" { $$ = $1; }
    | "var" { $$ = $1; }
    | "void" { $$ = $1; }
    | "while" { $$ = $1; }
    | "with" { $$ = $1; }
    ;

Identifier
    : Identifier_ { $$ = $1; }

    | "implements" { $$ = $1; }
    | "interface" { $$ = $1; }
    | "package" { $$ = $1; }
    | "private" { $$ = $1; }
    | "protected" { $$ = $1; }
    | "public" { $$ = $1; }
    | "static" { $$ = $1; }

    | "abstract" { $$ = $1; }
    | "boolean" { $$ = $1; }
    | "byte" { $$ = $1; }
    | "char" { $$ = $1; }
    | "double" { $$ = $1; }
    | "final" { $$ = $1; }
    | "float" { $$ = $1; }
    | "goto" { $$ = $1; }
    | "int" { $$ = $1; }
    | "long" { $$ = $1; }
    | "native" { $$ = $1; }
    | "short" { $$ = $1; }
    | "synchronized" { $$ = $1; }
    | "throws" { $$ = $1; }
    | "transient" { $$ = $1; }
    | "volatile" { $$ = $1; }

    | "let" { $$ = $1; }
    | "yield" { $$ = $1; }

    | "each" { $$ = $1; }
    ;

IdentifierOpt
    : Identifier { $$ = $1; }
    | { $$ = NULL; }
    ;

RegularExpressionToken
    : "/" { $$ = CYDriver::RegExStart; }
    | "/=" { $$ = CYDriver::RegExRest; }
    ;

RegularExpressionLiteral_
    : RegularExpressionToken { driver.SetCondition($1); } RegularExpressionLiteral { $$ = $3; }
    ;

Literal
    : NullLiteral { $$ = $1; }
    | BooleanLiteral { $$ = $1; }
    | NumericLiteral { $$ = $1; }
    | StringLiteral { $$ = $1; }
    | RegularExpressionLiteral_ { $$ = $1; }
    ;

NullLiteral
    : "null" { $$ = $1; }
    ;

BooleanLiteral
    : "true" { $$ = $1; }
    | "false" { $$ = $1; }
    ;

/* 11.1 Primary Expressions {{{ */
PrimaryExpression_
    : "this" { $$ = $1; }
    | Identifier { $$ = new(driver.pool_) CYVariable($1); }
    | Literal { $$ = $1; }
    | ArrayLiteral { $$ = $1; }
    | "(" Expression ")" { $$ = $2; }
    ;

PrimaryExpression
    : ObjectLiteral { $$ = $1; }
    | PrimaryExpression_ { $$ = $1; }
    ;

PrimaryExpressionNoBF
    : PrimaryExpression_ { $$ = $1; }
    ;
/* }}} */
/* 11.1.4 Array Initialiser {{{ */
ArrayLiteral
    : "[" ElementListOpt "]" { $$ = new(driver.pool_) CYArray($2); }
    ;

Element
    : AssignmentExpression { $$ = $1; }
    ;

ElementOpt
    : Element { $$ = $1; }
    | { $$ = NULL; }
    ;

ElementListOpt
    : ElementList { $$ = $1; }
    | { $$ = NULL; }
    ;

ElementList
    : ElementOpt "," ElementListOpt { $$ = new(driver.pool_) CYElement($1, $3); }
    | Element { $$ = new(driver.pool_) CYElement($1, NULL); }
    ;
/* }}} */
/* 11.1.5 Object Initialiser {{{ */
ObjectLiteral
    : "{" PropertyNameAndValueListOpt "}" { $$ = new(driver.pool_) CYObject($2); }
    ;

PropertyNameAndValueList_
    : "," PropertyNameAndValueList { $$ = $2; }
    | { $$ = NULL; }
    ;

PropertyNameAndValueListOpt
    : PropertyNameAndValueList { $$ = $1; }
    | { $$ = NULL; }
    ;

PropertyNameAndValueList
    : PropertyName ":" AssignmentExpression PropertyNameAndValueList_ { $$ = new(driver.pool_) CYProperty($1, $3, $4); }
    ;

PropertyName
    : Identifier { $$ = $1; }
    | StringLiteral { $$ = $1; }
    | NumericLiteral { $$ = $1; }
    ;
/* }}} */

/* 11.2 Left-Hand-Side Expressions {{{ */
MemberExpression_
    : "new" MemberExpression Arguments { $$ = new(driver.pool_) CYNew($2, $3); }
    ;

MemberAccess
    : "[" Expression "]" { $$ = new(driver.pool_) CYDirectMember(NULL, $2); }
    | "." Identifier { $$ = new(driver.pool_) CYDirectMember(NULL, new(driver.pool_) CYString($2)); }
    ;

MemberExpression
    : PrimaryExpression { $$ = $1; }
    | FunctionExpression { $$ = $1; }
    | MemberExpression MemberAccess { $2->SetLeft($1); $$ = $2; }
    | MemberExpression_ { $$ = $1; }
    ;

MemberExpressionNoBF
    : PrimaryExpressionNoBF { $$ = $1; }
    | MemberExpressionNoBF MemberAccess { $2->SetLeft($1); $$ = $2; }
    | MemberExpression_ { $$ = $1; }
    ;

NewExpression_
    : "new" NewExpression { $$ = new(driver.pool_) CYNew($2, NULL); }
    ;

NewExpression
    : MemberExpression { $$ = $1; }
    | NewExpression_ { $$ = $1; }
    ;

NewExpressionNoBF
    : MemberExpressionNoBF { $$ = $1; }
    | NewExpression_ { $$ = $1; }
    ;

CallExpression
    : MemberExpression Arguments { $$ = new(driver.pool_) CYCall($1, $2); }
    | CallExpression Arguments { $$ = new(driver.pool_) CYCall($1, $2); }
    | CallExpression MemberAccess { $2->SetLeft($1); $$ = $2; }
    ;

CallExpressionNoBF
    : MemberExpressionNoBF Arguments { $$ = new(driver.pool_) CYCall($1, $2); }
    | CallExpressionNoBF Arguments { $$ = new(driver.pool_) CYCall($1, $2); }
    | CallExpressionNoBF MemberAccess { $2->SetLeft($1); $$ = $2; }
    ;

ArgumentList_
    : "," ArgumentList { $$ = $2; }
    | { $$ = NULL; }
    ;

ArgumentListOpt
    : ArgumentList { $$ = $1; }
    | { $$ = NULL; }
    ;

ArgumentList
    : AssignmentExpression ArgumentList_ { $$ = new(driver.pool_) CYArgument(NULL, $1, $2); }
    ;

Arguments
    : "(" ArgumentListOpt ")" { $$ = $2; }
    ;

LeftHandSideExpression
    : NewExpression { $$ = $1; }
    | CallExpression { $$ = $1; }
    ;

LeftHandSideExpressionNoBF
    : NewExpressionNoBF { $$ = $1; }
    | CallExpressionNoBF { $$ = $1; }
    ;
/* }}} */
/* 11.3 Postfix Expressions {{{ */
PostfixExpression
    : AssigneeExpression { $$ = $1; }
    | LeftHandSideExpression "++" { $$ = new(driver.pool_) CYPostIncrement($1); }
    | LeftHandSideExpression "--" { $$ = new(driver.pool_) CYPostDecrement($1); }
    ;

PostfixExpressionNoBF
    : AssigneeExpressionNoBF { $$ = $1; }
    | LeftHandSideExpressionNoBF "++" { $$ = new(driver.pool_) CYPostIncrement($1); }
    | LeftHandSideExpressionNoBF "--" { $$ = new(driver.pool_) CYPostDecrement($1); }
    ;
/* }}} */
/* 11.4 Unary Operators {{{ */
UnaryExpression_
    : "delete" UnaryExpression { $$ = new(driver.pool_) CYDelete($2); }
    | "void" UnaryExpression { $$ = new(driver.pool_) CYVoid($2); }
    | "typeof" UnaryExpression { $$ = new(driver.pool_) CYTypeOf($2); }
    | "++" UnaryExpression { $$ = new(driver.pool_) CYPreIncrement($2); }
    | "\n++" UnaryExpression { $$ = new(driver.pool_) CYPreIncrement($2); }
    | "--" UnaryExpression { $$ = new(driver.pool_) CYPreDecrement($2); }
    | "\n--" UnaryExpression { $$ = new(driver.pool_) CYPreDecrement($2); }
    | "+" UnaryExpression { $$ = new(driver.pool_) CYAffirm($2); }
    | "-" UnaryExpression { $$ = new(driver.pool_) CYNegate($2); }
    | "~" UnaryExpression { $$ = new(driver.pool_) CYBitwiseNot($2); }
    | "!" UnaryExpression { $$ = new(driver.pool_) CYLogicalNot($2); }
    ;

UnaryExpression
    : PostfixExpression { $$ = $1; }
    | UnaryExpression_ { $$ = $1; }
    ;

UnaryExpressionNoBF
    : PostfixExpressionNoBF { $$ = $1; }
    | UnaryExpression_ { $$ = $1; }
    ;
/* }}} */
/* 11.5 Multiplicative Operators {{{ */
MultiplicativeExpression
    : UnaryExpression { $$ = $1; }
    | MultiplicativeExpression "*" UnaryExpression { $$ = new(driver.pool_) CYMultiply($1, $3); }
    | MultiplicativeExpression "/" UnaryExpression { $$ = new(driver.pool_) CYDivide($1, $3); }
    | MultiplicativeExpression "%" UnaryExpression { $$ = new(driver.pool_) CYModulus($1, $3); }
    ;

MultiplicativeExpressionNoBF
    : UnaryExpressionNoBF { $$ = $1; }
    | MultiplicativeExpressionNoBF "*" UnaryExpression { $$ = new(driver.pool_) CYMultiply($1, $3); }
    | MultiplicativeExpressionNoBF "/" UnaryExpression { $$ = new(driver.pool_) CYDivide($1, $3); }
    | MultiplicativeExpressionNoBF "%" UnaryExpression { $$ = new(driver.pool_) CYModulus($1, $3); }
    ;
/* }}} */
/* 11.6 Additive Operators {{{ */
AdditiveExpression
    : MultiplicativeExpression { $$ = $1; }
    | AdditiveExpression "+" MultiplicativeExpression { $$ = new(driver.pool_) CYAdd($1, $3); }
    | AdditiveExpression "-" MultiplicativeExpression { $$ = new(driver.pool_) CYSubtract($1, $3); }
    ;

AdditiveExpressionNoBF
    : MultiplicativeExpressionNoBF { $$ = $1; }
    | AdditiveExpressionNoBF "+" MultiplicativeExpression { $$ = new(driver.pool_) CYAdd($1, $3); }
    | AdditiveExpressionNoBF "-" MultiplicativeExpression { $$ = new(driver.pool_) CYSubtract($1, $3); }
    ;
/* }}} */
/* 11.7 Bitwise Shift Operators {{{ */
ShiftExpression
    : AdditiveExpression { $$ = $1; }
    | ShiftExpression "<<" AdditiveExpression { $$ = new(driver.pool_) CYShiftLeft($1, $3); }
    | ShiftExpression ">>" AdditiveExpression { $$ = new(driver.pool_) CYShiftRightSigned($1, $3); }
    | ShiftExpression ">>>" AdditiveExpression { $$ = new(driver.pool_) CYShiftRightUnsigned($1, $3); }
    ;

ShiftExpressionNoBF
    : AdditiveExpressionNoBF { $$ = $1; }
    | ShiftExpressionNoBF "<<" AdditiveExpression { $$ = new(driver.pool_) CYShiftLeft($1, $3); }
    | ShiftExpressionNoBF ">>" AdditiveExpression { $$ = new(driver.pool_) CYShiftRightSigned($1, $3); }
    | ShiftExpressionNoBF ">>>" AdditiveExpression { $$ = new(driver.pool_) CYShiftRightUnsigned($1, $3); }
    ;
/* }}} */
/* 11.8 Relational Operators {{{ */
RelationalExpressionNoIn_
    : "<" ShiftExpression { $$ = new(driver.pool_) CYLess(NULL, $2); }
    | ">" ShiftExpression { $$ = new(driver.pool_) CYGreater(NULL, $2); }
    | "<=" ShiftExpression { $$ = new(driver.pool_) CYLessOrEqual(NULL, $2); }
    | ">=" ShiftExpression { $$ = new(driver.pool_) CYGreaterOrEqual(NULL, $2); }
    | "instanceof" ShiftExpression { $$ = new(driver.pool_) CYInstanceOf(NULL, $2); }
    ;

RelationalExpression_
    : RelationalExpressionNoIn_ { $$ = $1; }
    | "in" ShiftExpression { $$ = new(driver.pool_) CYIn(NULL, $2); }
    ;

RelationalExpression
    : ShiftExpression { $$ = $1; }
    | RelationalExpression RelationalExpression_ { $2->SetLeft($1); $$ = $2; }
    ;

RelationalExpressionNoIn
    : ShiftExpression { $$ = $1; }
    | RelationalExpressionNoIn RelationalExpressionNoIn_ { $2->SetLeft($1); $$ = $2; }
    ;

RelationalExpressionNoBF
    : ShiftExpressionNoBF { $$ = $1; }
    | RelationalExpressionNoBF RelationalExpression_ { $2->SetLeft($1); $$ = $2; }
    ;
/* }}} */
/* 11.9 Equality Operators {{{ */
EqualityExpression
    : RelationalExpression { $$ = $1; }
    | EqualityExpression "==" RelationalExpression { $$ = new(driver.pool_) CYEqual($1, $3); }
    | EqualityExpression "!=" RelationalExpression { $$ = new(driver.pool_) CYNotEqual($1, $3); }
    | EqualityExpression "===" RelationalExpression { $$ = new(driver.pool_) CYIdentical($1, $3); }
    | EqualityExpression "!==" RelationalExpression { $$ = new(driver.pool_) CYNotIdentical($1, $3); }
    ;

EqualityExpressionNoIn
    : RelationalExpressionNoIn { $$ = $1; }
    | EqualityExpressionNoIn "==" RelationalExpressionNoIn { $$ = new(driver.pool_) CYEqual($1, $3); }
    | EqualityExpressionNoIn "!=" RelationalExpressionNoIn { $$ = new(driver.pool_) CYNotEqual($1, $3); }
    | EqualityExpressionNoIn "===" RelationalExpressionNoIn { $$ = new(driver.pool_) CYIdentical($1, $3); }
    | EqualityExpressionNoIn "!==" RelationalExpressionNoIn { $$ = new(driver.pool_) CYNotIdentical($1, $3); }
    ;

EqualityExpressionNoBF
    : RelationalExpressionNoBF { $$ = $1; }
    | EqualityExpressionNoBF "==" RelationalExpression { $$ = new(driver.pool_) CYEqual($1, $3); }
    | EqualityExpressionNoBF "!=" RelationalExpression { $$ = new(driver.pool_) CYNotEqual($1, $3); }
    | EqualityExpressionNoBF "===" RelationalExpression { $$ = new(driver.pool_) CYIdentical($1, $3); }
    | EqualityExpressionNoBF "!==" RelationalExpression { $$ = new(driver.pool_) CYNotIdentical($1, $3); }
    ;
/* }}} */
/* 11.10 Binary Bitwise Operators {{{ */
BitwiseANDExpression
    : EqualityExpression { $$ = $1; }
    | BitwiseANDExpression "&" EqualityExpression { $$ = new(driver.pool_) CYBitwiseAnd($1, $3); }
    ;

BitwiseANDExpressionNoIn
    : EqualityExpressionNoIn { $$ = $1; }
    | BitwiseANDExpressionNoIn "&" EqualityExpressionNoIn { $$ = new(driver.pool_) CYBitwiseAnd($1, $3); }
    ;

BitwiseANDExpressionNoBF
    : EqualityExpressionNoBF { $$ = $1; }
    | BitwiseANDExpressionNoBF "&" EqualityExpression { $$ = new(driver.pool_) CYBitwiseAnd($1, $3); }
    ;

BitwiseXORExpression
    : BitwiseANDExpression { $$ = $1; }
    | BitwiseXORExpression "^" BitwiseANDExpression { $$ = new(driver.pool_) CYBitwiseXOr($1, $3); }
    ;

BitwiseXORExpressionNoIn
    : BitwiseANDExpressionNoIn { $$ = $1; }
    | BitwiseXORExpressionNoIn "^" BitwiseANDExpressionNoIn { $$ = new(driver.pool_) CYBitwiseXOr($1, $3); }
    ;

BitwiseXORExpressionNoBF
    : BitwiseANDExpressionNoBF { $$ = $1; }
    | BitwiseXORExpressionNoBF "^" BitwiseANDExpression { $$ = new(driver.pool_) CYBitwiseXOr($1, $3); }
    ;

BitwiseORExpression
    : BitwiseXORExpression { $$ = $1; }
    | BitwiseORExpression "|" BitwiseXORExpression { $$ = new(driver.pool_) CYBitwiseOr($1, $3); }
    ;

BitwiseORExpressionNoIn
    : BitwiseXORExpressionNoIn { $$ = $1; }
    | BitwiseORExpressionNoIn "|" BitwiseXORExpressionNoIn { $$ = new(driver.pool_) CYBitwiseOr($1, $3); }
    ;

BitwiseORExpressionNoBF
    : BitwiseXORExpressionNoBF { $$ = $1; }
    | BitwiseORExpressionNoBF "|" BitwiseXORExpression { $$ = new(driver.pool_) CYBitwiseOr($1, $3); }
    ;
/* }}} */
/* 11.11 Binary Logical Operators {{{ */
LogicalANDExpression
    : BitwiseORExpression { $$ = $1; }
    | LogicalANDExpression "&&" BitwiseORExpression { $$ = new(driver.pool_) CYLogicalAnd($1, $3); }
    ;

LogicalANDExpressionNoIn
    : BitwiseORExpressionNoIn { $$ = $1; }
    | LogicalANDExpressionNoIn "&&" BitwiseORExpressionNoIn { $$ = new(driver.pool_) CYLogicalAnd($1, $3); }
    ;

LogicalANDExpressionNoBF
    : BitwiseORExpressionNoBF { $$ = $1; }
    | LogicalANDExpressionNoBF "&&" BitwiseORExpression { $$ = new(driver.pool_) CYLogicalAnd($1, $3); }
    ;

LogicalORExpression
    : LogicalANDExpression { $$ = $1; }
    | LogicalORExpression "||" LogicalANDExpression { $$ = new(driver.pool_) CYLogicalOr($1, $3); }
    ;

LogicalORExpressionNoIn
    : LogicalANDExpressionNoIn { $$ = $1; }
    | LogicalORExpressionNoIn "||" LogicalANDExpressionNoIn { $$ = new(driver.pool_) CYLogicalOr($1, $3); }
    ;

LogicalORExpressionNoBF
    : LogicalANDExpressionNoBF { $$ = $1; }
    | LogicalORExpressionNoBF "||" LogicalANDExpression { $$ = new(driver.pool_) CYLogicalOr($1, $3); }
    ;
/* }}} */
/* 11.12 Conditional Operator ( ? : ) {{{ */
ConditionalExpression
    : LogicalORExpression { $$ = $1; }
    | LogicalORExpression "?" AssignmentExpression ":" AssignmentExpression { $$ = new(driver.pool_) CYCondition($1, $3, $5); }
    ;

ConditionalExpressionNoIn
    : LogicalORExpressionNoIn { $$ = $1; }
    | LogicalORExpressionNoIn "?" AssignmentExpression ":" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYCondition($1, $3, $5); }
    ;

ConditionalExpressionNoBF
    : LogicalORExpressionNoBF { $$ = $1; }
    | LogicalORExpressionNoBF "?" AssignmentExpression ":" AssignmentExpression { $$ = new(driver.pool_) CYCondition($1, $3, $5); }
    ;
/* }}} */
/* 11.13 Assignment Operators {{{ */
AssignmentExpression_
    : "=" AssignmentExpression { $$ = new(driver.pool_) CYAssign(NULL, $2); }
    | "*=" AssignmentExpression { $$ = new(driver.pool_) CYMultiplyAssign(NULL, $2); }
    | "/=" AssignmentExpression { $$ = new(driver.pool_) CYDivideAssign(NULL, $2); }
    | "%=" AssignmentExpression { $$ = new(driver.pool_) CYModulusAssign(NULL, $2); }
    | "+=" AssignmentExpression { $$ = new(driver.pool_) CYAddAssign(NULL, $2); }
    | "-=" AssignmentExpression { $$ = new(driver.pool_) CYSubtractAssign(NULL, $2); }
    | "<<=" AssignmentExpression { $$ = new(driver.pool_) CYShiftLeftAssign(NULL, $2); }
    | ">>=" AssignmentExpression { $$ = new(driver.pool_) CYShiftRightSignedAssign(NULL, $2); }
    | ">>>=" AssignmentExpression { $$ = new(driver.pool_) CYShiftRightUnsignedAssign(NULL, $2); }
    | "&=" AssignmentExpression { $$ = new(driver.pool_) CYBitwiseAndAssign(NULL, $2); }
    | "^=" AssignmentExpression { $$ = new(driver.pool_) CYBitwiseXOrAssign(NULL, $2); }
    | "|=" AssignmentExpression { $$ = new(driver.pool_) CYBitwiseOrAssign(NULL, $2); }
    ;

AssigneeExpression
    : LeftHandSideExpression { $$ = $1; }
    | AssigneeExpression_ { $$ = $1; }
    ;

AssigneeExpressionNoBF
    : LeftHandSideExpressionNoBF { $$ = $1; }
    | AssigneeExpression_ { $$ = $1; }
    ;

AssignmentExpression
    : ConditionalExpression { $$ = $1; }
    | AssigneeExpression AssignmentExpression_ { $2->SetLeft($1); $$ = $2; }
    ;

AssignmentExpressionNoIn
    : ConditionalExpressionNoIn { $$ = $1; }
    | AssigneeExpression "=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYAssign($1, $3); }
    | AssigneeExpression "*=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYMultiplyAssign($1, $3); }
    | AssigneeExpression "/=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYDivideAssign($1, $3); }
    | AssigneeExpression "%=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYModulusAssign($1, $3); }
    | AssigneeExpression "+=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYAddAssign($1, $3); }
    | AssigneeExpression "-=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYSubtractAssign($1, $3); }
    | AssigneeExpression "<<=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYShiftLeftAssign($1, $3); }
    | AssigneeExpression ">>=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYShiftRightSignedAssign($1, $3); }
    | AssigneeExpression ">>>=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYShiftRightUnsignedAssign($1, $3); }
    | AssigneeExpression "&=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYBitwiseAndAssign($1, $3); }
    | AssigneeExpression "^=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYBitwiseXOrAssign($1, $3); }
    | AssigneeExpression "|=" AssignmentExpressionNoIn { $$ = new(driver.pool_) CYBitwiseOrAssign($1, $3); }
    ;

AssignmentExpressionNoBF
    : ConditionalExpressionNoBF { $$ = $1; }
    | AssigneeExpressionNoBF AssignmentExpression_ { $2->SetLeft($1); $$ = $2; }
    ;
/* }}} */
/* 11.14 Comma Operator {{{ */
Expression_
    : "," Expression { $$ = new(driver.pool_) CYCompound($2); }
    | { $$ = NULL; }
    ;

ExpressionNoIn_
    : "," ExpressionNoIn { $$ = new(driver.pool_) CYCompound($2); }
    | { $$ = NULL; }
    ;

ExpressionOpt
    : Expression { $$ = $1; }
    | { $$ = NULL; }
    ;

ExpressionNoInOpt
    : ExpressionNoIn { $$ = $1; }
    | { $$ = NULL; }
    ;

Expression
    : AssignmentExpression Expression_ { if ($2) { $2->AddPrev($1); $$ = $2; } else $$ = $1; }
    ;

ExpressionNoIn
    : AssignmentExpressionNoIn ExpressionNoIn_ { if ($2) { $2->AddPrev($1); $$ = $2; } else $$ = $1; }
    ;

ExpressionNoBF
    : AssignmentExpressionNoBF Expression_ { if ($2) { $2->AddPrev($1); $$ = $2; } else $$ = $1; }
    ;
/* }}} */

/* 12 Statements {{{ */
Statement_
    : Block { $$ = $1; }
    | VariableStatement { $$ = $1; }
    | EmptyStatement { $$ = $1; }
    | ExpressionStatement { $$ = $1; }
    | IfStatement { $$ = $1; }
    | IterationStatement { $$ = $1; }
    | ContinueStatement { $$ = $1; }
    | BreakStatement { $$ = $1; }
    | ReturnStatement { $$ = $1; }
    | WithStatement { $$ = $1; }
    | LabelledStatement { $$ = $1; }
    | SwitchStatement { $$ = $1; }
    | ThrowStatement { $$ = $1; }
    | TryStatement { $$ = $1; }
    ;

Statement
    : Statement_ { $$ = $1; }
    ;
/* }}} */
/* 12.1 Block {{{ */
Block_
    : "{" StatementListOpt "}" { $$ = $2; }
    ;

Block
    : Block_ { if ($1) $$ = new(driver.pool_) CYBlock($1); else $$ = new(driver.pool_) CYEmpty(); }
    ;

StatementList
    : Statement StatementListOpt { $1->SetNext($2); $$ = $1; }
    ;

StatementListOpt
    : StatementList { $$ = $1; }
    | { $$ = NULL; }
    ;
/* }}} */
/* 12.2 Variable Statement {{{ */
VariableStatement
    : "var" VariableDeclarationList Terminator { $$ = new(driver.pool_) CYVar($2); }
    ;

VariableDeclarationList_
    : "," VariableDeclarationList { $$ = $2; }
    | { $$ = NULL; }
    ;

VariableDeclarationListNoIn_
    : "," VariableDeclarationListNoIn { $$ = $2; }
    | { $$ = NULL; }
    ;

VariableDeclarationList
    : VariableDeclaration VariableDeclarationList_ { $$ = new(driver.pool_) CYDeclarations($1, $2); }
    ;

VariableDeclarationListNoIn
    : VariableDeclarationNoIn VariableDeclarationListNoIn_ { $$ = new(driver.pool_) CYDeclarations($1, $2); }
    ;

VariableDeclaration
    : Identifier InitialiserOpt { $$ = new(driver.pool_) CYDeclaration($1, $2); }
    ;

VariableDeclarationNoIn
    : Identifier InitialiserNoInOpt { $$ = new(driver.pool_) CYDeclaration($1, $2); }
    ;

InitialiserOpt
    : Initialiser { $$ = $1; }
    | { $$ = NULL; }
    ;

InitialiserNoInOpt
    : InitialiserNoIn { $$ = $1; }
    | { $$ = NULL; }
    ;

Initialiser
    : "=" AssignmentExpression { $$ = $2; }
    ;

InitialiserNoIn
    : "=" AssignmentExpressionNoIn { $$ = $2; }
    ;
/* }}} */
/* 12.3 Empty Statement {{{ */
EmptyStatement
    : ";" { $$ = new(driver.pool_) CYEmpty(); }
    ;
/* }}} */
/* 12.4 Expression Statement {{{ */
ExpressionStatement
    : ExpressionNoBF Terminator { $$ = new(driver.pool_) CYExpress($1); }
    ;
/* }}} */
/* 12.5 The if Statement {{{ */
ElseStatementOpt
    : "else" Statement { $$ = $2; }
    | %prec "if" { $$ = NULL; }
    ;

IfStatement
    : "if" "(" Expression ")" Statement ElseStatementOpt { $$ = new(driver.pool_) CYIf($3, $5, $6); }
    ;
/* }}} */

/* 12.6 Iteration Statements {{{ */
IterationStatement
    : DoWhileStatement { $$ = $1; }
    | WhileStatement { $$ = $1; }
    | ForStatement { $$ = $1; }
    | ForInStatement { $$ = $1; }
    ;
/* }}} */
/* 12.6.1 The do-while Statement {{{ */
DoWhileStatement
    : "do" Statement "while" "(" Expression ")" TerminatorOpt { $$ = new(driver.pool_) CYDoWhile($5, $2); }
    ;
/* }}} */
/* 12.6.2 The while Statement {{{ */
WhileStatement
    : "while" "(" Expression ")" Statement { $$ = new(driver.pool_) CYWhile($3, $5); }
    ;
/* }}} */
/* 12.6.3 The for Statement {{{ */
ForStatement
    : "for" "(" ForStatementInitialiser ";" ExpressionOpt ";" ExpressionOpt ")" Statement { $$ = new(driver.pool_) CYFor($3, $5, $7, $9); }
    ;

ForStatementInitialiser
    : ExpressionNoInOpt { $$ = $1; }
    | "var" VariableDeclarationListNoIn { $$ = $2; }
    ;
/* }}} */
/* 12.6.4 The for-in Statement {{{ */
ForInStatement
    : "for" "(" ForInStatementInitialiser "in" Expression ")" Statement { $$ = new(driver.pool_) CYForIn($3, $5, $7); }
    ;

ForInStatementInitialiser
    : LeftHandSideExpression { $$ = $1; }
    | "var" VariableDeclarationNoIn { $$ = $2; }
    ;
/* }}} */

/* 12.7 The continue Statement {{{ */
ContinueStatement
    : "continue" IdentifierOpt Terminator { $$ = new(driver.pool_) CYContinue($2); }
    ;
/* }}} */
/* 12.8 The break Statement {{{ */
BreakStatement
    : "break" IdentifierOpt Terminator { $$ = new(driver.pool_) CYBreak($2); }
    ;
/* }}} */
/* 12.9 The return Statement {{{ */
ReturnStatement
    : "return" ExpressionOpt Terminator { $$ = new(driver.pool_) CYReturn($2); }
    ;
/* }}} */
/* 12.10 The with Statement {{{ */
WithStatement
    : "with" "(" Expression ")" Statement { $$ = new(driver.pool_) CYWith($3, $5); }
    ;
/* }}} */

/* 12.11 The switch Statement {{{ */
SwitchStatement
    : "switch" "(" Expression ")" CaseBlock { $$ = new(driver.pool_) CYSwitch($3, $5); }
    ;

CaseBlock
    : "{" CaseClausesOpt "}" { $$ = $2; }
    ;

CaseClausesOpt
    : CaseClause CaseClausesOpt { $1->SetNext($2); $$ = $1; }
    | DefaultClause CaseClausesOpt { $1->SetNext($2); $$ = $1; }
    | { $$ = NULL; }
    ;

CaseClause
    : "case" Expression ":" StatementListOpt { $$ = new(driver.pool_) CYClause($2, $4); }
    ;

DefaultClause
    : "default" ":" StatementListOpt { $$ = new(driver.pool_) CYClause(NULL, $3); }
    ;
/* }}} */
/* 12.12 Labelled Statements {{{ */
LabelledStatement
    : Identifier ":" Statement { $3->AddLabel($1); $$ = $3; }
    ;
/* }}} */
/* 12.13 The throw Statement {{{ */
ThrowStatement
    : "throw" Expression Terminator { $$ = new(driver.pool_) CYThrow($2); }
    ;
/* }}} */
/* 12.14 The try Statement {{{ */
TryStatement
    : "try" Block_ CatchOpt FinallyOpt { $$ = new(driver.pool_) CYTry($2, $3, $4); }
    ;

CatchOpt
    : "catch" "(" Identifier ")" Block_ { $$ = new(driver.pool_) CYCatch($3, $5); }
    | { $$ = NULL; }
    ;

FinallyOpt
    : "finally" Block_ { $$ = new(driver.pool_) CYFinally($2); }
    | { $$ = NULL; }
    ;
/* }}} */

/* 13 Function Definition {{{ */
FunctionDeclaration
    : "function" Identifier "(" FormalParameterList ")" "{" FunctionBody "}" { $$ = new(driver.pool_) CYFunctionStatement($2, $4, $7); }
    ;

FunctionExpression
    : "function" IdentifierOpt "(" FormalParameterList ")" "{" FunctionBody "}" { $$ = new(driver.pool_) CYFunctionExpression($2, $4, $7); }
    ;

FormalParameterList_
    : "," FormalParameterList { $$ = $2; }
    | { $$ = NULL; }
    ;

FormalParameterList
    : Identifier FormalParameterList_ { $$ = new(driver.pool_) CYFunctionParameter($1, $2); }
    | { $$ = NULL; }
    ;

FunctionBody
    : SourceElements { $$ = $1; }
    ;
/* }}} */
/* 14 Program {{{ */
Program
    : SourceElements { driver.program_ = $1; }
    ;

SourceElements
    : SourceElement SourceElements { $1->SetNext($2); $$ = $1; }
    | { $$ = NULL; }
    ;

SourceElement
    : Statement_ { $$ = $1; }
    | FunctionDeclaration { $$ = $1; }
    ;
/* }}} */

/* Cycript: @class Declaration {{{ */
ClassSuperOpt
    : ":" MemberExpressionNoBF { $$ = $2; }
    | { $$ = NULL; }
    ;

ClassFieldList
    : "{" "}" { $$ = NULL; }
    ;

MessageScope
    : "+" { $$ = false; }
    | "-" { $$ = true; }
    ;

TypeOpt
    : "(" Expression ")" { $$ = $2; }
    | { $$ = NULL; }
    ;

MessageParameter
    : Word ":" TypeOpt Identifier { $$ = new(driver.pool_) CYMessageParameter($1, $3, $4); }
    ;

MessageParameterListOpt
    : MessageParameterList { $$ = $1; }
    | { $$ = NULL; }
    ;

MessageParameterList
    : MessageParameter MessageParameterListOpt { $1->SetNext($2); $$ = $1; }
    ;

MessageParameters
    : MessageParameterList { $$ = $1; }
    | Word { $$ = new(driver.pool_) CYMessageParameter($1, NULL, NULL); }
    ;

ClassMessageDeclaration
    : MessageScope TypeOpt MessageParameters "{" FunctionBody "}" { $$ = new(driver.pool_) CYMessage($1, $2, $3, $5); }
    ;

ClassMessageDeclarationListOpt
    : ClassMessageDeclarationListOpt ClassMessageDeclaration { $2->SetNext($1); $$ = $2; }
    | { $$ = NULL; }
    ;

ClassName
    : Identifier { $$ = $1; }
    | "(" AssignmentExpression ")" { $$ = $2; }
    ;

ClassNameOpt
    : ClassName { $$ = $1; }
    | { $$ = NULL; }
    ;

ClassExpression
    : "@class" ClassNameOpt ClassSuperOpt ClassFieldList ClassMessageDeclarationListOpt "@end" { $$ = new(driver.pool_) CYClassExpression($2, $3, $4, $5); }
    ;

ClassStatement
    : "@class" ClassName ClassSuperOpt ClassFieldList ClassMessageDeclarationListOpt "@end" { $$ = new(driver.pool_) CYClassStatement($2, $3, $4, $5); }
    ;

CategoryStatement
    : "@class" ClassName ClassMessageDeclarationListOpt "@end" { $$ = new(driver.pool_) CYCategory($2, $3); }
    ;

PrimaryExpression
    : ClassExpression { $$ = $1; }
    ;

Statement_
    : ClassStatement { $$ = $1; }
    | CategoryStatement { $$ = $1; }
    ;
/* }}} */
/* Cycript: Send Message {{{ */
VariadicCall
    : "," AssignmentExpression VariadicCall { $$ = new(driver.pool_) CYArgument(NULL, $2, $3); }
    | { $$ = NULL; }
    ;

SelectorCall_
    : SelectorCall { $$ = $1; }
    | VariadicCall { $$ = $1; }
    ;

SelectorCall
    : WordOpt ":" AssignmentExpression SelectorCall_ { $$ = new(driver.pool_) CYArgument($1 ?: new(driver.pool_) CYBlank(), $3, $4); }
    ;

SelectorList
    : SelectorCall { $$ = $1; }
    | Word { $$ = new(driver.pool_) CYArgument($1, NULL); }
    ;

MessageExpression
    : "[" AssignmentExpression SelectorList "]" { $$ = new(driver.pool_) CYSend($2, $3); }
    ;

SelectorExpressionOpt
    : SelectorExpression_ { $$ = $1; }
    | { $$ = NULL; }
    ;

SelectorExpression_
    : WordOpt ":" SelectorExpressionOpt { $$ = new(driver.pool_) CYSelectorPart($1, true, $3); }
    ;

SelectorExpression
    : SelectorExpression_ { $$ = $1; }
    | Word { $$ = new(driver.pool_) CYSelectorPart($1, false, NULL); }
    ;

PrimaryExpression_
    : MessageExpression { $$ = $1; }
    | "@selector" "(" SelectorExpression ")" { $$ = new(driver.pool_) CYSelector($3); }
    ;
/* }}} */
/* Cycript: Pointer Indirection/Addressing {{{ */
AssigneeExpression_
    : "*" UnaryExpression { $$ = new(driver.pool_) CYIndirect($2); }
    ;

UnaryExpression_
    : "&" UnaryExpression { $$ = new(driver.pool_) CYAddressOf($2); }
    ;

MemberAccess
    : "->" Identifier { $$ = new(driver.pool_) CYIndirectMember(NULL, new(driver.pool_) CYString($2)); }
    ;
/* }}} */
/* ECMAScript5: Object Literal Trailing Comma {{{ */
PropertyNameAndValueList_
    : "," { $$ = NULL; }
    ;
/* }}} */
/* JavaScript 1.7: Array Comprehensions {{{ */
IfComprehension
    : "if" "(" Expression ")" { $$ = new(driver.pool_) CYIfComprehension($3); }
    ;

ForComprehension
    : "for" "(" Identifier "in" Expression ")" { $$ = new(driver.pool_) CYForInComprehension($3, $5); }
    | "for" "each" "(" Identifier "in" Expression ")" { $$ = new(driver.pool_) CYForEachInComprehension($4, $6); }
    ;

ComprehensionListOpt
    : ComprehensionList { $$ = $1; }
    | IfComprehension { $$ = $1; }
    | { $$ = NULL; }
    ;

ComprehensionList
    : ForComprehension ComprehensionListOpt { $1->SetNext($2); $$ = $1; }
    ;

PrimaryExpression_
    : "[" AssignmentExpression ComprehensionList "]" { $$ = new(driver.pool_) CYArrayComprehension($2, $3); }
    ;
/* }}} */
/* JavaScript 1.7: for each {{{ */
ForInStatement
    : "for" "each" "(" ForInStatementInitialiser "in" Expression ")" Statement { $$ = new(driver.pool_) CYForEachIn($4, $6, $8); }
    ;
/* }}} */
/* JavaScript 1.7: let Statements {{{ *//*
LetStatement
    : "let" "(" VariableDeclarationList ")" Block_ { $$ = new(driver.pool_) CYLet($3, $5); }
    ;

Statement
    : LetStatement
    ;
*//* }}} */
/* JavaScript FTW: Function Statements {{{ */
Statement
    : FunctionDeclaration { driver.Warning(yylloc, "warning, FunctionDeclaration is a SourceElement, not a Statement"); } { $$ = $1; }
    ;
/* }}} */

%%
