require './lib/library.rb'

describe Library do
  # As a library
  # In order to have good books to offer to the public
  # I would like to be able to have a collection of books

  it 'has book list on initialize' do
    expect(subject.book_list).not_to be_empty
  end

  # As a library
  # In order to lend a book to a Person
  # I would like to be able to find a book by its title
  it 'Return the book by searching the book title' do
    title = 'Pippi Långstrump går ombord'
    expected_output = subject.find(title)
    expect(expected_output[:item][:title]).to eq title
  end

  # As a library
  # In order to lend a book to a Person
  # I would like to find a book with same title and is available
  it 'Return status false if a book is not available' do
      expected_output = subject.find('Pippi Långstrump')
      expect(expected_output[:status]).to be false
  end

  # As a library
  # In order to have good books to offer to the public
  # I would like to allow individuals to check out a book
  # and return status true if it is checked out successfully

  it 'Return true if a book can be checked out' do
    result = subject.checkout('Alfons och soldatpappan')
    expect(result[:status]).to be true
  end

  # As a library
  # In order to have good books to offer to the public
  # I would like to be able to allow individuals to check out a book
  # After a book is checked out, the book list will change the available
  # status of the book to be false.

  it 'Change a book\'s available status to false after checking out a book' do
    expected_output = subject.checkout('Pippi Långstrump går ombord')
    expect(expected_output[:book][:available]).to eq false
  end

  # As a library
  # A book cannot be borrowed if it is not in the list

  it 'Show No book is found if checking out a book which is not in the list' do
      expected_output = {status: false, message:'No book is found'}
      expect(subject.checkout('Learning XML')).to eq expected_output
  end

  # As a library
  # In order to make the books available to many individuals
  # I would like to set a return date on every check out
  # and I would like that date to be 1 month from checkout date
  it 'A success checkout should return a date with return date in one month from now' do
    return_date = Date.today + Library::LOAN_DURATION
    expected_output = return_date.strftime("%d/%m/%y")
    result = subject.checkout('Osynligt med Alfons')
    expect(result[:return_date]).to eq expected_output
  end

  # As a library
  # I need to save the book status to the data file
  it 'Save the change into the data.yml file' do
    new_name = "Gunilla Bergström 2"
    subject.book_list[0][:item][:author] = new_name
    subject.save_to_disk
    collection = YAML.load_file('./lib/data.yml')
    expect(collection[0][:item][:author]).to eq new_name
  end

  # As a library
  # I need to remember which book is checked out.
  # Therefore the book status should be saved to the data file
  it 'Save the available status into the data.yml file after a successful checkout' do
    book_title = 'Alfons och soldatpappan'
    subject.checkout(book_title)
    collection = YAML.load_file('./lib/data.yml')
    booked_checked = collection.detect{|obj| obj[:item][:title].include? book_title}
    expect(booked_checked[:available]).to be false
  end

end
