Rails.application.routes.draw do
  post 'comunication', to: 'comunication#run_commands'
end
