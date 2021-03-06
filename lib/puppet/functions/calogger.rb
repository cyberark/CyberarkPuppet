# ------------------------------------------------------------------------------------------
#   Copyright (c) 2017 CyberArk Software Inc.
#
#  calogger: Function to initialize CyberArk logger.
# ------------------------------------------------------------------------------------------

require 'logger'

Puppet::Functions.create_function(:'calogger') do 

  def calogger()
    newfunction(:calogger, :type => :rvalue) do |args|

        # Full path to log file. If an empty string is set (""), then logs will be redirected to Puppet builtin logging mechanism.
        fullPathLogFilename = args[0]

        # The log file is flushed if max_size_log_file is reached.
        max_size_log_file = args[1]

        if fullPathLogFilename == ""
            logger = Logger.new(STDOUT)
        else
            if File.file?(fullPathLogFilename)
                # To prevent a huge log file, flush file if above 'max_size_log_file'
                if File.stat(fullPathLogFilename).size > max_size_log_file
                    File.delete(fullPathLogFilename)
                end
            end
            fileHandle = File.open(fullPathLogFilename, "a")
            logger = Logger.new(fileHandle)
        end

        logger.debug("****************************************")
        logger.debug("******** Started CyberArk Logger *******")
        logger.debug("****************************************")
        logger.close
  end

end
