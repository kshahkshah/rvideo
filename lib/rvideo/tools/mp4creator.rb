module RVideo
  module Tools
    class Mp4creator
      include AbstractTool::InstanceMethods

      attr_reader :raw_metadata

      def tool_command
        'mp4creator'
      end

      def original_fps
        inspect_original if @original.nil?
        if @original.fps
          "-rate=#{@original.fps}" 
        else
          ""
        end
      end

      def parse_result(result)
        if m = /can't open file/.match(result)
          raise TranscoderError::InvalidFile, "I/O error"
        end
        
        if m = /unknown file type/.match(result)
          raise TranscoderError::InvalidFile, "I/O error"
        end
        
        @raw_metadata = result.empty? ? "No Results" : result
        return true
      end

    end
  end
end
