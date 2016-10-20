/*
   The MIT License (MIT)

   Copyright (c) 2016 Yannick Scherer
   Copyright (c) 2015 Joseph T. McBride

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to
   deal in the Software without restriction, including without limitation the
   rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
   sell copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
*/

/*
    GraphQL schema grammar derived from:

       * GraphQL Draft Specification, April 2016
       * http://graphql.org/learn/schema/
*/

grammar GraphQLSchema;

schema
    : definition+
    ;

definition
    : typeDefinition
    | interfaceDefinition
    | schemaDefinition
    | enumDefinition
    | unionDefinition
    | inputTypeDefinition
    | directiveDefinition
    | scalarDefinition
    | typeExtensionDefinition
    ;

// --------------- OUTPUT TYPE ---------------

typeDefinition
    : 'type' typeName typeImplements? '{' typeField+ '}'
    ;

typeImplements
    : 'implements' typeName+
    ;

typeField
    : fieldName arguments? ':' type
    ;

fieldName
    : anyName
    ;

arguments
    : '(' argument+ ')'
    ;

argument
    : anyName ':' type defaultValue?
    ;

defaultValue
    : '=' value
    ;

// --------------- INTERFACE ---------------

interfaceDefinition
    : 'interface' typeName '{' typeField+ '}'
    ;

// --------------- SCHEMA ---------------

schemaDefinition
    : 'schema' '{' schemaType+ '}'
    ;

schemaType
    : (K_MUTATION | K_QUERY | K_SUBSCRIPTION) ':' typeName
    ;

// --------------- ENUM ---------------

enumDefinition
    : 'enum' typeName '{' enumField+ '}'
    ;

enumField
    : enumValue enumType?
    ;

enumType
    : '@enum' 'Int' '(' 'value' ':' intValue ')'
    ;

// --------------- UNION ---------------

unionDefinition
    : 'union' typeName '=' unionTypeNames
    ;

unionTypeNames
    : typeName ( '|' typeName )*
    ;

// --------------- INPUT TYPE ---------------

inputTypeDefinition
    : 'input' typeName '{' inputTypeField+ '}'
    ;

inputTypeField
    : fieldName ':' typeName
    ;

// --------------- DIRECTIVES ---------------

directiveDefinition
    : 'directive' directiveName typeCondition
    ;

directiveName
    : '@' anyName
    ;

// --------------- EXTEND TYPE ---------------

typeExtensionDefinition
    : 'extend' typeDefinition
    ;

// --------------- SCALAR ---------------

scalarDefinition
    : 'scalar' typeName
    ;

// --------------- TYPES ---------------

type
    : typeName
    | listType
    | nonNullType
    ;

typeName
    : anyName
    ;

listType
    : '[' type ']'
    ;

nonNullType
    : typeName '!'
    | listType '!'
    ;

typeCondition
    : 'on' typeName
    ;

// --------------- VALUES ---------------

value
    : intValue
    | floatValue
    | booleanValue
    | stringValue
    | enumValue
    ;

intValue
    : IntValue
    ;

floatValue
    : FloatValue
    ;

booleanValue
    : BooleanValue
    ;

stringValue
    : StringValue
    ;

enumValue
    : anyName
    ;

// --------------- BOOLEAN---------------

BooleanValue
    : 'true'
    | 'false';

// --------------- NAMES ---------------

anyName
    : NAME
    | K_TYPE
    | K_ON
    | K_FRAGMENT
    | K_QUERY
    | K_MUTATION
    | K_SUBSCRIPTION
    ;

fragmentName
    : NAME
    | K_TYPE
    | K_FRAGMENT
    | K_QUERY
    | K_MUTATION
    | K_SUBSCRIPTION
    ;

K_TYPE : 'type' ;
K_ON : 'on' ;
K_FRAGMENT : 'fragment' ;
K_QUERY : 'query' ;
K_MUTATION : 'mutation' ;
K_SUBSCRIPTION : 'subscription' ;

NAME : [_A-Za-z][_0-9A-Za-z]* ;

// --------------- INTEGER ---------------

IntValue
    : Sign? IntegerPart
    ;

FloatValue
    : Sign? IntegerPart ('.' Digit+)? ExponentPart?
    ;

Sign
    : '-'
    | '+';

IntegerPart
    : '0'
    | NonZeroDigit
    | NonZeroDigit Digit+
    ;

NonZeroDigit
    : '1'.. '9'
    ;

ExponentPart
    : ('e'|'E') Sign? Digit+
    ;

Digit
    : '0'..'9'
    ;

// --------------- STRING ---------------

StringValue
    : '"' (~(["\\\n\r\u2028\u2029])|EscapedChar)* '"'
    ;

fragment EscapedChar
    :   '\\' (["\\/bfnrt] | Unicode)
    ;
fragment Unicode
    : 'u' Hex Hex Hex Hex
    ;

fragment Hex
    : [0-9a-fA-F]
    ;

// --------------- IGNORED ---------------

Ignored
    : (Whitspace|Comma|LineTerminator|Comment) -> channel(HIDDEN)
    ;

fragment Comment
    : '#' ~[\n\r\u2028\u2029]*
    ;

fragment LineTerminator
    : [\n\r\u2028\u2029]
    ;

fragment Whitspace
    : [\t\u000b\f\u0020\u00a0]
    ;

fragment Comma
    : ','
    ;
