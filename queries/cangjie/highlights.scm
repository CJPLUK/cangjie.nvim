; Adapted from CJPLUK/zed-cangjie, languages/cangjie/highlights.scm
; Revision: 36e5f3c97e2ecf3cabfffc5baca974ce3f00b436 (MIT; see LICENSE).
; Grammar: tree-sitter-cangjie b145ccdc9b64082bf9a558ab54e7b536d7a57d73.

; Clear the string highlight inside interpolations before highlighting expressions.
[
  (inlineExpression)
  (inMultiLineStringExpression)
] @none

; Variables and members
(identifier) @variable
(varBindingPattern) @variable
(thisSuperExpression) @variable.builtin

(parameter
  paraName: (_) @variable.parameter)
(namedParameter
  paraName: (_) @variable.parameter)
(lambdaParameter
  (varBindingPattern) @variable.parameter)
(callSuffix
  (varBindingPattern) @variable.parameter)

(fieldAccess
  (identifier) @variable.member)
(scoped_identifier
  name: (identifier) @variable.member)
(propertyName) @variable.member
(classBody
  (variableDeclaration
    (variableName
      (varBindingPattern) @variable.member)))
(structBody
  (variableDeclaration
    (variableName
      (varBindingPattern) @variable.member)))
(primaryInitParamList
  (unnamedMemberParam
    (parameter
      paraName: (identifier) @variable.member)))

((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]*$"))
((varBindingPattern) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]*$"))
(variableDeclaration
  "const"
  (variableName
    (varBindingPattern) @constant))
(enumBody
  enumConstant: (identifier) @constant)

; Packages
(packageDeclaration
  packageName: (_) @module)
(packageFull
  packageName: (_) @module
  (asterisk)? @punctuation.special)

; Types
[
  (className)
  (structName)
  (enumName)
  (interfaceName)
  (typeAliasName)
  (extendType)
  (superOrInterface)
] @type

(userType
  (identifier) @type)
(userType
  (scoped_identifier
    name: (identifier) @type))
(typeParameters
  (identifier) @type)
(genericConstraint
  (identifier) @type)

[
  "Int8"
  "Int16"
  "Int32"
  "Int64"
  "IntNative"
  "UInt8"
  "UInt16"
  "UInt32"
  "UInt64"
  "UIntNative"
  "Float16"
  "Float32"
  "Float64"
  "String"
  "Array"
  "Range"
  "Rune"
  "Bool"
  "Unit"
  "Nothing"
  (Int8)
  (Int16)
  (Int32)
  (Int64)
  (IntNative)
  (UInt8)
  (UInt16)
  (UInt32)
  (UInt64)
  (UIntNative)
  (Float16)
  (Float32)
  (Float64)
  (String)
  (Rune)
  (Bool)
  (Unit)
  (Nothing)
  (Thistype)
] @type.builtin

(atomicVariable
  . (identifier) @type.builtin
  (#eq? @type.builtin "Option"))

; Functions and constructors
(funcName) @function
(mainDefinition
  "main" @function)
"init" @constructor
(primaryInit
  (className) @constructor)

; Plain and generic function calls
(postfixExpression
  (atomicVariable
    . (identifier) @function.call
    .)
  . (callSuffix))
(postfixExpression
  (atomicVariable
    . (identifier) @function.call
    . (typeArguments)
    .)
  . (callSuffix))

; a.b(...), a[0].b(...), chained calls and this/super calls
(postfixExpression
  (atomicVariable
    (scoped_identifier
      name: (identifier) @function.method.call)
    .)
  . (callSuffix))
(postfixExpression
  (atomicVariable
    (fieldAccess
      (identifier) @function.method.call)
    .)
  . (callSuffix))
((fieldAccess
  (identifier) @function.method.call)
  . (callSuffix))

(propertyDefinition
  getter: "get" @keyword.function)
(propertyDefinition
  setter: "set" @keyword.function)
(macroName) @function.macro
(annotationName) @attribute
"@" @punctuation.special

; Keywords
(modifiers) @keyword.modifier
[
  "let"
  "var"
  "const"
  "where"
  "foreign"
  "unsafe"
  "inout"
  "prop"
  "quote"
] @keyword

["package" "import"] @keyword.import
["class" "struct" "interface" "enum" "extend" "type"] @keyword.type
["func" "macro"] @keyword.function
["if" "else" "match" "case"] @keyword.conditional
(lineContinuedElse) @keyword.conditional
["for" "in" "while" "do" "break" "continue"] @keyword.repeat
["try" "catch" "finally" "throw"] @keyword.exception
"return" @keyword.return
["spawn" "synchronized"] @keyword.coroutine

; Literals
(stringLiteral) @string
(integerLiteral) @number
(floatLiteral) @number.float
(booleanLiteral) @boolean
; The pinned grammar also accepts boolean keywords as identifiers.
((identifier) @boolean
  (#any-of? @boolean "true" "false"))
[(runeLiteral) (byteLiteral)] @character

(inlineExpression
  "${" @punctuation.special
  "}" @punctuation.special)
(inMultiLineStringExpression
  "${" @punctuation.special
  "}" @punctuation.special)

; Punctuation and operators
["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["." "," ":" ";"] @punctuation.delimiter

[
  "="
  "<-"
  "->"
  "=>"
  "<:"
  "?"
  ".."
  "..="
  "++"
  "--"
  "&"
  "|"
  "*"
  "~"
] @operator

; The misspelling is part of the upstream grammar's node name.
(binaryExpreesion
  operator: _ @operator)
(assignmentExpression
  operator: _ @operator)
(unaryExpression
  operator: _ @operator)
(operator) @operator

(typeArguments
  "<" @punctuation.bracket
  ">" @punctuation.bracket)
(typeParameters
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

; Comments
[(blockComment) (lineComment)] @comment @spell
