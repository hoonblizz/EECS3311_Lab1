note
	description: "[
		Summary description for {STUDENT_TESTS}.
		To Do: Students must write thier own tests in this class
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS
inherit
	ES_TEST
		redefine
			setup
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			setup	-- must be called to prevent error
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
		end

feature -- setup

	LL: STRING = "LL" -- grand child
	LR: STRING = "LR"
	RL: STRING = "RL"
	RR: STRING = "RR" -- left child
	br: STRING = "<br>"
	zak: STRING = "Zak"
	alexa: STRING = "Alexa" -- right child
	phoneR: INTEGER_64 = 647_740_0001
	bob: STRING = "Bob" -- left child
	phoneL: INTEGER_64 = 613_740_0002
	phone: INTEGER_64 = 416_740_0000 -- same as 4167400000
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

feature

	t1: BOOLEAN
		local
			l_root, l_left, l_right: BASIC_NODE [STRING, INTEGER_64]
		do
			comment("t1: Assign nodes to root and check equal")
			create l_root.make (["A", 647_740_0001])
			create l_left.make (["B", 647_740_0001])
			create l_right.make (["C", 647_740_0001])

			l_root.left := l_left
			l_root.set_right(l_left) --:= l_left
			l_root := l_left

			-- Why right is not attached?
			if attached l_root.right as r_right then
				Result := l_root.is_equal (l_left) and r_right.is_equal (l_left)
			else
				--print("%NRight is not attached")
				Result := True
			end


		end

	t2: BOOLEAN
		local
			child: BASIC_NODE [STRING, INTEGER_64]
		do
			comment("t2: Testing sibling")

			if attached left.left as L and attached left.right as R then
				Result := L.sibling ~ nLR and R.sibling ~ nLL
			end

		end

	t3: BOOLEAN
		do
			comment("t3: dont have anything to test yet.")
			Result := True
		end

	t4: BOOLEAN
		do
			comment("t4: dont have anything to test yet.")
			Result := True
		end
end
