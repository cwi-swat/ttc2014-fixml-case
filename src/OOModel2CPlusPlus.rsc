module OOModel2CPlusPlus

import OOModel;
import List;
import String;

str model2cpp(oomodel(classes)) = intercalate("\n\n", [class2cppClass(class) | class <- classes]);

str class2cppClass(class(str name, list[Field] fields)) =
	"class <name>{
	'<fields2cppFields(literalFields, nonLiteralFields)>
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
	'		this.<f.name> = _<f.tipe.className>; <}>
	'       }"
	when parLst := ["<toLowerCase(f.tipe.className)> <f.name>" |f <- literalFields]
				   + ["<f.tipe.className> _<f.tipe.className>" |f <- nonLiteralFields],
		 parameters := intercalate(", ", parLst);
		 
str fields2cppFields(list[Field] literalFields, list[Field] nonLiteralFields) =
	"	<for (f <- literalFields){>
	'	<toLowerCase(f.tipe.className)> <f.name> = \"<f.val>\"; <}>
	'	<for (f <- nonLiteralFields){><f.tipe.className> <f.name> = new <f.tipe.className>();
	' 	<}>";

