require 'thor'
require 'colorize'
require 'power-build/constructor'
require 'power-build/github_manager'

module PowerBuild
  class Base < Thor
    desc "build, b", "Generates a static site. Existing files will be overwritten."
    map %w[b] => :build
    default_task :build
    def build 
      config_exists?
      image_root_folder_exists?
      Constructor.new.copy_assets
      Constructor.new(:config).generate_site
      puts "Done!"
    end

    desc "init, i", "Start with a config file."
    map %w[i] => :init
    def init
      config_already_exists?
      in_power_build_project?
      Constructor.new.build_config
    end

    desc "delete, d", "Remove all files generated by Power Build"
    map %w[d] => :delete
    def delete
      Constructor.new.remove_config
    end

    desc "config, open, o", "Open the config file for you if you're this lazy"
    map %w[open, o] => :config
    def config
      Constructor.new.open_config
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "show version"
    def __print_version
      puts PowerBuild::VERSION
    end

    # desc "push, p", "Push to GitHub"
    # map %w[push, p] => :push
    # def push
    #   GitHubManager.new.checkout_branch
    # end

    private
      def in_power_build_project?
        count = Dir.pwd.count("/") - 1
        find_config = false
        for i in 0..count do
          find_config = true if File.file?("../" * i + "power-build.config")
        end
        if find_config
          puts "Already in a power-build project."
          abort
        end
      end

      def config_exists?
        unless File.file? "power-build.config"
          puts "No config file found. Run 'power init' first."
          abort
        end
      end

      def config_already_exists?
        if File.file? "power-build.config"
          puts "Config file already exists. Either:"
          puts "1. Run 'power build' to build."
          puts "2. Run 'power delete' to delete all."
          abort
        end
      end

      def image_root_folder_exists?
        config = Helper.read_config 
        folder = config["root_folder"]
        unless File.directory? folder
          puts "Image folder '#{folder}' not found." 
          abort
        end
      end
  end
end
