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
class AlmHelper
  def initialize
    @head = /^alm:.*/
  end

  def is_alm?(str)
    (str =~ @head) != nil
  end

  def alm_to_proto(str)
    Rails.logger.info "str == #{str}, is_alm? == #{is_alm?(str)}, head=#{@head.to_s}"
    return "" if !is_alm?(str)
    str
  end

  def trim(str)
    return str.strip unless str == nil
    return nil
  end

  def parse_args(args)
    alm = trim(args[0])
    label = trim(args[1]) || alm

    return alm, label
  end

  def get_tag(args)
    return "(No parameters are specified. An ALMplus URI is needed at least.)" if args.empty?
    alm, label = parse_args(args)

    return <<TEMPLATE
<a href=\"#{alm_to_proto(alm)}\">#{label}</a>
TEMPLATE
  end

end

Redmine::Plugin.register :redmine_wiki_helper do
  name 'Redmine Wiki Helper Plugin'
  author 'Philip Lapczynski'
  description 'This is a plugin for extending Redmine macro syntax'
  version '1.0.0'

  Redmine::WikiFormatting::Macros.register do
    desc <<DESC
Makes a link to project database path.
How to use:
1) without a label: {{pdb(ID)}}
2) with a label:    {{pdb(ID, Description)}}

Makes a link to ALMplus URIs.
How to use:
1) without a label: {{alm(ALMplus Link)}}
2) with a label:    {{alm(ALMplus Link, Description)}}
DESC

    macro :pdb do |obj, args|
      h = PdbHelper.new
      h.get_tag(args).html_safe
    end

    macro :alm do |obj, args|
      h = AlmHelper.new
      h.get_tag(args).html_safe
    end
  end
end
