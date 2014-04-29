module OOModel2CSharp

import OOModel;
import List;
import Common;

str model2csharp(oomodel(classes)) = intercalate("\n\n", [class2csharpClass(class) | class <- classes]);

str class2csharpClass(class(str name, list[Field] fields)) =
	"class <name>{
	'<fields2csharpFields(literalFields, nonLiteralFields)>
	' 	<name>(){
	'	}
	'
	'<fields2constructor(name, literalFields, nonLiteralFields)>
	'}"
	when literalFields := [f | f <- fields, isLiteral(f.tipe)],
		 nonLiteralFields := fields - literalFields;
	
str fields2constructor(str className, list[Field] literalFields, list[Field] nonLiteralFields) =
	"	<className>(<parameters>){ <for (f <- literalFields){>
	'		this.<f.name> = <f.name>;	<}>
	'	<for (f <- nonLiteralFields){>
	'		this.<f.name> = <toParameterName(f.tipe.className)>; <}>
	'       }"
	when parLst := ["<nativetypeInCSharp(f.tipe)> <f.name>" |f <- literalFields]
				   + ["<f.tipe.className> <toParameterName(f.tipe.className)>" |f <- nonLiteralFields],
		 parameters := intercalate(", ", parLst);
		 
str fields2csharpFields(list[Field] literalFields, list[Field] nonLiteralFields) =
	"	<for (f <- literalFields){>
	'	<nativetypeInCSharp(f.tipe)> <f.name> = \"<f.val>\"; <}>
	'	<for (f <- nonLiteralFields){><f.tipe.className> <f.name> = new <f.tipe.className>();
	' 	<}>";

str nativetypeInCSharp(tipe("String")) = "string";

