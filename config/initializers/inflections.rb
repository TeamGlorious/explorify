# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

# this is literally the hackiest thing ever invented!  
# I broke the rails pluralization rules when I made a singular model with a plural name!
# the plural of media is media
# the singular of media is medium
# there is no such thing as medias... until now!

ActiveSupport::Inflector.inflections do |inflect|
  # inflect.irregular 'medium', 'media'
  # inflect.irregular 'media', 'medias'
    inflect.uncountable "media"
end

#medium - tecnically singular
# media - technically plural

#media - singular
#medias - plural
