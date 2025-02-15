# typed: true
# frozen_string_literal: true

require "tapioca"
require "tapioca/internal"

desc("Updates the README file")
task :readme do
  def assert_synchronized(path)
    # Do not print diff and yield whether exit code was zero
    sh("test -z \"$(git status --porcelain #{path})\"") do |outcome, _|
      return if outcome

      # Output diff before raising error
      sh("git status --porcelain #{path}")

      warn(<<~WARNING)
        The `#{path}` is out of sync.
        Run `bin/readme` and commit the results.
      WARNING

      exit!
    end
  end

  def skip_command?(command)
    command.hidden? || command.name.start_with?("__") || command.name == "init"
  end

  def skip_option?(option)
    option.name == "auth"
  end

  def option_value(option)
    fallback_value = case option.type
    when :boolean
      true
    when :numeric
      1
    when :hash
      {}
    when :array
      []
    when :string
      ""
    end

    if option.default.nil?
      fallback_value
    else
      option.default
    end
  end

  def command_options(command)
    command.options.map do |name, opt|
      next if skip_option?(opt)

      [name.to_s, option_value(opt)]
    end.compact.to_h
  end

  def config
    Tapioca::Cli.commands.map do |command_name, command|
      next if skip_command?(command)

      [command_name, command_options(command)]
    end.compact.to_h
  end

  def replace_section(contents, section_name, replacement)
    contents.sub(
      /(<!-- START_#{section_name} -->).+(<!-- END_#{section_name} -->)/m, <<~OUT.chomp
        \\1
        #{replacement.chomp}
        \\2
      OUT
    )
  end

  def print_config_template(contents)
    replace_section(contents, "CONFIG_TEMPLATE", <<~MARKDOWN)
      ```yaml
      #{config.to_yaml.chomp}
      ```
    MARKDOWN
  end

  class FakeShell < Thor::Shell::Basic
    DEFAULT_TERMINAL_WIDTH = 120

    def stdout
      @stdout ||= StringIO.new
    end

    def contents
      stdout.string
    end

    def clear
      @stdout = StringIO.new
      self
    end

    def terminal_width
      DEFAULT_TERMINAL_WIDTH
    end
  end

  def print_help(contents)
    shell = FakeShell.new

    $PROGRAM_NAME = "tapioca"
    section = "HELP"

    Tapioca::Cli.help(shell.clear)

    contents = replace_section(contents, section, <<~MARKDOWN)
      ```shell
      $ #{$PROGRAM_NAME} help

      #{shell.contents.chomp}
      ```
    MARKDOWN

    contents
  end

  def print_commands_help(contents)
    shell = FakeShell.new

    Tapioca::Cli.commands.each_key do |command_name|
      $PROGRAM_NAME = "tapioca"
      section = "HELP_COMMAND_#{command_name.upcase}"

      Tapioca::Cli.command_help(shell.clear, command_name)

      contents = replace_section(contents, section, <<~MARKDOWN)
        ```shell
        $ #{$PROGRAM_NAME} help #{command_name}

        #{shell.contents.chomp}
        ```
      MARKDOWN
    end

    contents
  end

  path = "#{Dir.pwd}/README.md"

  contents = File.read(path)
  contents = print_config_template(contents)
  contents = print_help(contents)
  contents = print_commands_help(contents)
  File.write(path, contents)

  assert_synchronized(path) if ENV["CI"] == "true"
end
