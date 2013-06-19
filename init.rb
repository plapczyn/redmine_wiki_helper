require 'redmine'

class PdbHelper
  def initialize
    @head = /^[0-9]{10}/
  end

  def is_pdb?(str)
    (str =~ @head) != nil
  end

  def pdb_to_proto(str)
    Rails.logger.info "str == #{str}, is_pdb? == #{is_pdb?(str)}, head=#{@head.to_s}"
    return "" if !is_pdb?(str)
    "pdb://" + str
  end

  def trim(str)
    return str.strip unless str == nil
    return nil
  end

  def parse_args(args)
    pdb = trim(args[0])
    label = trim(args[1]) || pdb

    return pdb, label
  end

  def get_tag(args)
    return "(No parameters are specified. A project database ID is needed at least.)" if args.empty?
    pdb, label = parse_args(args)

    return <<TEMPLATE
<a href=\"#{pdb_to_proto(pdb)}\">#{label}</a>
TEMPLATE
  end

end

Redmine::Plugin.register :redmine_wiki_pdb do
  name 'Redmine Wiki Pdb plugin'
  author 'Philip Lapczynski'
  description 'This is a plugin for macro of Redmine Wiki'
  version '0.0.1'

  Redmine::WikiFormatting::Macros.register do
    desc <<DESC
Makes a link to project database path.
How to use:
1) without a label: {{pdb(ID)}}
2) with a label:    {{pdb(ID, Description)}}
DESC

    macro :pdb do |obj, args|
      h = PdbHelper.new
      h.get_tag(args).html_safe
    end
  end
end
