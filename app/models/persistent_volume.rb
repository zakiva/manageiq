class PersistentVolume < ActiveRecord::Base
  belongs_to :ext_management_system, :foreign_key => "ems_id"
  has_one :volume_source, :as => :resource, :dependent => :destroy
end
