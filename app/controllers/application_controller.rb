require "pry"

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  # NOTE: New 'delete' route:
  delete "/reviews/:id" do 
    # Find the review using the ID
    review = Review.find(params[:id])
    # Delete the review
    review.destroy()
    # Send a response with the deleted review as JSON
    review.to_json()
  end

  # NOTE: 
  # This handles the 'post' route to create a new route when a user on the
  # front end of the application decides to pass in parameters to create a
  # new review:
  post "/reviews" do
    # NOTE: This was commented out since we only needed to see how we
    # could utilize the given parameters accordingly:
    # binding.pry()
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )
    review.to_json()
  end

  # NOTE;
  # This handles the 'patch' route in case a user wants to update a specific review:
  # NOTE: The assignment doesn't really mention this but they really only want to
  # update the ':comment' and ':score' symbols in this scenario for the 'patch'
  # request:
  patch "/reviews/:id" do 
    review = Review.find(params[:id])
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    review.to_json()
  end

end
