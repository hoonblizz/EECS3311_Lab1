note
	description: "[
		{RBT_TESTS} inherits from {SORTED_TREE_ADT_TESTS} and instantiates
		its deferred attributes so that it can be instantiated.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

class
	RBT_TESTS

inherit
	SORTED_TREE_ADT_TESTS
		redefine
			make, setup, t13
		end

create
	make

feature{NONE} -- Initialization

	make
		do
			Precursor	-- calls {SORTED_TREE}.make
			add_boolean_case (agent t20)
			add_boolean_case (agent t21)
			add_boolean_case (agent t22)
		end

	setup
			-- Will be executed at the beginning of "run" in a test case.
		do
			create tree.make_empty
			create s_tree.make_empty
		end

feature{NONE} -- Test objects

	tree: SORTED_RBT[INTEGER,STRING]
			-- instantiation of tree
		attribute
			create Result.make_empty
		end

	s_tree: SORTED_RBT[STRING, INTEGER]
			-- instantiation of s_tree
		attribute
			create Result.make_empty
		end


feature {NONE} -- tests

	t13: BOOLEAN
		do
			comment("t13: test path(only for RBT)")
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
			Result := tree.path_of (7).out ~ "root (6), right (10), left (8), left (7)"
			check Result end
			Result := tree.path_of (4).out ~ "root (6), left (3), right (4)"
			check Result end
			Result := tree.path_of (13).out ~ "root (6), right (10), right (14), left (13)"
			check Result end
			Result := tree.path_of (3).out ~ "root (6), left (3)"
			check Result end
			Result := tree.path_of (8).out ~ "root (6), right (10), left (8)"
			check Result end
			Result := tree.path_of (6).out ~ "root (6)"
			check Result end
		end

	t20: BOOLEAN
		do
			comment("t20: sibling test")
			tree.extend (2, "a")
			tree.extend (1, "b")
			Result := attached tree.node_of (1) as l and then not attached l.sibling
			check Result end
			tree.extend (3, "b")
			Result := attached tree.node_of (2) as l and then not attached l.sibling
			check Result end
			Result := attached tree.node_of (1) as l and then l.sibling ~ tree.node_of (3)
			check Result end
			Result := attached tree.node_of (3) as l and then l.sibling ~ tree.node_of (1)
			check Result end
		end

	t21: BOOLEAN
		do
			comment("t21: outer child test")
			tree.extend (4, "a")
			tree.extend (2, "b")
			tree.extend (6, "c")
			tree.extend (1, "d")
			tree.extend (3, "e")
			tree.extend (5, "f")
			tree.extend (7, "g")
			Result := attached tree.node_of (4) as l and then not attached l.outer_child
			check Result end
			Result := attached tree.node_of (2) as l and then l.outer_child = l.left
			check Result end
			Result := attached tree.node_of (6) as l and then l.outer_child = l.right
			check Result end
		end

	t22: BOOLEAN
		do
			comment("t22: inner child test")
			tree.extend (4, "a")
			tree.extend (2, "b")
			tree.extend (6, "c")
			tree.extend (1, "d")
			tree.extend (3, "e")
			tree.extend (5, "f")
			tree.extend (7, "g")
			Result := attached tree.node_of (4) as l and then not attached l.inner_child
			check Result end
			Result := attached tree.node_of (2) as l and then l.inner_child = l.right
			check Result end
			Result := attached tree.node_of (6) as l and then l.inner_child = l.left
			check Result end
		end

end
