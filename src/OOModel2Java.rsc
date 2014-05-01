module OOModel2Java

import OOModel;
import List;

str model2java(oomodel(classes)) = 
	intercalate("\n\n", [class2javaClass(class) | class <- classes]);

str class2javaClass(class(name, literalFields, objFields)) =
	"class <name>
	'{
	'<fields2javaFields(literalFields, objFields)>
	' 	<name>(){
	'	}
	'
	'<fields2constructor(name, literalFields, objFields)>
	'}";
	
str fields2constructor(str className, list[Field] literalFields, list[Field] objFields)=
	"	<className>(<toParameters(literalFields, objFields)>){ 
	'     <for (literalField(_, name, _, _) <- literalFields){>
	'		this.<name> = <name>;	<}>
	'	  <for (objField(_, name, altName, _) <- objFields){>
	'		this.<name> = <altName>; <}>
	'        }";
	
str toParameters(list[Field] litFields, list[Field] objFields) =
	 intercalate(", ", parLst)
	 when parLst
	 		:= ["<cName> <name>" |literalField(tipe(cName), name, _,  _) <- litFields]
			   + ["<cName> <altName>" |objField(tipe(cName), _, altName, _) <- objFields];

str fields2javaFields(list[Field] litFields, list[Field] objFields) =
	"	<for (literalField(tipe, name, _, val) <- litFields){>
	'	<tipe.className> <name> = \"<val>\"; <}>
	'	<for (objField(tipe, name, _, vals) <- objFields){><tipe.className> <name> =
	'		 new <tipe.className>(<toArguments(vals)>);
	' 	<}>";

str toArguments(list[Field] fields) =
	intercalate(", ", parLst)
	when literalFields := [f | f <- fields, f is literalField],
		 objFields := [f | f <- fields, f is objField],
		 parLst := ["\"<val>\"" |literalField(_, _, _,  val) <- literalFields]
				   + ["new <cName>()" |objField(tipe(cName), _, _, _) <- objFields];
