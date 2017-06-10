class Page < ActiveRecord::Base
  belongs_to :templates

  def to_s
    "#{id}"
  end
end
