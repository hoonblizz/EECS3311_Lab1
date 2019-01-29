note
	description: "[
		Grading tests start at t100
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST_NODE

inherit

	ES_TEST
		redefine
			setup
		end

create
	make

feature {NONE}

	make
		do
			setup -- also called before every test
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6) -- right inner_child case
			add_boolean_case (agent t7) -- outer child basic
		end

feature -- setup

	LL: STRING = "LL" -- grand child
	LR: STRING = "LR"
	RL: STRING = "RL"
	RR: STRING = "RR" -- left child
	root, left, right: BASIC_NODE [STRING, INTEGER]
	nLL, nLR, nRL, nRR: BASIC_NODE [STRING, INTEGER]

	setup
			-- called before each test
		local
			l_result: BOOLEAN
		do
			create root.make ([zak, 4])
			create left.make ([bob, 2])
			create right.make ([alexa, 6])
			root.set_left (left)
			root.right := right

				-- add grand children nodes
			create nLL.make ([LL, 1])
			create nLR.make ([LR, 3])
			create nRL.make ([RL, 5])
			create nRR.make ([RR, 7])
			left.left := nLL
			left.right := nLR
			right.left := nRL
			right.right := nRR
--			check attached root.left as l_left and attached root.right as l_right then
--				check attached l_left.left as l_ll and attached l_left.right as l_lr and attached l_right.left as l_rl and attached l_right.right as l_rr then
--					l_result := l_left.out ~ "(Bob,2)" and l_right.out ~ "(Alexa,6)" and l_ll.out ~ "(LL,1)" and l_lr.out ~ "(LR,3)" and l_rl.out ~ "(RL,5)" and l_rr.out ~ "(RR,7)"
--				end
--			end
--			check
--				l_result
--			end
		end

feature -- tests

	br: STRING = "<br>"
	zak: STRING = "Zak"
	phone: INTEGER_64 = 416_740_0000 -- same as 4167400000

	t0: BOOLEAN
		local
			n: BASIC_NODE [STRING, INTEGER_64]
		do
			comment ("t0: create and check root node")
			create n.make ([zak, phone])
			Result := n.out ~ "(Zak,4167400000)"
			check
				Result
			end
		end

	t1: BOOLEAN
		local
			n1, n2: BASIC_NODE [STRING, INTEGER_64]
		do
			comment ("t1: check that is_equal work")
			create n1.make ([zak, phone])
			create n2.make (["Zak", phone])
			Result := n1.is_equal(n2)
		end

		-- children

	alexa: STRING = "Alexa" -- right child
	phoneR: INTEGER_64 = 647_740_0001
	bob: STRING = "Bob" -- left child
	phoneL: INTEGER_64 = 613_740_0002

	t2: BOOLEAN
		local
			l_root, l_left, l_right: BASIC_NODE [STRING, INTEGER_64]
		do
			comment ("t2: add Left and Right nodes to root")
			sub_comment (br + "but not in sorted order")

			create l_root.make ([zak, phone])
			create l_left.make ([bob, phoneL])
			create l_right.make ([alexa, phoneR])
			l_root.set_left (l_left)
			l_root.right := l_right -- can also use a setter

			--sub_comment()

			check attached l_root.left as L and attached l_root.right as R then
				Result := L.out ~ "(Bob,6137400002)" and R.out ~ "(Alexa,6477400001)"
			end
			check
				Result
			end
		end

	t3: BOOLEAN
		do
			comment ("t3: test inorder traversal command")
			sub_comment ("but it's not in sorted key K order")
			sub_comment ("(LL,1)(Bob,2)(LR,3)(Zak,4)(RL,5)(Alexa,6)(RR,7)")

			root.traverse_inorder

			Result := root.key ~ "Zak" and root.value = 4
			assert_equal ("inorder",
				"(LL,1)(Bob,2)(LR,3)(Zak,4)(RL,5)(Alexa,6)(RR,7)",
				root.inorder_result)
		end

	t4: BOOLEAN
		local
			n: BASIC_NODE [STRING, INTEGER_64]
		do
			comment ("t4: test inorder traversal query")
			sub_comment (br + "more tests needed")
			create n.make ([zak, phone])
			Result := n.out ~ "(Zak,4167400000)"
			check	Result	end
			assert_equal ("inorder failure", "(Zak,4167400000)", n.inorder)
		end

	t5: BOOLEAN
		do
			comment("t5: check sibling query")
			-- setup has run, thus
			Result := root.key ~ "Zak" and root.value = 4
			check Result end
			check attached root.left as L and attached root.right as R then
				Result := L.sibling ~ right and R.sibling ~ left
				assert_equal("left", "(Bob,2)", L.out)
				assert_equal("right", "(Alexa,6)", R.out)
			end
			check Result end
		end

	t6: BOOLEAN
		do
			comment("t6: check inner_child query")
			sub_comment(br + "RL is inner child of Alexa")
			-- setup has run, thus
			Result := root.key ~ "Zak" and root.value = 4
			check Result end
			-- inner_child of root is Void, no parent
			Result := root.inner_child = Void
			check Result end
			check attached root.right as right_child then
			check attached right_child.left as a_left then
				Result := right_child.inner_child ~ a_left
				assert_equal("right_child", "(Alexa,6)", right_child.out)
				assert_equal("inner child", "(RL,5)", a_left.out)
			end
			end
			check Result end
		end

	t7: BOOLEAN
		do
			comment("t7: check outer_child root query")
			-- setup has run, thus
			Result := root.key ~ "Zak" and root.value = 4
			check Result end
			-- outer_child of root is Void, no parent
			Result := root.outer_child = Void
			check Result end
		end

end
