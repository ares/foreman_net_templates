module ForemanNetTemplates
  module RendererExtensions
    extend ActiveSupport::Concern

    # create or overwrite instance methods...
    def build_network_config_files
      config_file = Tempfile.new(['foreman_net_template_config', '.json'])
      config_file.write(@host.os_net_config_json)
      config_file.close
      result = `os-net-config --noop --config-file=#{config_file.to_path} --no-activate --provider #{get_provider(@host)}`
      config_file.unlink

      files = parse_os_net_config_result(result)
      files.map { |path, content| wrap_in_cat(path, content.join("\n")) }.join("\n\n")
    end

    private

    def get_provider(host)
      case host.operatingsystem.family.downcase
        when 'debian'
          'eni'
        else
          'ifcfg'
      end
    end

    def parse_os_net_config_result(result)
      files = Hash.new { |h,k| h[k] = [] }
      file = nil

      result.split("\n").each do |line|
        if (match_data = line.match(/File: (.+)/))
          file = match_data[1]
        elsif line == '----' || line.empty?
          next
        else
          files[file] << line
        end
      end

      files
    end

    def wrap_in_cat(target_path, content)
      "cat > #{target_path} <<EOF
#{content}
EOF"
    end
  end
end
