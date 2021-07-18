# frozen_string_literal: true

require 'securerandom'
require 'hashable'

Dir['./models/*.rb'].sort.each { |file| require file }

class User
  include Hashable

  attr_reader :id, :name, :credit_score, :score_components

  def initialize(name)
    @id = SecureRandom.uuid
    @name = name
    @credit_score = 0
    @score_components = []
  end

  def generate_credit_score!
    @score_components = generate_score_components

    @credit_score = @score_components.map { |sc| sc.score * sc.weight }.sum
    $score_board[@id] = @credit_score
  end

  def hashified(*attributes)
    if !attributes.empty?
      to_dh.slice(*attributes)
    else
      to_dh
    end
  end

  private

  attr_writer :id, :name, :credit_score, :score_components

  def generate_score_components
    ScoreComponent::COMPONENT_TYPES.values.map do |type|
      type_object = Module.const_get("#{type}Component").new
      type_object.generate_score!
      type_object
    end
  end
end
