# frozen_string_literal: true

# example usage:
# requires :test, length: { min: 1, max: 10 }

module Grape
  module AdditionalValidators
    class Lenght < Grape::Validations::Base
      def validate_param!(attr_name, params)
        return if params[attr_name].blank?

        check_minimum_length(attr_name, params)
        check_maximum_length(attr_name, params)
      end

      private

      def options
        @options ||= {
          min: -1,
          max: nil
        }.merge(@option)
      end

      def check_minimum_length(attr_name, params)
        return if params[attr_name].length >= options[:min]

        raise(
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: "should be longer or equal #{options[:min]}"
        )
      end

      def check_maximum_length(attr_name, params)
        return if !options[:max] || params[attr_name].length <= options[:max]

        raise(
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: "length should be less or equal #{options[:max]}"
        )
      end
    end
  end
end
