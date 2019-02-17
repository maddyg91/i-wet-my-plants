class Plant < ApplicationRecord
  validates_presence_of :name, :species, :frequency
  belongs_to :garden

  def hours_since_watered
    ((Time.now - last_watered) / 3600).round
  end

  def hours_until_watering
    ((last_watered + frequency * 60.0 * 60 - Time.now) / 3600).round
  end

  def water_plant
    self.update!(last_watered: Time.now)
  end
end
