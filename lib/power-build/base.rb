require 'thor'
require 'colorize'

module PowerBuild
  class Base < Thor
    default_task :build
    desc "build", "Generates a static site. Old files will be overwritten."
    def build 
      
    end

    desc "init", "Start with a config file. Continue with 'power build' if you have nothing to change."
    def init
      
    end

    desc "clean", "Remove all files generated by Power Build"
    def clean
      
    end

    desc "config", "Open the config file for you if you're this lazy"
    def config
      
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "show version"
    def __print_version
      puts PowerBuild::VERSION
    end
  end
end
