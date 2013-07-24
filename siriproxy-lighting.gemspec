# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-lighting"
  s.version     = "0.0.1" 
  s.authors     = ["dl2k84"]
  s.email       = ["dl2k84 * gmail {dot} com (replace * with the at symbol)"]
  s.homepage    = ""
  s.summary     = %q{Lighting home automation via SiriProxy}
  s.description = %q{Turns on/off lights at home using. The maker of the sent byte codes via IR is NEC so you will have to modify the codes if your maker differs. }

  s.rubyforge_project = "siriproxy-lighting"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
