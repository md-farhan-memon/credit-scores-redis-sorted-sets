# frozen_string_literal: true

require_relative 'score_component.rb'

class SmsComponent < ScoreComponent
  def initialize
    @type = COMPONENT_TYPES[:sms]
    @weight = 0.25
  end

  def generate_score!
    @score = rand(0..100)
  end
end
