require "rails_helper"

describe 'as a registered user' do
  it 'can water all plants plant', :vcr do
    yesterday = 1.day.ago
    two_days_ago = 2.days.ago
    user_1 = create(:user)
    garden = create(:garden, user: user_1)
    plant_1 = create(:plant, garden: garden, frequency: 24, last_watered: yesterday)
    plant_2 = create(:plant, garden: garden, frequency: 12, last_watered: yesterday)
    plant_3 = create(:plant, garden: garden, frequency: 18, last_watered: two_days_ago)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

    visit '/plants'

    click_on "Water All Plants"

    expect(current_path).to eq(plants_path)
    within "#plant-#{plant_1.id}" do
      plant = Plant.find(plant_1.id)
      expect(plant.hours_until_watering).to eq(24)
      expect(plant.hours_since_watered).to eq(0)
      expect(page).to have_content(plant.hours_until_watering)
    end
    within "#plant-#{plant_2.id}" do
      plant = Plant.find(plant_2.id)
      expect(plant.hours_until_watering).to eq(12)
      expect(plant.hours_since_watered).to eq(0)
      expect(page).to have_content(plant.hours_until_watering)
    end
    within "#plant-#{plant_3.id}" do
      plant = Plant.find(plant_3.id)
      expect(plant.hours_until_watering).to eq(18)
      expect(plant.hours_since_watered).to eq(0)
      expect(page).to have_content(plant.hours_until_watering)
    end
  end
end
