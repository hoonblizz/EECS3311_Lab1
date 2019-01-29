note
	description: "[
		{SORTED_RBT} is a concrete implementation of sorted tree. It
		inherits all of {SORTED_TREE}'s features and contracts and
		implements its deferred features.
	]"
	author: "JP, JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_RBT[K -> COMPARABLE, V -> ANY]

inherit
	SORTED_TREE_ADT[K,V]

create
	make_empty

feature{NONE} -- private commands


	extend_node(a_item: TUPLE[key:K;val:V]; a_node: NODE[K,V])
			-- helper method to extend `node' with `a_item'
		do
			if a_node.key > a_item.key then
				if attached a_node.left as left then
					extend_node(a_item, left)
				else
					a_node.left := create {NODE[K,V]}.make_red (a_item)
					if attached a_node.left as left then
						insert_balance(left)
					end
				end
			elseif a_node.key < a_item.key then
				if attached a_node.right as right then
					extend_node(a_item, right)
				else
					a_node.right := create {NODE[K,V]}.make_red (a_item)
					if attached a_node.right as right then
						insert_balance(right)
					end
				end
			end
		end

	remove_node(a_node: NODE[K,V])
			-- helper method to remove `node'
		local
			largest: NODE[K,V]
			l_item: TUPLE[K,V]
		do
			if attached a_node.left as left and then attached a_node.right then
					-- a_node has two children
				largest := find_largest(left)
				l_item := largest.item
				remove_node(largest)
				a_node.item := l_item
			elseif attached a_node.only_child as child then
					-- a_node has one child
				if not a_node.is_black = child.is_black then
					a_node.set_black
				else
					a_node.set_double_black
				end
				a_node.replace_node (child)
				if a_node.is_double_black then
					remove_balance (a_node)
				end
			elseif attached a_node.parent as parent then
					-- a_node has no children but is not root
				if a_node.is_black then
					a_node.set_double_black
				end
				a_node.make_void
				if a_node.is_double_black and then attached parent.right as right then
					remove_balance(right)
				end
			else
					-- a_node is root
				wipe_out
			end
		end

	insert_balance(a_node: NODE [K,V])
			-- rebalances subtree around `a_node' after node has been inserted
			-- naming convention:
				--p is parent, g is grandparent, gg is great-grandparent, u is unclde
		do
			if attached a_node.parent as p and then attached p.parent as gp and then not p.is_black then
				if attached p.sibling as u and then u.is_red then
						-- uncle is red
						-- double rotation may be needed
					p.set_black
					u.set_black
					if attached gp.parent as gg then
						gp.set_red
						if gg.is_red then
							insert_balance(gp)
						end
					end
				elseif attached p.outer_child as o and then a_node = o then
						-- left left or right right
						-- double rotation may be needed
					rotate(p)
					p.set_black
					if attached gp.parent as gg then
						gp.set_red
						if gg.is_red then
							insert_balance(gp)
						end
					end
				else
						-- left right or right left
						-- only one rotation needed
					rotate(a_node)
					insert_balance(p)
				end
			end
		end

	remove_balance(a_node: NODE [K,V])
			-- rebalances subtree around `a_node' after node has been removed
		do
			if attached a_node.parent as p then
				if attached a_node.sibling as s then
					if s.is_black then
						if attached s.inner_child as i and then i.is_red then
								-- left left or right right
								-- only one rotation needed
							rotate(s)
							i.set_black
							a_node.set_black
						elseif attached s.outer_child as o and then o.is_red then
								-- left right or right left
								-- double rotation may be needed
							rotate(o)
							o.set_black
							s.set_red
							remove_balance(a_node)
						elseif p.is_black then
								-- both children back
							s.set_red
							p.set_double_black
							remove_balance(p)
						else
							s.set_red
							p.set_black
						end
					else
						rotate(s)
						p.set_red
						s.set_black
						remove_balance(a_node)
					end
				else
					rotate(a_node)
					a_node.set_black
					p.set_red
					if attached p.parent as gp and then attached p.inner_child as i then
						i.set_red
						p.set_black
					end
				end
			else
				a_node.set_black
			end
		end

	rotate(node: NODE[K,V])
			-- calls correct rotate procedure based on node position
		do
			if attached node.parent as p then
				if p.right = node then
					rotate_left(node, p)
				else
					rotate_right(node, p)
				end
			end
		end

	rotate_right(c, p: NODE[K,V])
			-- performs a right rotation on two nodes
		do
			if attached p.parent as g then
				if g.left = p then
					g.left := c
				else
					g.right := c
				end
			else
				root := c
				c.parent := void
			end
			p.left := c.right
			c.right := p
		end

	rotate_left(c, p: NODE[K,V])
			-- performs a left rotation on two nodes
		do
			if attached p.parent as g then
				if g.left = p then
					g.left := c
				else
					g.right := c
				end
			else
				root := c
				c.parent := void
			end
			p.right := c.left
			c.left := p
		end

feature{NONE} -- private queries for invariant


	find_smallest_leaf: detachable NODE [K,V]
			-- a helper method to find the smallest key in a tree that is a leaf
		local
			smallest: NODE [K,V]
		do
			if attached root as r then
				smallest := find_smallest (r)
				if attached smallest.right as right then
					Result := find_smallest (right)
				else
					Result := smallest
				end
			end
		end

	black_path_length(cur, leaf: detachable NODE[K,V]; length: INTEGER): INTEGER
			-- a helper method that returns how many black `node' are in a path
		local
			len: INTEGER
		do
			if attached cur and attached leaf then
				if attached cur.is_black then
					len := length + 1
				end
				if cur.item ~ leaf.item then
					Result := len
				elseif leaf.key > cur.key  then
					Result := black_path_length(leaf, cur.left, len)
				else
					Result := black_path_length(leaf, cur.right, len)
				end
			end
		end

	count_path(a_node: NODE[K,V]): INTEGER
			-- returns how many black `a_node' are in a path
		do
			result := black_path_length(root, a_node, 0)
		end

invariant

	-- below are the tree basic properties of a valid red-black tree
	-- that is for a red_black tree to be valid, it must satisfy the following:
		-- 1. the root of the tree must always be black
		-- 2. no consecutive nodes in any path may be red
		-- 3. the number of black nodes on the every leaf node must be the same

	root_is_black:
			-- ensures that the root of the tree is black
		attached root as r implies
			r.is_black or else r.is_double_black
	no_succesive_red_nodes:
			-- ensures that no consecutive nodes along any path are red
		across as_node_array as n all
	 		n.item.is_red implies
	 			(attached n.item.parent as parent implies not parent.is_red)
	 	end
	path_to_leaf_same_length:
			-- ensures that the path to every leaf has the same number of black nodes
		across as_node_array as n all
			n.item.is_leaf and then (attached find_smallest_leaf as small) implies
			 	count_path(n.item) = count_path(small)
		end


end
