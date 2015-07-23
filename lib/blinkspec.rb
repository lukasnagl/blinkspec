require 'json'
require 'fileutils'
require 'pry'
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
    #   - +args+ -> rspec specific arguments that should be used separated by whitespace
    # * *Returns* :
    #   - the number of successful, pending and failed results in that order
    def run_specs(args)
      begin
        # indicate that the specs are running
        blink("--glimmer --rgb=#{BlinkColor.running}")

        run_rspec_subprocess(args)
      rescue SystemExit, Interrupt
        # catch keyboard interrupt to remove generated file and cleanly exit
        blink("--blink 1 --rgb=#{BlinkColor.error}")
        return nil,nil,nil
      end

      # handle rspec execution errors
      exit_code = $?.exitstatus
      unless [0, 1].include? exit_code
        blink("--blink 1 --rgb=#{BlinkColor.error}")
        puts "Rspec could not be executed correctly. Exit Code: #{exit_code}"
        return nil,nil,nil
      end

      results
    end

    private

    # Run rspec and listen for errors.
    #
    # * *Args*    :
    #   - +args+ -> rspec specific arguments that should be used separated by whitespace
    # * *Returns* :
    #   - the number of successful, pending and failed results in that order
    def run_rspec_subprocess(args)
      IO.popen("bundle exec rspec #{args} --format documentation --format j --out #{@spec_output_file}").each do |f|
        # listen to running specs and look for errors to report them early
        line = f.chomp
        if line.include? 'FAILED'
          # show an error with blink(1)
          blink("--blink 1 --rgb=#{BlinkColor.fail}")
        end
        puts line
      end
    end

    # Run a blink1 command.
    #
    # * *Args*    :
    #   - +args+ -> arguments passed to blink-1
    #
    # * *Returns* :
    #   - true in case of 0 exit status
    def blink(args)
      system("blink1-tool #{args}")
    end

    # Get a summary of the results of the previous rspec run.
    #
    # * *Returns* :
    #   - the number of successful, pending and failed results in that order
    def results
      # read execution resuls
      file = File.open(@spec_output_file, 'r')
      specresults = file.read
      file.close

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
