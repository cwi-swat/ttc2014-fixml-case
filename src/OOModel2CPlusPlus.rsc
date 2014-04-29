module OOModel2CPlusPlus

import OOModel;
import List;
import String;
import Common;

str model2cpp(oomodel(classes)) = intercalate("\n\n", [class2cppClass(class) | class <- classes]);

str class2cppClass(class(str name, list[Field] fields)) =
	"class <name>
	'{
	'<fields2cppFields(literalFields, nonLiteralFields)>
	'<fields2constructor(name, literalFields, nonLiteralFields)>
	'}"
	when literalFields := [f | f <- fields, isLiteral(f.tipe)],
		 nonLiteralFields := fields - literalFields;
	
str fields2constructor(str className, list[Field] literalFields, list[Field] nonLiteralFields) =
	" public:
	'   <className>(){ <for (f <- literalFields){>
	'		<f.name> = \"<f.val>\";	<}>
	'       }
	'	<className>(<parameters>){ <for (f <- literalFields){>
	'		<f.name> = <toParameterName(f.name)>;	<}>
	'	<for (f <- nonLiteralFields){>
	'		<f.name> = <toParameterName(f.tipe.className)>; <}>
	'       }"
	when parLst := ["<toLowerCase(f.tipe.className)> <toParameterName(f.name)>" |f <- literalFields]
				   + ["<f.tipe.className>* <toParameterName(f.tipe.className)>" |f <- nonLiteralFields],
		 parameters := intercalate(", ", parLst);
		 
str fields2cppFields(list[Field] literalFields, list[Field] nonLiteralFields) =
	" private:	
		<for (f <- literalFields){>
	'	<toLowerCase(f.tipe.className)> <f.name>; <}>
	'	<for (f <- nonLiteralFields){><f.tipe.className>* <f.name>;
	' 	<}>";

