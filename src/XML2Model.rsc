module XML2Model

import lang::xml::DOM;
import IO;

Node parseXMLDOM(loc src) = parseXMLDOMTrim(readFile(src));