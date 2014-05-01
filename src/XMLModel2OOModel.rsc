module XMLModel2OOModel

import lang::xml::DOM;
import OOModel;
import List;
import Set;
import Map;

list[value] EMPTY = [];

OOModel xml2oo(document(root)){
	Field toInitializer (of:objField(tipe, name, altName, [])) =
		of;

	default Field toInitializer (of:objField(tipe(className), name, altName, vals)) =
		of[vals = orderedVals]
		when valsMap := (n : f | f:literalField(_, n, _, _) <- vals),
			 orderedVals := [valsMap[lf.name] ? lf[val = ""]| lf <- litFieldsMap[className]];
	
	map[str name, list[Node] elements] elements = ();
	
	visit(root){
		case e:element(_, name, _): elements[name]? EMPTY += [e];
	}
	set[str] names = domain(elements);
	list[Class] classes = [element2class(e) | name <- names
									        , e := union(elements[name])];
	map[str, list[Field]] litFieldsMap = 
		(name : litFields | class(name, litFields, _) <- classes);
	list[Class] newClasses =
		[cl[objFields = [toInitializer(of) | of <- cl.objFields]] | cl<- classes];
	
	return oomodel(newClasses);
}

Node union(list[Node] elements) =
	element(x, name, allElements + toList(range(attsMap)))
	when element(x, name, _) := elements[0],	
		 allChildren := ([] | it + cs | element(_, _, cs) <- elements),
		 allElements := [c | c <- allChildren, c is element],
		 attsMap := (() | it + as | element(_, _, cs) <- reverse(elements)
		 						  , as := (n:a | a:attribute(_, n, _) <- cs) );

map[str name, list[Node] elements] groupElementsByName(list[Node] nodes) {
	map[str name, list[Node] elements] result = ();
	for (e: element(_, n, _) <- nodes){
		result[n] ? EMPTY += [e];
	}
	return result;
}

Class element2class(element(_, name, children)) =
	class(name, attributes2fields(attributes), elements2fields(elements))
	when attributes := reverse([a | a <- children, a is attribute]),
		 elements := groupElementsByName(children);
		 				 		 
list[Field] attributes2fields(list[Node] attributes) =
	[literalField(tipe("String"), name, toAltName(name), val)| attribute(_,name,val) <- attributes];
	  
list[Field] elements2fields(map[str, list[Node]] elements) =
	[objField(tipe(name), toObjName(name), toAltName(name), [])
		| name <- elements
		, size(elements[name]) == 1]
	+ [objField(tipe(name), toObjName(name, n), toAltName(name, n), attributes2fields([a | a <- es, a is attribute]))
	  	| name <- elements
	  	, theSize := size(elements[name])
	  	, theSize > 1
	  	, indexes := [1.. theSize+1]
	  	, <n, element(_, _, es)> <- zip(indexes, elements[name])];

str toAltName(str s) = "<s>_";
str toAltName(str s, int i) = "<s>_<i>";

str toObjName(str s) = "<s>_object";
str toObjName(str s, int i) = "<s>_object_<i>";


		

