require "pry"
require "socket"
require "faraday"


class RequestParsing

  attr_reader :request_hash, 
              :request_lines

  def process_request(client)
    read_request(client)
    request_line_parsing(request_lines)
  end

  def read_request(client)
    @request_lines = []
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    request_lines
  end

  def request_line_parsing(request_lines)
    @request_hash = {}
    request_lines.each_with_index do |line, index|
      if index == 0
        split_line = line.split(" ")
        @request_hash["Verb"] = split_line[0]
        @request_hash["Path"] = split_line[1]
        @request_hash["Protocol"] = split_line[2]
      else
        split_line = line.split(":", 2)
          @request_hash[split_line[0]] = split_line[1].lstrip
      end
    end
    @request_hash
  end
  
end