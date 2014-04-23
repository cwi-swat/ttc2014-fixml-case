module OOModel

data OOModel = oomodel(list[Class] classes);

data Class = class(str name, list[Field] fields);

data Type = tipe(str className);

data Field = field(Type tipe, str name) | field(Type tipe, str name, str val);

data Ref = ref(str container, str field) | ref(str name);

data Statement = assignment(Ref lhs, Ref rhs);

public Type stringType = tipe("String");

public bool isLiteral(tipe(x)){
	switch(x){
		case "String": return true;
		default: return false;
	};
}
