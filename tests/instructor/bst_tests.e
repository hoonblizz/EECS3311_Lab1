note
	description: "[
		{BST_TESTS} inherits from {SORTED_TREE_ADT_TESTS} and instantiates
		its deferred attributes so that it can be instantiated.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

class
	BST_TESTS

inherit
	SORTED_TREE_ADT_TESTS
		redefine
			setup
		end

create
	make

feature{NONE} -- Test objects

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

feature{NONE} -- Initialization

	setup
			-- Will be executed at the beginning of "run" in a test case.
		do
			create tree.make_empty
			create s_tree.make_empty
		end

end
