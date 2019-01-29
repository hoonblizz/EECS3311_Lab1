note
	description: "[
		{SORTED_TREE_ADT_TESTS} is a deferred implementation of the test cluster. 
		It mimicks the structure of {SORTED_TREE} itself allowing it to
		act like a factory for any implementation of {SORTED_TREE}.
		
		Sorted Trees are deferred at the level of SORTED_TREE_ADT.
		Thus `tree' and `s_tree' queries are deferred, to be instantiated
		by decsendants. However, as in the template design pattern, the tests 
		can be written w.r.t. these queries.
		
		Value and reference keys are checked to ensure that tree equality
		is properly defined.	 

	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SORTED_TREE_ADT_TESTS

inherit
	ES_TEST

feature{NONE}  -- Test trees

	tree: SORTED_TREE_ADT[INTEGER, STRING]
			-- tree with a value type for key K
		deferred
		end

	s_tree: SORTED_TREE_ADT[STRING, INTEGER]
			-- tree with reference type (string) for key K
		deferred
		end


feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t13)
		end

feature{NONE} -- tests
	t0: BOOLEAN
		do
			comment("t0: add to tree")
			tree.extend(5, "a")
			Result := tree.out ~ "(5,a)"
			check Result end
			tree.extend (7, "b")
			Result := tree.out ~ "(5,a)(7,b)"
			check Result end
			tree.extend (3, "c")
			Result := tree.out ~ "(3,c)(5,a)(7,b)"
			check Result end
		end

	t1: BOOLEAN
		do
			comment("t1: remove nodes without children")
			tree.extend (2, "a")
			tree.extend (1, "b")
			tree.extend (4, "c")
			Result := tree.out ~ "(1,b)(2,a)(4,c)"
			check Result end
			tree.remove (1)
			Result := tree.out ~ "(2,a)(4,c)"
			check Result end
			tree.remove (4)
			Result := tree.out ~ "(2,a)"
			check Result end
			tree.remove (2)
			Result := tree.out ~ ""
			check Result end
		end

	t2: BOOLEAN
		do
			comment("t2: remove nodes with left child")
			tree.extend (2, "a")
			tree.extend (1, "b")
			Result := tree.out ~ "(1,b)(2,a)"
			check Result end
			tree.remove (2)
			Result := tree.out ~ "(1,b)"
			check Result end
		end

	t3: BOOLEAN
		do
			comment("t3: remove nodes with right child")
			tree.extend(2, "a")
			tree.extend(4, "b")
			Result := tree.out ~ "(2,a)(4,b)"
			check Result end
			tree.remove (2)
			Result := tree.out ~ "(4,b)"
			check Result end
		end

	t4: BOOLEAN
		do
			comment("t4: remove nodes with two children")
			tree.extend (2, "a")
			tree.extend (1, "b")
			tree.extend (4, "c")
			Result := tree.out ~ "(1,b)(2,a)(4,c)"
			check Result end
			tree.remove (2)
			Result := tree.out ~ "(1,b)(4,c)"
			check Result end
		end

	t5: BOOLEAN
		do
			comment("t5: remove nodes with two children, string version")
			s_tree.extend ("aa", 1)
			s_tree.extend ("aaa", 2)
			s_tree.extend ("a", 3)
			Result := s_tree.out ~ "(a,3)(aa,1)(aaa,2)"
			check Result end
			s_tree.remove ("aa")
			Result := s_tree.out ~ "(a,3)(aaa,2)"
			check Result end
		end

	t6: BOOLEAN
		do
			comment("t6: many insertions/removals(invariant testing)")
			tree.extend (0, "a")
			tree.extend (1, "b")
			tree.extend (2, "c")
			tree.extend (3, "d")
			tree.extend (4, "e")
			tree.extend (5, "f")
			tree.extend (6, "g")
			tree.extend (7, "h")
			tree.extend (8, "i")
			tree.extend (9, "j")
			tree.remove (5)
			tree.remove (1)
			tree.remove (6)
			tree.remove (9)
			tree.remove (8)
			tree.remove (2)
			tree.remove (3)
			tree.extend (3, "k")
			tree.extend (6, "l")
			tree.extend (5, "m")
			tree.remove (5)
			tree.remove (3)
			tree.extend (2, "n")
			tree.extend (10, "o")
			tree.remove (4)
			tree.remove (2)
			tree.remove (6)
			tree.remove (10)
			tree.remove (0)
			tree.remove (7)
			result := tree.out ~ ""
			check result end
		end


	t7: BOOLEAN
		do
			comment("t7: find min")
			tree.extend (0, "a")
			tree.extend (5, "b")
			Result := tree.min.key ~ 0 and tree.min.val ~ "a"
			check Result end
			tree.extend (-7, "c")
			Result := tree.min.key ~ -7 and tree.min.val ~ "c"
			check Result end
			s_tree.extend ("a", 7)
			s_tree.extend ("c", 4)
			Result := s_tree.min.key ~ "a" and s_tree.min.val ~ 7
			check Result end
			s_tree.extend ("A", 1)
			Result := s_tree.min.key ~ "A" and s_tree.min.val ~ 1
			check Result end
		end

	t8: BOOLEAN
		do
			comment("t8: find max")
			tree.extend (0, "a")
			tree.extend (5, "b")
			Result := tree.max.key ~ 5 and tree.max.val ~ "b"
			check Result end
			tree.extend (7, "c")
			Result := tree.max.key ~ 7 and tree.max.val ~ "c"
			check Result end
			s_tree.extend ("a", 7)
			s_tree.extend ("c", 4)
			Result := s_tree.max.key ~ "c" and s_tree.max.val ~ 4
			check Result end
			s_tree.extend ("d", 1)
			Result := s_tree.max.key ~ "d" and s_tree.max.val ~ 1
			check Result end
		end

	t9: BOOLEAN
		do
			comment("t9: test wipe_out")
			tree.extend (4, "a")
			tree.extend (6, "b")
			tree.wipe_out
			Result := tree.is_empty
			check Result end
		end

	t10: BOOLEAN
		local
			i_list: ARRAY[TUPLE[key: INTEGER; val: STRING]]
			s_list: ARRAY[TUPLe[key: STRING; val: INTEGER]]
		do
			comment("t10: test as_array")
			tree.extend (2, "a")
			tree.extend (1, "b")
			tree.extend (4, "c")
			i_list := <<[1, "b"], [2, "a"], [4, "c"]>>
			s_list := <<["a", 2], ["b", 1], ["c", 4]>>
			across i_list as l_c loop
				s_tree.extend (l_c.item.val, l_c.item.key)
			end
			Result :=
				across i_list as l_c all
					tree.as_array[l_c.cursor_index].key ~ l_c.item.key and
					tree.as_array[l_c.cursor_index].val ~ l_c.item.val and
					s_tree.as_array[l_c.cursor_index].key ~ s_list[l_c.cursor_index].key and
					s_tree.as_array[l_c.cursor_index].val ~ s_list[l_c.cursor_index].val
				end
			check Result end
		end

	t11: BOOLEAN
		local
			i_node: NODE[INTEGER, STRING]
			s_node: NODE[STRING, INTEGER]
		do
			comment("t11: element test")
			create i_node.make (2, "a")
			create s_node.make ("a", 2)
			tree.extend (2, "a")
			s_tree.extend ("a", 2)
			Result := tree.node_of (2) ~ i_node
			check Result end
			Result := tree.node_of (2) /= i_node
			check Result end
			Result := s_tree.node_of ("a") ~ s_node
			check Result end
			Result := s_tree.node_of ("a") /= s_node
			check Result end
		end

	t12: BOOLEAN
		do
			comment("t12: count")
			Result := tree.count = 0
			check Result end
			tree.extend (4, "a")
			tree.extend (7, "b")
			Result := tree.count = 2
			check Result end
			tree.remove (4)
			Result := tree.count = 1
			check Result end
			tree.extend (3, "c")
			tree.extend (11, "d")
			tree.extend (-4, "e")
			Result := tree.count = 4
			check Result end
			tree.wipe_out
			Result := tree.is_empty
			check Result end
		end

	t13: BOOLEAN
		do
			comment("t13: test path(only for BST)")
			tree.extend (8, "eight")
			tree.extend (3, "three")
			tree.extend (1, "one")
			tree.extend (10, "ten")
			tree.extend (14, "forteen")
			tree.extend (13, "thirteen")
			tree.extend (6, "six")
			tree.extend (4, "four")
			tree.extend (7, "seven")
			Result := tree.out ~ "(1,one)(3,three)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)"
			Result :=
				across tree.tree.as_array as l_c all
					l_c.item.first	~ tree.path_of (l_c.item.second.key) and
					l_c.item.second ~ tree.node_of(l_c.item.second.key)
				end
			check Result end
			check Result end
			Result := tree.path_of (7).out ~ "root (8), left (3), right (6), right (7)"
			check Result end
			Result := tree.path_of (4).out ~ "root (8), left (3), right (6), left (4)"
			check Result end
			Result := tree.path_of (13).out ~ "root (8), right (10), right (14), left (13)"
			check Result end
			Result := tree.path_of (3).out ~ "root (8), left (3)"
			check Result end
			Result := tree.path_of (8).out ~ "root (8)"
			check Result end
			Result := tree.path_of (6).out ~ "root (8), left (3), right (6)"
			check Result end
		end

end
