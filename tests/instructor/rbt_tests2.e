note
	description: "Summary description for {INSTRUCTOR_TEST_RBT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RBT_TESTS2
inherit
	ES_TEST
		redefine setup end

create
	make

feature{NONE} -- Test objects

	make
		do
			add_boolean_case (agent t0)
			add_boolean_case (agent jt1)
			add_boolean_case (agent jt2)
			add_boolean_case (agent jt3)
			add_boolean_case (agent jt4)

			add_boolean_case (agent jt5)
			add_boolean_case (agent jt6)
			add_boolean_case (agent jt7)
			add_boolean_case (agent jt8)
		end

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

feature{NONE} -- Initialization

	setup
			-- Will be executed at the beginning of "run" in a test case.
		do
			create tree.make_empty
			tree.extend (8, "eight")
			tree.extend (3, "three")
			tree.extend (1, "one")
			tree.extend (10, "ten")
			tree.extend (14, "fourteen")
			tree.extend (13, "thirteen")
			tree.extend (6, "six")
			tree.extend (4, "four")
			tree.extend (7, "seven")
			---
			create s_tree.make_empty
			s_tree.extend ("eight", 8)
			s_tree.extend ("three", 3)
			s_tree.extend ("one", 1)
			s_tree.extend ("ten", 10)
			s_tree.extend ("fourteen", 14)
			s_tree.extend ("thirteen", 13)
			s_tree.extend ("six", 6)
			s_tree.extend ("four", 4)
			s_tree.extend ("seven", 7)
		end

feature -- tests
	br: STRING = "<br>"

	t0: BOOLEAN
		do
			comment("t0: basic checks and path and path_of queries of  a tree")
			-- string keys
			create s_tree.make_empty
			Result := s_tree.count = 0 and s_tree.root_key = Void
			check Result end
			s_tree.extend (["eight", 8])
			s_tree.extend (["three", 3])
			Result := s_tree["eight"] = 8 and s_tree["three"] = 3 and s_tree.count = 2
			check Result end
			s_tree.remove ("eight")
			Result := s_tree["three"] = 3 and s_tree.root_key ~ "three" and s_tree.count = 1
			check Result end
			--- integer keys
			create tree.make_empty
			Result := tree.count = 0 and tree.root_key = 0
			check Result end
			tree.extend (8, "eight")
			tree.extend (3, "three")
			Result := tree[8] ~ "eight" and tree[3] ~ "three" and tree.count = 2
			check Result end
			tree.extend (1, "one")
			tree.extend (10, "ten")
			tree.extend (14, "forteen")
			tree.extend (13, "thirteen")
			assert_equal ("path problem1", "< right, right, left >", tree.path_for_key (13).out)
			tree.extend (6, "six")
			tree.extend (4, "four")
			tree.extend (7, "seven")
			assert_equal ("path problem2", "< right, left, left >", tree.path_for_key (7).out)
			assert_equal ("path problem3", "root (6), right (10), left (8), left (7)", tree.path_of (7).out)
			Result := tree.path_of (7).out ~ "root (6), right (10), left (8), left (7)"
			check Result end
		end

	jt1: BOOLEAN
		do
			comment("jt1: remove node with two children")
			sub_comment (br + "extend is sensitive to order, out is inorder")
			create tree.make_empty
			tree.extend (8, "eight")
			tree.extend (1, "one")
			tree.extend (3, "three")
			tree.extend (10, "ten")
			tree.extend (13, "thirteen")
			tree.extend (4, "four")
			tree.extend (6, "six")
			tree.extend (14, "forteen")
			tree.extend (7, "seven")
			Result := tree.out ~ "(1,one)(3,three)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)"
			check Result end
			tree.remove (3)
			tree.wipe_out
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
			check Result end
			tree.remove (3)
			Result := tree.out ~ "(1,one)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)"
			check Result end
		end

		jt2: BOOLEAN
			do
				comment("jt2: remove root node that has children")
				create tree.make_empty
				tree.extend (8, "eight")
				tree.extend (3, "three")
				tree.extend (1, "one")
				tree.remove (8)
				Result := tree.out ~ "(1,one)(3,three)"
				check Result end
			end

		jt3: BOOLEAN
			local
				paths: FUN[TREE_PATH, NODE[INTEGER, STRING]]
				domain: SET[TREE_PATH]
				range: SET[NODE[INTEGER, STRING]]
			do
				comment("jt3: test path_of")
				create tree.make_empty
				tree.extend (8, "eight")
				tree.extend (1, "one")
				tree.extend (3, "three")
				tree.extend (10, "ten")
				tree.extend (13, "thirteen")
				tree.extend (4, "four")
				tree.extend (6, "six")
				tree.extend (14, "forteen")
				tree.extend (7, "seven")
				Result := tree.out ~ "(1,one)(3,three)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)"
				check Result end
				paths := tree.tree
				domain := paths.domain
				range := paths.range
				Result :=
					across paths.as_array as l_c all
						l_c.item.first	~ tree.path_of (l_c.item.second.key) and
						l_c.item.second ~ tree.node_of(l_c.item.second.key)
					end
				check Result end
			end

		jt4: BOOLEAN
			local
				path1: SEQ[STRING]
