note
	description: "[
		BASIC_NODE is is used by a tree 
		to store a key K and a value V. 
		It also has references to its parent node, 
		and left and right children nodes.
		Settings may be void-safe (where types by default
		are are attached).
		 
		Key K and value V are both attached.
		For V to be detachable, we would have to write
		'V -> detachable ANY', and make other adjustments.
		
		A node does not have any secrets, thus all
		features are public. There are no invariants.
		
		You must implement to specifications/tests
		wherever you see
			-- TO DO --
			check False end
		i.e.
			is_equal
			sibling
			inner_child
			outer_child
			traverse_inorder (command0
			inorder query
	]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	BASIC_NODE [K -> COMPARABLE, V -> ANY]

inherit

	COMPARABLE
		redefine
			out,
			is_equal
		end

create
	make



feature {NONE} -- constructors


	make (a_item: TUPLE [K, V])
			-- makes a node with `a_item'
			-- node will be black by default
		do
			item := a_item
		end

feature -- attributes

	item: TUPLE [key: K; val: V] assign set_item
			-- returns the current item
			-- NOTE: by default item is immutable outside of Current
			-- assign set_item allows users to call item := 4
			-- this is interpereted as item.set_item(4)

	left: detachable like Current assign set_left
			-- pointer to left child

	right: detachable like Current assign set_right
			-- pointer to right child

	parent: detachable like Current assign set_parent
			-- pointer to parent

feature -- queries

	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := key < other.key
		end

	is_leaf: BOOLEAN
			-- returns whether a node is a leaf or not
		do
			Result := not (attached left or else attached right)
		ensure
			is_leaf: Result = ((not attached left) and then (not attached right))
		end

	is_equal (other: like Current): BOOLEAN
			-- Are the current node's key and value same as those of `other'?
		do
			-- TO DO --
			-- check False end
			Result := key ~ other.key and value ~ other.value
			--Result := item ~ other
		end

	key: K
			-- returns key of the node
		do
			Result := item.key
		end

	value: V
			-- returns value of the node
		do
			Result := item.val
		end

	as_element: ELEMENT[K,V]
			-- convert Current node to an element
			-- an tuple can be converted to an element
		local
			l_tuple: TUPLE[K, V]
		do
			l_tuple := [key, value]
			create Result.make_from_tuple (l_tuple)
		ensure
			correct_key: Result.key ~ key
			corect_value: Result.val ~ value
		end

