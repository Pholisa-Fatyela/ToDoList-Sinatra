require 'sinatra'
require 'data_mapper'


# DataMapper.setup(:default, "sqlite://#{Dir.pwd}/tasks.db")
DataMapper.setup(:default, 'postgres://pholisafatyela:pg123@localhost/tasks')


class Task
  include DataMapper::Resource
  property :id, Serial
  property :content, String
  property :complete, Boolean, :default  => false
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @tasks = Task.all
  @tasks_complete = Task.all(:complete => true)
  @tasks_incomplete = Task.all(:complete => false)
  erb :index, layout: :main_layout
end

post '/' do
  Task.create(params)
  redirect '/'
end

post '/complete/:id' do
  t = Task.get params[:id]
  t.complete = t.complete ? false : true
  t.save
  redirect '/'
end

delete '/delete/:id' do
  t = Task.get params[:id]
  t.destroy
  redirect '/'
end

put '/edit/:id' do
  t = Task.get params[:id]
  t.content = params[:content]
  t.save
  redirect '/'
end
