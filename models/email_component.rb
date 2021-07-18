# frozen_string_literal: true

require_relative 'score_component.rb'

class EmailComponent < ScoreComponent
  def initialize
    @type = COMPONENT_TYPES[:email]
    @weight = 0.3
  end

  def generate_score!
    @score = rand(0..100)
  end
end
