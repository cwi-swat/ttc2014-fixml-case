module OOModel2CSharp

import OOModel;
import List;

str model2csharp(oomodel(classes)) = intercalate("\n\n", [class2csharpClass(class) | class <- classes]);

str class2csharpClass(class(name, litFields, objFields)) =
	"class <name>{
	'<fields2csharpFields(litFields, objFields)>
	' 	<name>(){
	'	}
	'
	'<fields2constructor(name, litFields, objFields)>
	'}";
	
str fields2constructor(str className, list[Field] litFields, list[Field] objFields) =
	"	<className>(<toParameters(litFields, objFields)>){ <for (literalField(_, name, _, _) <- litFields){>
	'		this.<name> = <name>;	<}>
	'	<for (objField(_, name, altName, _) <- objFields){>
	'		this.<name> = <altName>; <}>
	'       }";
	
str toParameters(list[Field] litFields, list[Field] objFields) =
	 intercalate(", ", parLst)
	 when parLst
	 		:= ["<nativeTypeInCSharp(cName)> <name>" |literalField(tipe(cName), name, _,  _) <- litFields]
			   + ["<cName> <altName>" |objField(tipe(cName), _, altName, _) <- objFields];

		 
str fields2csharpFields(list[Field] litFields, list[Field] objFields) =
	"	<for (literalField(tipe(cName), name, _, val) <- litFields){>
	'	<nativeTypeInCSharp(cName)> <name> = \"<val>\"; <}>
	'	<for (objField(tipe(cName), name, altName, _) <- objFields){><cName> <name> = new <cName>();
	' 	<}>";

str nativeTypeInCSharp("String") = "string";

