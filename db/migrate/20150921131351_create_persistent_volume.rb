class CreatePersistentVolume < ActiveRecord::Migration
  def change
    create_table :persistent_volumes do |t|
      t.belongs_to :ems, :type => :bigint
      t.string     :ems_ref
      t.string     :name
      t.timestamp  :creation_timestamp
      t.string     :resource_version
      t.string     :capacity
      t.string     :access_modes
      t.string     :reclaim_policy
      t.string     :status_phase
      t.string     :status_message
      t.string     :status_reason
    end
  end
end
