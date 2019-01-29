note
	description: "[
		Students: Get these BST tests working first
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BST_EXTEND_TEST
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	tree: SORTED_BST[INTEGER,STRING]
			-- instantiation of tree
		attribute
			create Result.make_empty
		end

	s_tree: SORTED_BST[STRING, INTEGER]
			-- instantiation of s_tree
		attribute
			create Result.make_empty
		end

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)

		end

feature -- etsts

	t1: BOOLEAN
			-- is executed at the beginning of each test
		do
			comment("t1: Get extend working for value and reference keys")
			sub_comment("If you get this working, ESpec will properly display remaining tests")
			create tree.make_empty
			tree.extend (8, "eight")
			tree.extend (3, "three")
			Result := tree.count = 2 and tree[8] ~ "eight"
			check Result end

			---
			create s_tree.make_empty
			s_tree.extend ("eight", 8)
			s_tree.extend ("three", 3)
			Result := s_tree.count = 2 and s_tree["eight"] = 8
		end

end
