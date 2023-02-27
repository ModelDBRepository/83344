 COMMENT
 iterator for traversing all the descendants of the currently accessed section
 
 section subtree_traverse("statement")
 
 executes statement for section and every descendant of section.
 Just before the statement is executed the currently accessed section is set.
 
 ENDCOMMENT
 
 NEURON {
 	SUFFIX nothing
 }
 
 VERBATIM
 static void subtree(Section* sec, Symbol* sym) {
 	Section* child;
 
 	nrn_pushsec(sec);	/* move these three (sec becomes child) */
 	hoc_run_stmt(sym);	/* into the loop to do only the first level */
 	nrn_popsec();
 
 	for (child = sec->child; child; child = child->sibling) {
 		subtree(child, sym);
 	}
 }
 #ifndef NRN_VERSION_GTEQ_8_2_0
 Section* chk_access();
 Symbol* hoc_parse_stmt();
 #endif
 ENDVERBATIM
 
 PROCEDURE subtree_traverse_all() {
   VERBATIM
   {
 	Symlist* symlist = (Symlist*)0;
 	subtree(chk_access(), hoc_parse_stmt(gargstr(1), &symlist));
 	/* if following not executed (ie hoc error in statement),
 	   some memory will leak */
 	hoc_free_list(&symlist);
   }
   ENDVERBATIM
 }
