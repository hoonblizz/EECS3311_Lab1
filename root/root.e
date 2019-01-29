note
	description: "Calendar application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit
	ARGUMENTS
	ES_SUITE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			add_test (create {STUDENT_TESTS}.make)
			add_test (create {STUDENT_TEST_NODE}.make)
			add_test (create {BST_EXTEND_TEST}.make)

			-- get the above tests working,
			-- then uncomment tests below

			add_test (create {STUDENT_BST_TESTS}.make)
			add_test (create {BST_TESTS}.make)
			add_test (create {RBT_TESTS}.make)
			add_test (create {RBT_TESTS2}.make)
			show_browser
			run_espec
		end

end
