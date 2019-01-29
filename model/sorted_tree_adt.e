note
	description: "[
		SORTED_TREE_ADT is a deferred ADT (abstract data type)
		of any sorted tree with non-void generic parameters key K and value V.
		It contains the public interface and all the common features but it
		itself is not instantiatable.
		
		Secret: it hides part of a tree implementation using NODE[K,V].  
		The Chart view is:
		
		Queries
			root_key: detachable K
			count: INTEGER_32
			has (a_key: K): BOOLEAN
			is_empty: BOOLEAN
			item alias "[]" (a_key: K): V
			max: TUPLE [K, V]
			min: TUPLE [K, V]
			as_array: ARRAY [TUPLE [K, V]]
			out: STRING_8
		Commands
			extend (a_item: TUPLE [K, V])
			remove (a_key: K)
			wipe_out
		Model
			model: SEQ [NODE [K, V]]
			model_path: FUN[K, SEQ[STRING]]
				Two trees are equal if their sequences 
				and paths match.
			
		This tree ADT has an iterator, e.g for integer keys:
		  across tree as a_key all
			1 <= a_key.item and a_key.item <= 14
		  end

		There are two deferred private commands
			remove_node(a_node: NODE[K,V])
			extend_node(a_node: NODE[K,V])
		that must be effected by descendants,
		such as a Binary Search Tree
		or a Red Black Tree.
		
		You must implement to specifications/tests
		wherever you see
			-- TO DO --
			check False end
		i.e.
			find_largest
			find_smallest
			is_equal

	]"
	author: "JP, JSO"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SORTED_TREE_ADT[K -> COMPARABLE, V -> ANY]

inherit
	ITERABLE[K]
		redefine out, is_equal end

feature{NONE,ES_TEST} -- root

	root: detachable NODE[K,V]
				-- root of the tree
feature -- model

	model:SEQ[NODE[K,V]]
			-- tree as a linear sequence of nodes inorder
		do
			create Result.make_from_array(as_node_array)
		end

	model_path: FUN[K, SEQ[STRING]]
			-- path from root to key K
		do
			create Result.make_empty
			-- if the key exists then there must be a root
			if attached root as l_root then
				across Current as a_key loop
			  		Result.extend ([a_key.item, path(l_root,a_key.item)])
			  	end
		  	end
		ensure
			across Result.range as indicators all
				across indicators.item as indicator all
					indicator.item.out ~ "root" or
					indicator.item.out ~ "left" or
					indicator.item.out ~ "right"
				end
			end
		end

feature{NONE}  -- creation

	make_empty
			-- creates a tree with no elements
		do
			default_create
		end

feature -- commands

	extend(a_item: TUPLE[key:K; val:V])
			-- extend tree to include tree with a node
			-- containing the key and value of `a_item'
		require
			item_unique: not has(a_item.key)
		do
			if attached root as r then
				extend_node(a_item, r)
			else
				root := a_item
					-- implicit conversion of tuple to node
			end
		ensure
			increment_count:
				count = old count + 1
				model_path.count ~ (old model_path).count + 1
			extended: Current[a_item.key] ~ a_item.val
			inserted:
				model ~ (old model.deep_twin).inserted (a_item, index_of(a_item.key))
		end

	remove(a_key: K)
			-- removes node with `a_key' from tree
		require
			item_exists: has(a_key)
		do
			check attached node_of(a_key) as n then
				remove_node(n)
			end
		ensure
			decrement_count:
				count = old count - 1
				model_path.count ~ (old model_path).count - 1
			element_removed: not has(a_key)
			removed:
				model ~ (old model.deep_twin).removed(old index_of(a_key))
		end

	wipe_out
			-- removes all elements from tree
		do
			root := void
		ensure
			tree_empty: model.is_empty
		end

