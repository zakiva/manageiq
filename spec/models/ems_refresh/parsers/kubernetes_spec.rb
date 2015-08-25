require "spec_helper"
require 'recursive-open-struct'

describe ManageIQ::Providers::Kubernetes::ContainerManager::RefreshParser do
  let(:parser)  { described_class.new }

  describe "parse_image_name" do
    example_ref = "docker://abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    example_images = [{:image_name => "example",
                       :image      => {:name => "example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "example:tag",
                       :image      => {:name => "example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "user/example",
                       :image      => {:name => "user/example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "user/example:tag",
                       :image      => {:name => "user/example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "example/subname/example",
                       :image      => {:name => "example/subname/example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "example/subname/example:tag",
                       :image      => {:name => "example/subname/example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => nil},

                      {:image_name => "host:1234/subname/example",
                       :image      => {:name => "subname/example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host", :host => "host", :port => "1234"}},

                      {:image_name => "host:1234/subname/example:tag",
                       :image      => {:name => "subname/example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host", :host => "host", :port => "1234"}},

                      {:image_name => "host.com:1234/subname/example",
                       :image      => {:name => "subname/example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host.com", :host => "host.com", :port => "1234"}},

                      {:image_name => "host.com:1234/subname/example:tag",
                       :image      => {:name => "subname/example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host.com", :host => "host.com", :port => "1234"}},

                      {:image_name => "host.com/subname/example",
                       :image      => {:name => "subname/example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host.com", :host => "host.com", :port => nil}},

                      {:image_name => "host.com/example",
                       :image      => {:name => "example", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host.com", :host => "host.com", :port => nil}},

                      {:image_name => "host.com:1234/subname/more/names/example:tag",
                       :image      => {:name => "subname/more/names/example", :tag => "tag", :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "host.com", :host => "host.com", :port => "1234"}},

                      {:image_name => "localhost:1234/name",
                       :image      => {:name => "name", :tag => nil, :digest => nil,
                                       :image_ref => example_ref},
                       :registry   => {:name => "localhost", :host => "localhost", :port => "1234"}},

                      {:image_name => "localhost:1234/name@sha256:1234567abcdefg",
                       :image      => {:name => "name", :tag => nil, :digest => "sha256:1234567abcdefg",
                                       :image_ref => example_ref},
                       :registry   => {:name => "localhost", :host => "localhost", :port => "1234"}},

                      {:image_name => "example@sha256:1234567abcdefg",
                       :image      => {:name => "example", :tag => nil, :digest => "sha256:1234567abcdefg",
                                       :image_ref => example_ref},
                       :registry   => nil}]

    example_images.each do |ex|
      it "tests '#{ex[:image_name]}'" do
        result_image, result_registry = parser.send(:parse_image_name, ex[:image_name], example_ref)

        result_image.should == ex[:image]
        result_registry.should == ex[:registry]
      end
    end
  end

  describe "parse_volumes" do
    example_volumes = [
        {
            :volume => RecursiveOpenStruct.new(
                :name => "example-volume1",
                :gitRepo => {:repository => "default-git-repository"}),
            :name => "example-volume1",
            :git_repository => "default-git-repository",
            :empty_dir_medium_type => nil,
            :gce_pd_name => nil,
            :common_fs_type => nil
        },
        {
            :volume => RecursiveOpenStruct.new(
                :name => "example-volume2",
                :emptyDir => {:medium => "default-medium"}),
            :name => "example-volume2",
            :git_repository => nil,
            :empty_dir_medium_type => "default-medium",
            :gce_pd_name => nil,
            :common_fs_type        => nil
        },
        {
            :volume => RecursiveOpenStruct.new(
                :name => "example-volume3",
                :gcePersistentDisk => {:pdName => "example-pd-name",
                                       :fsType => "default-fs-type"}),
            :name => "example-volume3",
            :git_repository => nil,
            :empty_dir_medium_type => nil,
            :gce_pd_name => "example-pd-name",
            :common_fs_type        => "default-fs-type"
        },
        {
            :volume => RecursiveOpenStruct.new(
                :name => "example-volume4",
                :awsElasticBlockStore => {:fsType => "example-fs-type"}),
            :name => "example-volume4",
            :git_repository => nil,
            :empty_dir_medium_type => nil,
            :gce_pd_name => nil,
            :common_fs_type        => "example-fs-type"
        }
    ]
    
    it "tests example volumes" do
      parsed_volumes = parser.send(:parse_volumes, example_volumes.collect do |ex| ex[:volume] end)

      example_volumes.zip(parsed_volumes).each do |example, parsed|
        parsed[:name].should == example[:name]
        parsed[:git_repository].should == example[:git_repository]
        parsed[:empty_dir_medium_type].should == example[:empty_dir_medium_type]
        parsed[:gce_pd_name].should == example[:gce_pd_name]
        parsed[:common_fs_type].should == example[:common_fs_type]
      end
    end
  end
end
