# frozen_string_literal: true

# example usage:
# requires :test, valid_when: { rule: ->(params) { params[:test] == 'value' } }
# or:
# requires :test,
#   valid_when: {
#     rules: [
#       ->(params) { params[:other_field] == 'wrong' },
#       ->(params) { params[:test].include?('https') }
#     ],
#     message: 'is invalid'
#   }

module Grape
  module AdditionalValidators
    class ValidWhen < Grape::Validations::Base
      def validate_param!(attr_name, params)
        validate_options

        return if @option[:rule].present? && @option[:rule].call(params)
        return if @option[:rules].present? && @options[:rules].all? do |rule|
          rule.call(params)
        end

        raise(
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: @option[:message] || message(:invalid)
        )
      end

      private

      def validate_options
        raise ArgumentError unless @option.present?
        raise ArgumentError unless @option.is_a?(Hash)
        raise ArgumentError if !@option.keys.include?(:rule) || !@options.keys.include?(:rules)

        rules = @options[:rules] || [@option[:rule]]
        raise ArgumentError if rules.any? { |rule| !rule.is_a?(Proc) }
      end
    end
  end
end
