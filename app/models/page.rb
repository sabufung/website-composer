class Page < ActiveRecord::Base
  belongs_to :template

  def to_s
    "#{id}"
  end
end
