note
	description: "[
		{SORTED_BST} is a concrete implementation of sorted tree. It
		inherits all of {SORTED_TREE}'s features and contracts and
		implements its deferred features.
		
		You must implement to specifications/tests
		wherever you see
			-- TO DO --
			check False end
	]"
	author: "JP, JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_BST[K -> COMPARABLE, V -> ANY]

inherit
	SORTED_TREE_ADT[K,V]

create
	make_empty

feature{NONE} -- private commands

	extend_node(a_item: TUPLE[key:K; val:V]; a_node: NODE[K,V])
			-- helper method to extend `node' with `a_item'
		do
			--print("Extending node!! " + a_node.out)
			-- TO DO --
			-- Plan: (Please refer SORTED_RBT)
			-- if item key is greater than new node key, pass it to left.
			-- Or if left node not exists, create one.
			-- if new node key is greater, then pass it to right
			-- or if right node not exist, create one.
			if a_item.key > a_node.key then
				if attached a_node.right as n_right then
					extend_node(a_item, n_right)
				else
					a_node.right := create {NODE[K,V]}.make (a_item)
				end
			elseif a_item.key < a_node.key then
				if attached a_node.left as n_left then
					extend_node(a_item, n_left)
				else
					a_node.left := create {NODE[K,V]}.make (a_item)
				end
			end

		end

	remove_node(a_node: NODE[K,V])
			-- helper method to remove `node'
		local
			predecessor: NODE[K,V]
			successor: NODE[K,V]
			l_item: TUPLE[K,V]
		do
			-- TO DO --
			--check False end
			--print("Removing Node!! " + a_node.out)
			-- Plan: (please refer SORTED_RBT)
			-- Before node deletion, check left and right children.
			-- Case 1: No children nodes exist
			--	Simply remove a_node
			-- Case 2: One child exists.
			--	Get child node and attach to a_node's parent node.
			--	(Because of property of binary search tree, no sorting needed)
			-- Case 3: left and righ children exist
			--	First, we need predecessor (largest element of a_node's LEFT subtree)
			--	Second, we need successor (smallest element of a_node's RIGHT subtree)
			--	Then, successor takes a_node's position (replace)
			--	Then, remove successor. 	(attach children to it's parent)	
			--	OR, using predecessor, replace a_node with predecessor

			--print("%NRemove Target node: " + a_node.out)
			-- if both children exists,
			if attached a_node.left as n_left and attached a_node.right as n_right then
				predecessor := find_largest(n_left)
				l_item := predecessor.item
				remove_node(predecessor)
				a_node.item := l_item
			elseif attached a_node.only_child as n_child then
				-- a_node has one child
				a_node.replace_node (n_child)
			elseif attached a_node.parent as parent then
				-- a_node has no children but not root
				a_node.make_void
			else
				-- a_node is root
				wipe_out
			end


		end

end
