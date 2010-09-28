From: Stephen Hemminger <shemminger@vyatta.com>
Subject: namespace routines that could be static
Date: Tue, 28 Sep 2010 17:53:21 +0900
Message-ID: <20100928175321.3a39280e@s6510>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got namespace.pl working again, and it showed the following
routines could be declared static.

  fs/btrfs/ctree
    btrfs_clear_path_blocking
    btrfs_insert_some_items
    btrfs_prev_leaf
  fs/btrfs/delayed-ref
    btrfs_delayed_ref_pending
  fs/btrfs/dir-item
    btrfs_match_dir_item_name
  fs/btrfs/disk-io
    btrfs_congested_async
    btrfs_lookup_fs_root
    btrfs_read_fs_root
    write_all_supers
  fs/btrfs/extent-tree
    block_rsv_release_bytes
    btrfs_get_block_group
    btrfs_init_new_buffer
  fs/btrfs/extent_io
    extent_bmap
    extent_commit_write
    extent_prepare_write
    set_range_dirty
    wait_extent_bit
    wait_on_extent_buffer_writeback
    wait_on_extent_writeback
  fs/btrfs/file-item
    btrfs_lookup_csum
  fs/btrfs/free-space-cache
    btrfs_block_group_free_space
  fs/btrfs/inode
    btrfs_orphan_del
    btrfs_writepages
  fs/btrfs/inode-map
    btrfs_find_highest_inode
  fs/btrfs/ioctl
    btrfs_ioctl_space_info
  fs/btrfs/locking
    btrfs_try_tree_lock
  fs/btrfs/print-tree
    btrfs_print_tree
  fs/btrfs/root-tree
    btrfs_search_root
  fs/btrfs/struct-funcs
    btrfs_device_bandwidth
    btrfs_device_group
    btrfs_device_seek_speed
    btrfs_device_start_offset
    btrfs_dir_transid
    btrfs_disk_block_group_chunk_objectid
    btrfs_disk_block_group_flags
    btrfs_disk_root_generation
    btrfs_disk_root_level
    btrfs_file_extent_generation
    btrfs_inode_transid
    btrfs_set_chunk_io_align
    btrfs_set_chunk_io_width
    btrfs_set_chunk_length
    btrfs_set_chunk_num_stripes
    btrfs_set_chunk_owner
    btrfs_set_chunk_sector_size
    btrfs_set_chunk_stripe_len
    btrfs_set_chunk_sub_stripes
    btrfs_set_chunk_type
    btrfs_set_disk_block_group_chunk_objectid
    btrfs_set_disk_block_group_flags
    btrfs_set_disk_block_group_used
    btrfs_set_disk_root_bytenr
    btrfs_set_disk_root_generation
    btrfs_set_disk_root_level
    btrfs_set_disk_root_refs
    btrfs_set_extent_refs_v0
    btrfs_set_ref_generation_v0
    btrfs_set_ref_objectid_v0
    btrfs_set_ref_root_v0
    btrfs_set_stripe_devid
    btrfs_set_stripe_offset
  fs/btrfs/sysfs
    btrfs_sysfs_add_root
    btrfs_sysfs_add_super
    btrfs_sysfs_del_root
    btrfs_sysfs_del_super
  fs/btrfs/tree-log
    btrfs_log_inode_parent
  fs/btrfs/volumes
    btrfs_add_device
    btrfs_alloc_dev_extent
    btrfs_lock_volumes
    btrfs_read_super_device
    btrfs_unlock_volumes
    btrfs_unplug_page