feature -- queries
	root_key: detachable K
		do
			if attached root as l_root then
				Result := l_root.key
			end
		ensure
			attached root as a_root implies Result ~ a_root.key
		end

	is_equal(other: like Current): BOOLEAN
		local
			i: INTEGER
		do
			-- TO DO --
			--check False end
			Result := Current.model ~ other.model and Current.model_path ~ other.model_path
		ensure then
			same:
				Result = ((model ~ other.model) and (model_path ~ other.model_path))
		 end

	is_empty: BOOLEAN
			-- returns whether the tree is empty
		do
			Result := not attached root
		ensure
			count_is_zero: Result = (count = 0)
			empty_matches_model: Result = model.is_empty
			model_unchanged: model ~ old model.deep_twin
		end

	item alias "[]" (a_key: K): V
			-- returns the value associated with `a_key'
		do
			check attached node_of(a_key) as el then
				Result := el.value
			end
		ensure
			result_correct: Result ~ model [index_of(a_key)].value
			model_unchanged: model ~ old model.deep_twin
		end


	min: ELEMENT[K, V]
			-- returns minimum element in tree
		require
			tree_not_empty: not is_empty
		local
			l_tuple: TUPLE[key:K; val:V]
		do
			check attached root as r then
				l_tuple := find_smallest(r)
				create Result.make_from_tuple (l_tuple)
			end
		ensure
			correct_min: Result ~ model.first.as_element
			count_unchanged: count ~ old count
			model_unchanged: model ~ old model.deep_twin
		end

	max: ELEMENT[K, V]
			-- returns maximum element in tree
		require
			tree_not_empty: not is_empty
		local
			l_tuple: TUPLE[key:K; val:V]
		do
			check attached root as r then
				l_tuple := find_largest(r)
				create Result.make_from_tuple (l_tuple)
			end
		ensure
			count_unchanged: count ~ old count
			correct_max: Result ~ model.last.as_element
			model_unchanged:
				model ~ old model.deep_twin
				model_path ~ old model_path.twin
		end

	count: INTEGER
			-- returns number of elements in tree
		do
			result := as_array.count
		ensure
			count_unchanged: count ~ old count
			result_correct: Result = model.count
			model_unchanged: model ~ old model.deep_twin
		end


	has(a_key: K): BOOLEAN
			-- returns whether `a_key' exists in tree
		do
			Result := attached node_of(a_key)
		ensure
			count_unchanged: count ~ old count
			correct_result: Result = model.has(model[index_of(a_key)])
			model_unchanged: model ~ old model.deep_twin
		end

	keys: ARRAY[K]
			-- keys of tree in sorted orde
		local
			l_key: K
		do
			create Result.make_empty
			across as_node_array as l_c loop
				l_key := l_c.item.key
				Result.force(l_key, Result.upper + 1)
			end
		end


feature {NONE,ES_TEST, SORTED_TREE_ADT} -- path implementation
	path_of(a_key: K): TREE_PATH
			-- returns the path to node associated with `a_key'
			-- as a sequence of strings
		require
			has_key: has(a_key)
		do
			create Result.make_empty
			check attached root as r then
				Result.append_root (r.key.out)
			end
			across path_as_booleans(a_key) as pth loop
				if pth.item.bool then
					Result.append_left(pth.item.a_key.out)
				else
					Result.append_right(pth.item.a_key.out)
				end
			end
		end

	model_restricted_to(a_node: NODE[K,V]): SEQ[NODE[K,V]]
			-- subtree representation of tree with nodes
		require
			model.has (a_node)
		do
			create Result.make_empty
			to_sequence(a_node, Result)
		end
	tree: FUN[TREE_PATH, NODE[K,V]]
		do
			create Result.make_empty
			across as_node_array as l_node loop
				Result.extend ([path_of (l_node.item.key), l_node.item])
			end
		end

	path_as_booleans(a_key: K): SEQ[TUPLE[bool:BOOLEAN; a_key: K]]
			-- returns the path to node associated with `a_key'
			-- as a sequence of booleans
		do
			create Result.make_empty
			if attached node_of(a_key) as node then
				Result := path_helper(node, Result)
			end
		end

	path_helper(a_node: NODE[K,V]; a_seq: SEQ[TUPLE[BOOLEAN, K]]): like a_seq
		do
			if attached a_node.parent as parent then
				a_seq.prepend ([parent.left = a_node, a_node.key])
				Result := path_helper(parent, a_seq)
			else
				Result := a_seq
			end
		end


	path(a_node: NODE[K,V]; a_key: K ): SEQ[STRING]
			-- path from `a_node' in tree to `a_key'
		require
			has(a_key) and model.has (a_node)
		do
			if not attached Result then
				create Result.make_empty
			end
			check attached root as l_root then
				if a_key ~ l_root.key then
					Result.append ("root")
				end
			end
			if a_key ~ a_node.key then
				-- skip, i.e. base case
			end
			if attached a_node.left as l_left and a_key < a_node.key then
				Result.append("left")
				Result.concatenate(path(l_left, a_key ))
			end
			if attached a_node.right as l_right and a_key > a_node.key then
				Result.append("right")
				Result.concatenate(path(l_right, a_key))
			end
		end

	path_for_key(a_key: K): SEQ[STRING]
			-- path from `root' to `a_key'
			-- as a sequence of left or right branching from root
		require
			has(a_key)
		do
			-- if the key exists then there must be a root
			check attached root as l_root then
				Result := path(l_root,a_key)
			end
		ensure
			across Result as cr all
				cr.item ~ "root" or cr.item ~ "left" or cr.item ~ "right"
			end
		end

feature -- out

	out: STRING
		do
			create Result.make_empty
			across
				as_node_array as l_c
			loop
				Result.append (l_c.item.out)
			end
		end


