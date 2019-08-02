# frozen_string_literal: true

# example usage:
# requires :test, file_size: { min: 1, max: 10 }

module Grape
  module AdditionalValidators
    class FileSize < Grape::Validations::Base
      def validate_param!(attr_name, params)
        validate_options

        file = params[attr_name][:tempfile]

        check_minimum_size(file)
        check_maximum_size(file)
      end

      private

      def check_minimum_size(file)
        return unless @option[:min].present?
        return if file.size >= @option[:min]

        raise (
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: message(:file_too_small)
        )
      end

      def check_maximum_size(file)
        return unless @option[:max].present?
        return if file.size <= @option[:max]

        raise (
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: message(:file_too_big)
        )
      end

      def validate_options
        raise ArgumentError unless @option.is_a?(Hash)
        raise ArgumentError if @option.keys.size.zero?
      end
    end
  end
end
