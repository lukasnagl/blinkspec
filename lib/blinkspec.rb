require 'json'
require 'fileutils'
require_relative 'blinkcolor'

# Run rspec with support of a blink(1)
module BlinkSpec
  class BlinkSpecRunner
    attr_accessor :spec_output_file

    def initialize
      @spec_output_file = 'blinkspec.json'
    end

    # Run rspec and indicate progress with blink(1).
    #
    # * *Args*    :
    #   - +rspec_args+ -> rspec specific arguments that should be used separated by whitespace
    # * *Returns* :
    #   - the number of successful, pending and failed results in that order
    def run_specs(args)
      begin
        # indicate that the specs are running
        system("blink1-tool --glimmer --rgb=#{BlinkColor.running}")

        IO.popen("bundle exec rspec #{args} --color --format documentation --format j --out #{@spec_output_file}").each do |f|
          # listen to running specs and look for errors to report them early
          line = f.chomp
          if line.include? 'FAILED'
            # show an error with blink(1)
            system("blink1-tool --blink 1 --rgb=#{BlinkColor.fail}")
          end
          puts line
        end
      rescue SystemExit, Interrupt
        # catch keyboard interrupt to remove generated file and cleanly exit
        FileUtils.rm(@spec_output_file)
        system("blink1-tool --blink 1 --rgb=#{BlinkColor.error}")
        exit 1
      end

      # handle rspec execution errors
      unless [0, 1].include? $?.exitstatus
        system("blink1-tool --blink 1 --rgb=#{BlinkColor.error}")
        puts "Could not run specs: #{specresults}"
        exit 1
      end

      results
    end

    private

    # Get a summary of the results of the previous rspec run.
    #
    # * *Returns* :
    #   - the number of successful, pending and failed results in that order
    def results
      # read execution resuls
      file = File.open(@spec_output_file, 'r')
      specresults = file.read
      file.close
      FileUtils.rm(@spec_output_file)

      # fetch example results
      # and cut eventual stdout output after json
      specresults = specresults[0..(specresults.rindex("\}"))]
      jsonresults = JSON.parse(specresults, symbolize_names: true)

      # get summary
      example_count = jsonresults[:summary][:example_count] || 0
      pending_count = jsonresults[:summary][:pending_count] || 0
      failure_count = jsonresults[:summary][:failure_count] || 0
      success_count = example_count - pending_count - failure_count
      return success_count, pending_count, failure_count
    end
  end
end