feature -- commands

	set_item (a_item: TUPLE [key: K; val: V])
			-- sets `Current' item to `a_item'
		do
			item := a_item
		end

	set_left (a_node: detachable like Current)
			-- updates left child to `a_node'
			-- updates left child's parent to `Current' if attached
		do
			left := a_node
			if attached left as l then
				l.parent := Current
			end
		ensure
			node_set: left = a_node
			child_has_correct_parent: attached left as l implies l.parent = Current
		end

	set_right (a_node: detachable like Current)
			-- updates right child to `a_node'
			-- updates right child's parent to `Current' if attached
		do
			right := a_node
			if attached right as r then
				r.parent := Current
			end
		ensure
			node_set: right = a_node
			child_has_correct_parent: attached right as r implies r.parent = Current
		end

	set_parent (a_node: detachable like Current)
			-- updates parent to `a_node'
		do
			parent := a_node
		end

	make_void
			-- updates `Current' node to `Void'
			-- NOTE: `Current' := `Void' will not compile
			-- does nothing if `Current' is a root node
		do
			if attached parent as p then
				if p.item.key > key then
					p.left := Void
				else
					p.right := Void
				end
			end
		end

	replace_node (a_node: like Current)
			-- replaces content of node with that of `a_node'
			-- updates pointers to left and right
			-- will update pointers to parent of children to `Current'
		do
			item := a_node.item
			Current.right := a_node.right
			Current.left := a_node.left

--			set_left (a_node.left)
--			set_right (a_node.right)
--			a_node.parent := Current.parent
		end

feature -- position queries

	only_child: detachable like Current
			-- returns a node if it is an only child
		require
			no_more_than_one_node: not (attached left and attached right)
		do
			if attached left then
				Result := left
			else
				Result := right
			end
		ensure
			only_child_left: (Result = left) implies not attached right
			only_child_right: (Result = right) implies not attached left
		end

	sibling: detachable like Current
			-- returns the sibling of Current
			-- i.e. if Current is right child of parent, sibling is left child of parent
			-- Returns nothing if child is root or has not sibling
		do
			-- TO DO --
			-- Plan:
			-- Child is root = Current has no parent.
			-- Child has no sibling = Check if parent has both children
			--print("%NCurrent: " + Current.out)
			if attached parent as n_parent then
				--print("%NCurrent has parent: " + n_parent.out)
				if attached n_parent.left as p_left and attached n_parent.right as p_right then
					--print("%NLeft Children: " + p_left.out)
					--print("%NRight Children: " + p_right.out)
					if Current ~ p_left then
						Result := p_right
					end
					if Current ~ p_right then
						Result := p_left
					end
				end
			end

		ensure
			correct_sibling: attached parent as p implies ((p.right = Result and p.left = Current) xor (p.left = Result and p.right = Current))
		end

	inner_child: detachable like Current
			-- returns the inner child of Current relative to its parent
			-- e.g. if Current is right child of parent, Result is left child of Current
			-- Returns nothing if Current is root or inner child does not exists
		do
			-- TO DO --
			-- Plan:
			-- Follow the example plus, add extra case where
			-- 'if Current is left child of parent, Result is right child of Current'
			if attached Current.parent as n_parent then
				if Current ~ n_parent.right and attached Current.left as n_left then
					Result := n_left
				end
				if Current ~ n_parent.left and attached Current.right as n_right then
					Result := n_right
				end
			end
		ensure
			correct_inner_child:
				attached parent as p implies
				((p.right = Current and then left = Result)
				xor (p.left = Current and then right = Result))
		end

	outer_child: detachable like Current
			-- returns the outer child of Current relative to its parent
			-- e.g. if Current is right child of parent, Result is right child of Current
			-- Returns nothing if Current is root or outer child does not exists
		do
			-- TO DO --
			--check False end
			if attached Current.parent as n_parent then
				if Current ~ n_parent.right and attached Current.right as n_right then
					Result := n_right
				end
				if Current ~ n_parent.left and attached Current.left as n_left then
					Result := n_left
				end
			end
		ensure
			correct_outer_child:
				attached parent as p implies
				((p.right = Current and then right = Result)
				xor (p.left = Current and then left = Result))
		end

feature -- inorder traversal from Current

	inorder_result: STRING
		attribute
			Result := out
		end

	traverse_inorder
			-- traverse tree inorder starting at Current
			-- and place output as a string in `inorder_result'
			-- command version

			-- Plan: Using recursion, display left if exists, then center (parent)
			-- then right node.
		do
			-- TO DO --
			--check False end

			-- Go through Left side first
			if attached Current.left as l_left then
				l_left.traverse_inorder
			end

			-- When Left is all done, dislay Current
			-- Issue: when print, it works fine. But when it comes to passing string to
			-- other function, it's not working as expected.
			--print("(" + Current.key.out + "," + Current.value.out + ")")
			--inorder_result := "(LL,1)(Bob,2)(LR,3)(Zak,4)(RL,5)(Alexa,6)(RR,7)"
			inorder_result := inorder_result + Current.out
			print("%NInorder_Result: " + inorder_result)

			-- Then check right side
			if attached Current.right as l_right then
				l_right.traverse_inorder
			end

			

		end

	inorder: STRING
			-- traverse from Current inorder
			-- and output result as a string
			-- query version
		do
			Result := out
			-- TO DO --
			-- check False end
			-- Plan: Using above "traverse_inorder"
			Current.traverse_inorder

		end

feature -- output

	out: STRING
		do
			create Result.make_from_string ("(" + key.out + "," + value.out + ")")
		end

--		invariant
--			attached left as l_left
--			and attached right as l_right
--			implies l_left.parent = Current and l_right.parent = Current

end
