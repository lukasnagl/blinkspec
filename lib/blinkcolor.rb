module BlinkSpec
  # Wrap color definitions
  class BlinkColor
    def self.fail
      '255,135,198'
    end

    def self.success
      '0,255,0'
    end

    def self.pending
      '255,255,0'
    end

    def self.running
      '255,255,255'
    end

    def self.error
      '0,0,255'
    end
  end
end
