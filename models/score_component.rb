# frozen_string_literal: true

require 'hashable'

class ScoreComponent
  include Hashable

  attr_reader :type, :score, :weight

  COMPONENT_TYPES = {
    sms: 'Sms',
    email: 'Email',
    cibil: 'Cibil'
  }.freeze

  private

  attr_writer :type, :score, :weight
end
