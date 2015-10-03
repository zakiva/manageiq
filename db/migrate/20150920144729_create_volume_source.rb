class CreateVolumeSource < ActiveRecord::Migration
  def change
    create_table :volume_sources do |t|
      # prefixes are used to specify the volume source kind
      # the 'common' prefix is used when an entry is shard by some different kinds
      t.references :resource, :polymorphic => true, :type => :bigint
      t.string     :empty_dir_medium_type
      t.string     :gce_pd_name
      t.string     :git_repository
      t.string     :git_revision
      t.string     :nfs_server
      t.string     :iscsi_target_portal
      t.string     :iscsi_iqn
      t.integer    :iscsi_lun
      t.string     :glusterfs_endpoint_name
      t.string     :claim_name
      t.string     :rbd_ceph_monitors
      t.string     :rbd_image
      t.string     :rbd_pool
      t.string     :rbd_rados_user
      t.string     :rbd_keyring
      t.string     :common_path
      t.string     :common_fs_type
      t.boolean    :common_read_only
      t.string     :common_volume_id
      t.integer    :common_partition
      t.string     :common_secret
    end
  end
end