feature{NONE, ES_TEST, SORTED_TREE_ADT} -- private queries

	as_array: ARRAY[TUPLE[key:K; val:V]]
			-- array representation of tree
		do
			create Result.make_empty
			across as_node_array as l_c loop
				Result.force(l_c.item, Result.upper + 1)
					-- implicit conversion from node to tuple
			end
		ensure
			sorted: is_sorted (Result)
			count_consistent: count = as_array.count
			model_unchanged: model ~ old model.deep_twin
		end


	tree_restricted_to(a_node: NODE[K,V]): ARRAY[NODE[K,V]]
			-- array representation of tree with nodes
		do
			create Result.make_empty
			to_array(a_node, Result)
			Result.compare_objects
		end

	to_array(a_node: detachable NODE[K,V]; arr: ARRAY[NODE[K,V]])
			-- recursive helper method to print tree in order
		do
			if attached a_node then
				to_array(a_node.left, arr)
				arr.force(a_node, arr.count + arr.lower)
				to_array(a_node.right, arr)
			end
		end


	to_sequence(a_node: detachable NODE[K,V]; a_sequence: SEQ[NODE[K,V]])
			-- recursive helper method to print tree in order
		do
			if attached a_node then
				to_sequence(a_node.left, a_sequence)
				a_sequence.append(a_node)
				to_sequence(a_node.right, a_sequence)
			end
		end

	as_node_array: ARRAY[NODE[K,V]]
			-- array representation of tree with nodes
		do
			create Result.make_empty
			to_array(root, Result)
			Result.compare_objects
		end

	node_of (a_key: K): detachable NODE[K,V]
			-- returns node with associated `a_key' from tree
		do
			Result := find_node_of(a_key, root)
		ensure
			valid_result: attached Result implies Result ~ model[index_of(a_key)]
			count_unchanged: count ~ old count
		end

	find_node_of(a_key: K; a_node: detachable NODE[K,V]): detachable NODE[K,V]
			-- recursive helper method to find element from `a_key'
		do
			if not attached a_node or else a_node.key ~ a_key then
				Result := a_node
			elseif a_node.key > a_key then
				Result := find_node_of(a_key, a_node.left)
			else
				Result := find_node_of(a_key, a_node.right)
			end
		end

	is_sorted(arr: ARRAY[TUPLE[key:K; val:V]]): BOOLEAN
			-- returns whether `arr' is sorted
		do
			Result :=
				across
					1 |..| (arr.count - 1) as l_c
				all
					arr[l_c.item].key < arr[l_c.item + 1].key
				end
		end

	find_largest (a_node: NODE [K,V]): NODE [K,V]
			--finds the largest element of the tree rooted at `a_node'
		require
			not is_empty
		do
			--print("%NFind Largest Current node: " + a_node.out)
			-- TO DO --
			--check False end
			-- Plan:
			-- go over each node using recursion heading right
			-- (Because in BST, the most right node is the greatest)
			-- until the end of node (No child node attached found)
			if attached a_node.right as n_right then
				Result := find_largest (n_right)
			else
				-- if right node is not attached, current node is the greatest.
				Result := a_node
			end

--			The code below is wrong, it's just there to compile
--			without VEVI error
			--check attached root as l_root then
			--	Result := l_root
			--end




		ensure
			Result ~ model_restricted_to (a_node)[model_restricted_to (a_node).count]

		end

	find_smallest (a_node: NODE [K,V]): NODE [K,V]
			--finds the `node' with the smallest element
		require
				not is_empty
		do
			--print("%NFind Smallest Current node: " + a_node.out)
			-- TO DO --
			-- Plan:
			-- go over each node using recursion heading left
			-- (Because in BST, the most left node is the samllest)
			-- until the end of node (No child node attached found)
			if attached a_node.left as n_left then
				Result := find_smallest (n_left)
			else
				-- if right node is not attached, current node is the smallest.
				Result := a_node
			end

			-- The code below is wrong, it's just there to compile
			-- without VEVI error
			--check attached root as l_root then
			--	Result := l_root
			--end



		ensure

			Result ~  model_restricted_to (a_node)[model_restricted_to (a_node).lower]
		end

	index_of(a_key: K): INTEGER
			-- returns index of `a_key' if it exists, returns -1 otherwise
		require
			key_exists: has (a_key)
		local
			i: INTEGER
		do
			i := as_array.lower
			across as_array as l_c loop
				if l_c.item.key ~ a_key then
					Result := i
				end
				i := i + 1
			end
		ensure
			index_matches_element: model[Result] ~ node_of (a_key)
		end

feature{NONE} -- deferred commands

	remove_node(a_node: NODE[K,V])
		require
			 tree_has_node: model.has (a_node)
		deferred
		end

	extend_node(a_item: TUPLE[K,V]; a_node: NODE[K,V])
			-- extend tree rooted at a_node
			-- with a new node with key and value of `a_item'
		require
			 tree_has_node: model.has (a_node)
		deferred
		end



feature {NONE} -- iteration


	new_cursor: ITERATION_CURSOR[K]
		do
			Result := keys.new_cursor
		end

invariant


	subtrees_fit_bst_property:
			-- ensures that every nodes left child is smaller and right child is greater if it exists
		across as_node_array as n all
			(attached n.item.left as left implies n.item > left) and then
			(attached n.item.right as right implies n.item < right)
		end
	child_has_correct_parents:
			-- ensures that every nodes child pointer has its parent pointing back at it
		across as_node_array as n all
			(attached n.item.left as left implies left.parent = n.item)	and then
			(attached n.item.right as right implies right.parent = n.item)
		end

end
