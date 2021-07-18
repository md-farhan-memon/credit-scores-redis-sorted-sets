# frozen_string_literal: true

require_relative 'score_component.rb'

class CibilComponent < ScoreComponent
  def initialize
    @type = COMPONENT_TYPES[:cibil]
    @weight = 0.45
  end

  def generate_score!
    @score = rand(0..100)
  end
end
