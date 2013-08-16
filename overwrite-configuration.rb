# -*- encoding: utf-8 -*-

###### Configuration
BUILD_FILE_PATH = "./build.sbt"

SCALA_VERSON = "2.9.2"
SCALASTYLE_VERSION = "0.3.3-SNAPSHOT"

SCALA_MEJOR_VERSION = "2.9"

DWANGO_ORGANIZATION = "jp.co.dwango"

DWANGO_MAVEN_URL = "http://dwango.github.io/scalastyle"

DWANGO_SCM_URL = "scm:git:git@github.com:dwango/scalastyle.git"
DWANGO_SCM_CONNECTION = "scm:git@github.com:dwango/scalastyle.git"

DWANGO_DEVELOPER_ID = "dwangoinc"
DWANGO_DEVELOPER_URL = "https://github.com/dwango"
DWANGO_DEVELOPER_NAME = "Dwango"

MAVE_OUTPUT_PATH = "./gh-pages" # relative path from project root

# Read bulid configuration
config = open(BUILD_FILE_PATH) do |f|
  f.read
end

if config.index(DWANGO_MAVEN_URL) != nil
  puts "Already modified"
  exit
end

# Delete default resolvers
# config.gsub!(/^resolvers.*\n\n/, "")
# config.gsub!(/^publishTo <<=.*^}\n\n/m, "")
# config.gsub!(/^publishTo.*/, "")

config.gsub!(/"org.scalastyle" %% "scalastyle" % "0.3.2"/, '"' + DWANGO_ORGANIZATION + '" % "scalastyle_' + SCALA_VERSON + '" % "' + SCALASTYLE_VERSION + '"')

# Add our resolver to load dwango scala-style, and set maven output folder
config += '
resolvers += "dwango-maven" at "' + DWANGO_MAVEN_URL + '"

publishTo := Some(Resolver.file("Local", new File("' + MAVE_OUTPUT_PATH + '")) )

scalaVersion := "' + SCALA_VERSON + '"
'

# Change developer's information
my_scm_setting = config.scan(/<scm>.*<\/scm>/m)[0]
my_scm_setting.gsub!(/<url>.*<\/url>/, "<url>" + DWANGO_SCM_URL + "</url>")
my_scm_setting.gsub!(/<connection>.*<\/connection>/, "<url>" + DWANGO_SCM_CONNECTION + "</url>")
config.gsub!(/<scm>.*<\/scm>/m, my_scm_setting)

my_developer_setting = config.scan(/<developer>.*<\/developer>/m)[0]
my_developer_setting.gsub!(/<id>.*<\/id>/, "<id>" + DWANGO_DEVELOPER_ID + "</id>")
my_developer_setting.gsub!(/<name>.*<\/name>/, "<name>" + DWANGO_DEVELOPER_NAME + "</name>")
my_developer_setting.gsub!(/<url>.*<\/url>/, "<url>" + DWANGO_DEVELOPER_URL + "</url>")
config.gsub!(/<developer>.*<\/developer>/m, my_developer_setting)


# Overwrite my configuration
open(BUILD_FILE_PATH, "w").write(config)
