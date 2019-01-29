note
	description: "Summary description for {TREE_PATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_PATH

inherit
	ANY
		redefine
			is_equal, out
		end

create
	make_empty

feature {NONE}  -- creation

	make_empty
		do
			create path.make_empty
		end

feature{TREE_PATH} -- attribute

	path: SEQ[STRING]

	item alias "[]"(i: INTEGER): STRING
		do
			Result := path[i]
		end

feature  -- commands

	append_left(a_key: STRING)
		do
			path.append ("left ("+a_key+")")
		end

	append_right(a_key: STRING)
		do
			path.append ("right ("+a_key+")")
		end

	append_root(a_key: STRING)
		do
			path.append ("root ("+a_key+")")
		end

feature -- queries

	is_equal(other: like Current): BOOLEAN
		do
			Result :=
				path.count = other.path.count and then
					across path.lower |..| path.upper as i all
						path[i.item] ~ other.path[i.item]
					end
		end

	out: STRING
		do
			create Result.make_empty
			across 1 |..| (path.count - 1) as i loop
				Result.append(path[i.item] + ", ")
			end
			Result.append(path[path.count])
		end


end
