class Movie < ActiveRecord::Base
    @@MOVIE_RATINGS = {0=>'G', 1=>'PG', 2=>'PG-13', 3=>'R'}
    def self.MOVIE_RATINGS
        return @@MOVIE_RATINGS
    end
end
