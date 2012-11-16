require 'spec_helper'

describe "Library object" do
	
	before :all do
		lib_obj = [
			Book.new("Book One", "Author One", :development),
			Book.new("Book Two", "Author Two", :design),
			Book.new("Book Three", "Author Three", :usability),
			Book.new("Book Four", "Author Four", :design),
			Book.new("Book Five", "Author Five", :development) 
		]
		File.open "books.yml", "w" do |f|
			f.write YAML::dump lib_obj
		end
	end

	before :each do
		@lib = Library.new "books.yml"
	end

	describe "#new" do
		context "with no parameters" do
			it "has no books" do
				lib = Library.new
				lib.should have(0).books
			end
		end
		context "with a YAML file parameters" do
			it "has 5 books" do
				@lib.should have(5).books
			end
		end	
	end

	it "returns all books in a given category" do
		@lib.get_books_in_category(:development).length.should == 2
	end

	it "accepts new books" do
		@lib.add_book( Book.new("Designing for the Web", "Mark Boulton", :design) )
		@lib.get_book("Designing for the Web").should be_an_instance_of Book
	end

	it "saves the library" do
		books = @lib.books.map { |book| book.title }
		@lib.save
		lib2 = Library.new "books.yml"
		books2 = lib2.books.map { |book| book.title }
		books.should eql books2
	end
end