class BookController < ApplicationController
#create
    get '/books/new' do
        #renders new book form 
            redirect_if_not_logged_in
            @book = Book.new
            erb :'/books/new'
    end

    post '/books' do 
        #proccess form
        @book = current_user.books.build(title: params[:title], author: params[:author])        
        if @book.save
            redirect "/books/#{@book.id}"
        else 
             erb :'/books/new'   
        end
    end


#read
    get '/books/:id' do 
        set_book
        redirect_if_not_authorized
        erb :'/books/show'
    end

    get '/books' do
        
        @books = Book.where(user_id: session[:id])
        erb :'/books/index'
    end



#update
    get '/books/:id/edit' do 
            set_book
            redirect_if_not_authorized
            erb :'/books/edit' 
            
        
    end

    patch '/books/:id' do 
        set_book 
        redirect_if_not_authorized
        if @book.update(title: params[:title], author: params[:author])
            flash[:success] = "Book is successfully updated!"
            redirect "/books/#{@book.id}"
        else
            erb :'/books/edit'
        end


    end



#delete
    delete '/books/:id' do
       set_book
       redirect_if_not_authorized
        @book.delete
        redirect '/books'
    end


    def authorize_book(book)
        current_user == book.user
    end

    def set_book 
        @book = Book.find_by_id(params[:id])
        if @book.nil?
            flash[:error] = "Couldn't find a Post with id: #{params[:id]}"
            redirect "/books"
          end
    end
    def redirect_if_not_authorized
        redirect_if_not_logged_in
        if !authorize_book(@book)
          flash[:error] = "You don't have permission to do that action"
          redirect "/books"
        end
      end

end