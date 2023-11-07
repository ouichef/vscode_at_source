# frozen_string_literal: true

require_relative "vscode_at_source/version"

module VscodeAtSource
  def self.open(object, method_name)
    object = object.new if object.is_a?(Class)

    method = object.method(method_name)
    file, line = method.source_location

    if file && line
      system("code --goto #{file}:#{line}")
    else
      puts "Method not defined in Ruby or file path not accessible."
    end
  end
end
