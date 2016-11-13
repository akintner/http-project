require 'socket'

class Parser

  attr_reader :first_lines

  def initialize
    @first_lines = {"Verb" => nil,
                    "Path" => nil,
                    "Protocol" => nil
                    }
    @content = nil
  end
  

  def format_request_lines(request_lines)
    split_lines = request_lines[0].split(' ')
    first_lines["Verb"] = split_lines[0]
    first_lines["Path"] = split_lines[1]
    first_lines["Protocol"] = split_lines[2]
    output_parsed_lines(request_lines)
    request_lines.flatten
  end

  def output_parsed_lines(request_lines)
    first_lines_formatted = first_lines.to_a.map do |line|
      "#{line[0]}: #{line[1]}"
    end
    request_lines[0] = first_lines_formatted
  end

end