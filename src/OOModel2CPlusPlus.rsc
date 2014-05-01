module OOModel2CPlusPlus

import OOModel;
import List;
import String; 
import  analysis::graphs::Graph;

list[Class] orderClasses(list[Class] classes) =
	[classesMap[cName] | cName <- reverse(order(depGraph))]
	when classesMap := (className:c | c:class(className, _, _) <- classes),
		 depGraph := {<className, field.tipe.className> | class(className, _, objFields) <- classes,
													 	  field <- objFields};

str model2cpp(oomodel(classes)) = 
	intercalate("\n\n", [class2cppClass(class) | class <- orderClasses(classes)]);

str class2cppClass(class(str name, list[Field] litFields, list[Field] objFields)) =
	"class <name>
	'{
	'<fields2cppFields(litFields, objFields)>
	'<fields2constructor(name, litFields, objFields)>
	'}";
	
str fields2constructor(str className, list[Field] litFields, list[Field] objFields) =
	" public:
	'   <className>(){ <for (literalField(_, name, altName, val)  <- litFields){>
	'		<name> = \"<val>\";	<}>
	'       }
	'	<className>(<toParameters(litFields, objFields)>){
	'	 <for (literalField(_, name, altName, _)  <- litFields){>
	'		<name> = <altName>;	<}>
	'	<for (objField(tipe(cName), name, altName, _) <- objFields){>
	'		<name> = <altName>; <}>
	'       }";

str toParameters(list[Field] litFields, list[Field] objFields) =
	intercalate(", ", parLst)
	when parLst := ["<toLowerCase(cName)> <altName>" | literalField(tipe(cName), name, altName, _)  <- litFields]
				   + ["<cName>* <altName>" |objField(tipe(cName), name, altName, _) <- objFields];
				   	 
str fields2cppFields(list[Field] literalFields, list[Field] objFields) =
	" private:	
		<for (literalField(tipe(cName), name, _, _)<- literalFields){>
	'	<toLowerCase(cName)> <name>; <}>
	'	<for (objField(tipe(cName), name, altName, _) <- objFields){><cName>* <name>;
	' 	<}>";

