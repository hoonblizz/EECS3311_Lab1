note
	description: "[
		Representation of a node as the equivalent of
		a [Key, Value] tuple.
		
		Tuples are not compare_object by default.
		Hence converting a tuple to an an instance
		of ELEMENT  ensures a value semantic.
		e.g tree.min ~ [10, "ten"] where
		tree.min returns an ELEMENt[INTEGER, STRING]
		]"
	author: "JSO"

class
	ELEMENT[G -> attached ANY, H -> attached ANY]
inherit
	ANY
		redefine
			is_equal,
			out
		end
	DEBUG_OUTPUT
		undefine
			is_equal,
			out
		end
create
	make,
	make_from_tuple

convert
    make_from_tuple ({TUPLE[G, H]}),
    as_tuple: {TUPLE[G,H]}

feature -- Queries

	key: G

	val: H

feature -- Constructor

	make (g: G; h: H)
		do
			key := g
			val := h
		end

	make_from_tuple (t: TUPLE[g: G; h: H])
		require
			t.count = 2
			attached {G} t.g
			attached {H} t.h
		do
			make (t.g, t.h)
		end

	as_tuple: TUPLE[G, H]
		do
			Result := [key, val]
			Result.compare_objects
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is current pair equal to 'other'?
		do
			Result := key ~ other.key and then
						val ~ other.val
		end

feature -- Debug output

	debug_output: STRING
		do
			Result := out
		end

	out: STRING
		do
			create Result.make_empty
			check attached {G} key  as fst then
			check attached {H} val as snd then
				Result.append (fst.out)
				Result.append (" -> ")
				Result.append (snd.out)
			end
			end
		end
end
