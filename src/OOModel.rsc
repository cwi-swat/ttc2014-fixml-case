module OOModel

data OOModel = oomodel(list[Class] classes);

data Class = class(str name, list[Field] literalFields, list[Field] objFields);

data Type = tipe(str className);

data Field = objField(Type tipe, str name, str altName, list[Field] vals) 
           | literalField(Type tipe, str name, str altName, str val);

data Ref = ref(str container, str field) | ref(str name);

data Statement = assignment(Ref lhs, Ref rhs);
