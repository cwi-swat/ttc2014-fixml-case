module XMLModel2OOModel

import lang::xml::DOM;
import OOModel;

OOModel xml2oo(document(root)){
	classes = [];
	visit(root){
		case e:element(_, _, _): classes += element2class(e);
	}
	return oomodel(classes);
}

Class element2class(element(_, name, children)) =
	class(name, nodes2fields(attributes, elements))
	when attributes := [c | c <- children, c is attribute],
		 elements := [c| c <- children, c is element];
		 
list[Field] nodes2fields(list[Node] attributes, list[Node] elements) =
	[field(stringType, name, val)| attribute(_,name,val) <- attributes]
	+ [field(tipe(name), "<name>_object")| element(_,name,_) <- elements];




		

