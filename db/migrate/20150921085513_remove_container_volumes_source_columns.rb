class RemoveContainerVolumesSourceColumns < ActiveRecord::Migration
  def change
    remove_column :container_volumes, :empty_dir_medium_type, :string
    remove_column :container_volumes, :gce_pd_name, :string
    remove_column :container_volumes, :git_repository, :string
    remove_column :container_volumes, :git_revision, :string
    remove_column :container_volumes, :nfs_server, :string
    remove_column :container_volumes, :iscsi_target_portal, :string
    remove_column :container_volumes, :iscsi_iqn, :string
    remove_column :container_volumes, :iscsi_lun, :integer
    remove_column :container_volumes, :glusterfs_endpoint_name, :string
    remove_column :container_volumes, :claim_name, :string
    remove_column :container_volumes, :rbd_ceph_monitors, :string
    remove_column :container_volumes, :rbd_image, :string
    remove_column :container_volumes, :rbd_pool, :string
    remove_column :container_volumes, :rbd_rados_user, :string
    remove_column :container_volumes, :rbd_keyring, :string
    remove_column :container_volumes, :common_path, :string
    remove_column :container_volumes, :common_fs_type, :string
    remove_column :container_volumes, :common_read_only, :string
    remove_column :container_volumes, :common_volume_id, :string
    remove_column :container_volumes, :common_partition, :string
    remove_column :container_volumes, :common_secret, :string
  end
end
