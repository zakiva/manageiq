class ContainerVolume < ActiveRecord::Base
  belongs_to :container_group
  has_one :volume_source, :as => :resource, :dependent => :destroy
end
