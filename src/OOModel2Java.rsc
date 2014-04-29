module OOModel2Java

import OOModel;
import List;
import Common;

str model2java(oomodel(classes)) = intercalate("\n\n", [class2javaClass(class) | class <- classes]);

str class2javaClass(class(str name, list[Field] fields)) =
	"class <name>{
	'<fields2javaFields(literalFields, nonLiteralFields)>
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
	when parLst := ["<f.tipe.className> <f.name>" |f <- literalFields]
				   + ["<f.tipe.className> <toParameterName(f.tipe.className)>" |f <- nonLiteralFields],
		 parameters := intercalate(", ", parLst);
		 
str fields2javaFields(list[Field] literalFields, list[Field] nonLiteralFields) =
	"	<for (f <- literalFields){>
	'	<f.tipe.className> <f.name> = \"<f.val>\"; <}>
	'	<for (f <- nonLiteralFields){><f.tipe.className> <f.name> = new <f.tipe.className>();
	' 	<}>";

