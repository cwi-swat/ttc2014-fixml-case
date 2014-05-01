module OOModel2Java

import OOModel;
import List;

str model2java(oomodel(classes)) = intercalate("\n\n", [class2javaClass(class) | class <- classes]);

str class2javaClass(class(name, literalFields, objFields)) =
	"class <name>{
	'<fields2javaFields(literalFields, objFields)>
	' 	<name>(){
	'	}
	'
	'<fields2constructor(name, literalFields, objFields)>
	'}";
	
str fields2constructor(str className, list[Field] literalFields, list[Field] objFields) =
	"	<className>(<toParameters(literalFields, objFields)>){ <for (literalField(_, name, _, _) <- literalFields){>
	'		this.<name> = <name>;	<}>
	'	<for (objField(_, name, altName, _) <- objFields){>
	'		this.<name> = <altName>; <}>
	'       }";
	
str toParameters(list[Field] literalFields, list[Field] objFields) = intercalate(", ", parLst)
	when parLst := ["<tipe.className> <name>" |literalField(tipe, name, _,  _) <- literalFields]
				   + ["<tipe.className> <altName>" |objField(tipe, _, altName, _) <- objFields];

str fields2javaFields(list[Field] literalFields, list[Field] objFields) =
	"	<for (literalField(tipe, name, _, val) <- literalFields){>
	'	<tipe.className> <name> = \"<val>\"; <}>
	'	<for (objField(tipe, name, _, vals) <- objFields){><tipe.className> <name> = new <tipe.className>(<toArguments(vals)>);
	' 	<}>";

str toArguments(list[Field] literalFields) = intercalate(", ", parLst)
	when parLst := ["\"<val>\"" |literalField(_, _, _,  val) <- literalFields];
