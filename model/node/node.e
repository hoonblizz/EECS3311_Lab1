note
	description: "[
		{NODE} adds some features needed for red/black trees to BASIC_NODE
		It is is used by trees, including red/black trees 
		to store a key K and a value V. 
		It also has references to its parent node, 
		and left and right childern nodes.
		It is void safe..
	]"
	author: "JSO, JP"
	date: "$Date$"
	revision: "$Revision$"

class
	NODE [K -> COMPARABLE, V -> ANY]

inherit

	BASIC_NODE [K, V]

create
	make, make_red

convert -- same as BASIC_NODE
	make ({TUPLE [K, V]}),
	item: {TUPLE [K, V]}
	-- the convert clause allows for implicit conversion
	-- in this case from tuple to node and node to tuple
	-- i.e. node := tuple, will implicitly call
	-- node := create {attached NODE [K, V]}.make (tuple)
	-- similarly tuple := node will implicitly call
	-- tuple := node.item

feature {NONE} -- constructors

	make_red (a_item: TUPLE [K, V])
			-- makes a red node with `a_item'
		do
			item := a_item
			set_red
		end

feature -- RB queries

	colour: INTEGER
			-- colour of the node used in a RB tree
			-- 1 is red, 0 is black, 2 is double black
			-- defaults to black


	is_red: BOOLEAN
			-- returns whether a node is red or not

		do
			Result := colour = 1
		end

	is_black: BOOLEAN
			-- returns whether a node is black or not
		do
			Result := colour = 0
		end

	is_double_black: BOOLEAN
			-- returns whether a node is double black or not
		do
			Result := colour = 2
		end

feature -- RB commands

	set_red
			-- sets colour to red
		do
			colour := 1
		end

	set_black
			-- sets colour to black
		do
			colour := 0
		end

	set_double_black
			-- sets colour to double black
		do
			colour := 2
		end

end
