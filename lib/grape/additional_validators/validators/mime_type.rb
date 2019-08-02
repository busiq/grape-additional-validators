# frozen_string_literal: true

# example usage:
# requires :test, mime_type: ['image/png', 'application/pdf']

module Grape
  module AdditionalValidators
    class MimeType < Grape::Validations::Base
      def validate_param!(attr_name, params)
        validate_options

        file = params[attr_name][:tempfile]

        return if @option.include?(file_mime_type(file))

        raise (
          Grape::Exceptions::Validation,
          params: [@scope.full_name(attr_name)],
          message: message(:invalid_mime_type)
        )
      end

      private

      def validate_options
        raise ArgumentError if @option.blank?
        raise ArgumentError unless @option.is_a?(Array)
      end

      def file_mime_type(file)
        `file --mime -b #{file.path}`.split(';').first
      end
    end
  end
end
