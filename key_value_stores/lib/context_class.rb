# frozen_string_literal: true

class ContextClass
  attr_accessor :result, :errors

  def initialize(result: {}, errors: [])
    @result = result
    @errors = errors
  end
end
