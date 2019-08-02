# frozen_string_literal: true

# example usage:
# requires :test, exclusion: ['a', 'b']

module Grape
  module AdditionalValidators
    class Exclusion < Grape::Validations::Base
      def validate_param!(attr_name, params)
        validate_options

        return unless @option.include?(params[attr_name])

        raise (
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: message(:not_allowed_value)
        )
      end

      private

      def validate_options
        raise ArgumentError if @option.blank?
        raise ArgumentError unless @option.is_a?(Array)
      end
    end
  end
end
