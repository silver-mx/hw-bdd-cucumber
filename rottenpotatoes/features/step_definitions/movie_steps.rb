# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.new(movie).save
  end
  
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  tr_items = all('tr')
  tr_first = page.first('tr', {:text => e1.gsub(/"/, '')})
  expect(tr_first.first('td')).to have_content(e1)
  tr_second = tr_items[tr_items.index(tr_first) + 1]
  expect(tr_second.first('td')).to have_content(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  list = rating_list.split(',')
  list.each do |rating|
    if uncheck
      step "I uncheck \"ratings_#{rating.strip}\""
    else
      step "I check \"ratings_#{rating.strip}\""
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step "I should see \"#{movie.title}\""
  end
end

Then /I do expect seeing the movies: (.*)/ do |movie_titles_list|
  titles = movie_titles_list.split(',')
  titles.each do |title|
    step "I should see #{title.strip}"
  end
end

Then /I do not expect seeing the movies: (.*)/ do |movie_titles_list|
  titles = movie_titles_list.split(',')
  titles.each do |title|
    step "I should not see #{title.strip}"
  end
end

When /^I click (.*)/ do |button|
  step "I press \"ratings_#{button}\""
end
