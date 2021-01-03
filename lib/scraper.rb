require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    page = Nokogiri::HTML(html)
    students = []
    page.css("div.student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    
    page = Nokogiri::HTML(open(profile_url))
    
    student_page = {}
    
    student_links = page.css(".social-icon-container").css('a').collect {|i| i.attributes["href"].value}
    
    student_links.detect do |i|
      student_page[:twitter] = i if i.include?("twitter")
      student_page[:linkedin] = i if i.include?("linkedin")
      student_page[:github] = i if i.include?("github")
    end
    
    student_page[:blog] = student_links[3] if student_links[3] != nil
    student_page[:profile_quote] = page.css(".profile-quote")[0].text
    student_page[:bio] = page.css(".description-holder").css('p')[0].text
    student_page
  
  end

end

