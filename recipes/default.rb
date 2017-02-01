rbenv_ruby "2.3.3" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.3.3"
end

execute "install project gems" do
  command "cd /vagrant && bundle install"
end

execute "prepare database for rails project" do
  command "cd /vagrant && bundle exec rails db:create && bundle exec rails db:migrate"
end

execute "change localhost to 0.0.0.0" do
  command "echo '0.0.0.0 localhost' > /etc/hosts"
end

execute "run project" do
  command "cd /vagrant && bundle exec rails s >/dev/null 2>/dev/null &"
end
