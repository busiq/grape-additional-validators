# frozen_string_literal: true

# example usage:
# requires :test, allow_blank_if: ->(params) { params[:field] == 'value' }

module Grape
  module AdditionalValidators
    class AllowBlankIf < Grape::Validations::Base
      def validate_param!(attr_name, params)
        raise ArgumentError unless @option.is_a?(Proc)
        return if @option.call(params)
        return if clean_value(attr_name, params).present?

        raise(
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: message(:blank)
        )
      end

      private

      def clean_value(attr_name, params)
        value = params[attr_name]
        value = value.strip if value.respond_to?(:strip)
        value
      end
    end
  end
end