--				l_root: NODE[INTEGER, STRING]
--				l_root2: detachable NODE[INTEGER, STRING]
			do
				comment("jt4: test path")
				create tree.make_empty
				tree.extend (8, "eight")
				tree.extend (1, "one")
				tree.extend (3, "three")
				tree.extend (10, "ten")
				tree.extend (13, "thirteen")
				tree.extend (4, "four")
				tree.extend (6, "six")
				tree.extend (14, "forteen")
				tree.extend (7, "seven")
				Result := tree.out ~ "(1,one)(3,three)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)"
				check Result end
				Result := tree.root_key = 6
				check Result end
				check attached tree.node_of (6) as a_root then
					path1 := tree.path (a_root, 4)
					assert_equal ("path failure", "< left, right >", path1.out)
				end
			end

	jt5: BOOLEAN
--			(1,one)(3,three)(4,four)(6,six)(7,seven)(8,eight)(10,ten)(13,thirteen)(14,forteen)
		local
			test_node: NODE[INTEGER, STRING]
		do
			comment("jt5: test find_largest")
			-- use setup
			test_node := tree.find_node_of (14, tree.root)
			check attached tree.root as l_root then
				Result := tree.find_largest (l_root) ~ test_node
			end
			check Result end

			test_node := tree.find_node_of (4, tree.root)
			check attached test_node as l_node then
				assert_equal ("find largest", "(4,four)", tree.find_largest (l_node).out)
			end
			check Result end
		end

	jt6: BOOLEAN
		do
			comment("jt6: basic check for reference keys")
			-- string keys
			create s_tree.make_empty
			Result := s_tree.count = 0 and s_tree.root_key = Void
			check Result end
			s_tree.extend (["eight", 8])
			s_tree.extend (["three", 3])
			Result := s_tree["eight"] = 8 and s_tree["three"] = 3 and s_tree.count = 2
			check Result end
			s_tree.remove ("eight")
		end


	jt7: BOOLEAN

		do
			comment("jt6: test tree iterator")
			-- setup executes
			Result :=
				across tree as a_key
				all
					1 <= a_key.item and a_key.item <= 14
				end
			check Result end
		end

	jt8: BOOLEAN
		local
			s_tree2: like s_tree
			eight: STRING
		do
			comment("jt8: test tree equality, same sequence and paths")
			-- setup create s_tree
			create s_tree2.make_empty
			eight := "eight"
			s_tree2.extend (eight, 8)
			s_tree2.extend ("three", 3)
			s_tree2.extend ("one", 1)
			s_tree2.extend ("ten", 10)
			s_tree2.extend ("fourteen", 14)
			s_tree2.extend ("thirteen", 13)
			s_tree2.extend ("six", 6)
			s_tree2.extend ("four", 4)
			s_tree2.extend ("seven", 7)
			Result := s_tree ~ s_tree2
		end
end



