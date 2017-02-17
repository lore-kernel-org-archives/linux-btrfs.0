Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51083 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932674AbdBQMNI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 07:13:08 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs patches for 4.11, part 1
Date: Fri, 17 Feb 2017 13:12:30 +0100
Message-Id: <cover.1487333336.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's the first batch of patches for 4.11, I'd like to get it off my table.
Apart from the few top patches, the rest has been in next. This branch does not
conflict with Filipe's pull.

Good portion of the patches are cleanups, patch-per-change, so the total count
is high. The rest are the usual fixes.

As we don't have intrusive changes queued, I'm still expecting more cleanups
to come and will send 2nd part during the next week.

Thanks.

The following changes since commit 7089db84e356562f8ba737c29e472cc42d530dbc:

  Linux 4.10-rc8 (2017-02-12 13:03:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-part1

for you to fetch changes up to 71367b3fa7f56256029e7ed87862ef13386e1e7e:

  btrfs: use btrfs_debug instead of pr_debug in transaction abort (2017-02-17 12:03:56 +0100)

----------------------------------------------------------------
Anand Jain (3):
      btrfs: use BTRFS_COMPRESS_NONE to specify no compression
      btrfs: btrfs_defrag_root() doesn't defrag extent root tree
      btrfs: consolidate auto defrag kick off policies

Colin Ian King (1):
      btrfs: remove redundant inode null check

David Sterba (46):
      btrfs: remove unused logic of limiting async delalloc pages
      btrfs: add wrapper for counting BTRFS_MAX_EXTENT_SIZE
      btrfs: fix over-80 lines introduced by previous cleanups
      btrfs: remove unused ulist members
      btrfs: use GFP_KERNEL in create_snapshot
      btrfs: use GFP_KERNEL in btrfs_read_qgroup_config
      btrfs: use GFP_KERNEL in btrfs_quota_enable
      btrfs: use GFP_KERNEL in btrfs_add/del_qgroup_relation
      btrfs: make space cache inode readahead failure nonfatal
      btrfs: qgroups: make __del_qgroup_relation static
      btrfs: ulist: make the finalization function public
      btrfs: embed extent_changeset::range_changed to the structure
      btrfs: check quota status earlier and don't do unnecessary frees
      btrfs: remove unnecessary mutex lock in qgroup_account_snapshot
      btrfs: qgroups: opencode qgroup_free helper
      btrfs: remove pointless rcu protection from btrfs_qgroup_inherit
      btrfs: ulist: rename ulist_fini to ulist_release
      btrfs: remove unused parameter from read_block_for_search
      btrfs: remove unused parameter from check_async_write
      btrfs: remove unused parameter from clean_tree_block
      btrfs: remove unused parameter from split_item
      btrfs: remove unused parameter from write_dev_supers
      btrfs: merge two superblock writing helpers
      btrfs: remove unused parameter from __push_leaf_right
      btrfs: remove unused parameter from __push_leaf_left
      btrfs: remove unused parameter from btrfs_subvolume_release_metadata
      btrfs: remove unused parameter from btrfs_prepare_extent_commit
      btrfs: remove unused parameter from btrfs_check_super_valid
      btrfs: remove unused parameter from tree_move_down
      btrfs: remove unused parameter from tree_move_next_or_upnext
      btrfs: remove unused parameter from submit_extent_page
      btrfs: remove unused parameter from update_nr_written
      btrfs: remove unused parameter from add_pending_csums
      btrfs: remove unused parameter from extent_write_cache_pages
      btrfs: remove unused parameter from btrfs_fill_super
      btrfs: remove unused parameter from __btrfs_alloc_chunk
      btrfs: remove unused parameter from init_first_rw_device
      btrfs: remove unused parameter from create_snapshot
      btrfs: remove unused parameters from scrub_setup_wr_ctx
      btrfs: remove unused parameter from __add_inline_refs
      btrfs: remove unused parameters from btrfs_cmp_data
      btrfs: remove unused parameter from clone_copy_inline_extent
      btrfs: remove unused parameter from __add_inode_ref
      btrfs: remove unused parameter from cleanup_write_cache_enospc
      btrfs: remove unused parameters from __btrfs_write_out_cache
      btrfs: remove unused parameter from adjust_slots_upwards

Geliang Tang (1):
      btrfs: use rb_entry() instead of container_of

Jeff Mahoney (8):
      btrfs: drop unused extent_op arg from btrfs_add_delayed_data_ref
      btrfs: allow unlink to exceed subvolume quota
      btrfs: pass fs_info to (more) routines that are only called with extent_root
      btrfs: flush_space always takes fs_info->fs_root
      btrfs: convert btrfs_inc_block_group_ro to accept fs_info
      btrfs: free-space-cache, clean up unnecessary root arguments
      btrfs: btrfs_truncate_free_space_cache always allocates path
      btrfs: use btrfs_debug instead of pr_debug in transaction abort

Liu Bo (16):
      Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly
      Btrfs: fix comment in btrfs_page_mkwrite
      Btrfs: clean up btrfs_ordered_update_i_size
      Btrfs: fix another race between truncate and lockless dio write
      Btrfs: fix wrong argument for btrfs_lookup_ordered_range
      Btrfs: cleanup unused cached_state in __extent_writepage_io
      Btrfs: remove unused trans in read_block_for_search
      Btrfs: pass delayed_refs directly to btrfs_find_delayed_ref_head
      Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist
      Btrfs: create helper for processing bits on contiguous pages
      btrfs: teach __process_pages_contig about PAGE_LOCK operation
      Btrfs: use helper to simplify lock/unlock pages
      Btrfs: try to avoid acquiring free space ctl's lock
      Btrfs: use helper to get used bytes of space_info
      Btrfs: create a helper to create em for IO
      Btrfs: specify a new ordered extent type for create_io_em

Michal Hocko (2):
      btrfs: fix up misleading GFP_NOFS usage in btrfs_releasepage
      btrfs: drop gfp mask tweaking in try_release_extent_state

Nikolay Borisov (36):
      btrfs: Make btrfs_ino take a struct btrfs_inode
      btrfs: Make btrfs_get_delayed_node take btrfs_inode
      btrfs: Make btrfs_get_or_create_delayed_node take btrfs_inode
      btrfs: Make btrfs_delayed_inode_reserve_metadata take btrfs_inode
      btrfs: Make btrfs_insert_delayed_dir_index take btrfs_inode
      btrfs: Make btrfs_delete_delayed_dir_index take btrfs_inode
      btrfs: Make btrfs_delayed_delete_inode_ref take btrfs_inode
      btrfs: Make btrfs_kill_delayed_inode_items take btrfs_inode
      btrfs: Make btrfs_remove_delayed_node take btrfs_inode
      btrfs: Make btrfs_commit_inode_delayed_inode take btrfs_inode
      btrfs: Make btrfs_commit_inode_delayed_items take btrfs_inode
      btrfs: Make btrfs_inode_delayed_dir_index_count take btrfs_inode
      btrfs: Make btrfs_must_commit_transaction take btrfs_inode
      btrfs: Make btrfs_record_unlink_dir take btrfs_inode
      btrfs: Make btrfs_record_snapshot_destroy take btrfs_inode
      btrfs: Make btrfs_inode_in_log take btrfs_inode
      btrfs: Make btrfs_log_new_name take btrfs_inode
      btrfs: Make btrfs_del_dir_entries_in_log take btrfs_inode
      btrfs: Make btrfs_del_inode_ref take btrfs_inode
      btrfs: Make logged_inode_size take btrfs_inode
      btrfs: Make btrfs_check_ref_name_override take btrfs_inode
      btrfs: Make copy_items take btrfs_inode
      btrfs: Make btrfs_log_all_xattrs take btrfs_inode
      btrfs: Make btrfs_log_trailing_hole take btrfs_inode
      btrfs: Make btrfs_get_logged_extents take btrfs_inode
      btrfs: Make btrfs_log_changed_extents take btrfs_inode
      btrfs: Make log_dir_items take btrfs_inode
      btrfs: Make log_directory_changes take btrfs_inode
      btrfs: Make log_new_dir_dentries take btrfs_inode
      btrfs: Make btrfs_unlink_inode take btrfs_inode
      btrfs: Make drop_one_dir_item take btrfs_inode
      btrfs: Make __add_inode_ref take btrfs_inode
      btrfs: Make log_inode_item take btrfs_inode
      btrfs: Make btrfs_log_inode take btrfs_inode
      btrfs: Make count_inode_extrefs take btrfs_inode
      btrfs: Make count_inode_refs take btrfs_inode

Omar Sandoval (2):
      Btrfs: constify struct btrfs_{,disk_}key wherever possible
      Btrfs: refactor btrfs_extent_same() slightly

Qu Wenruo (4):
      btrfs: Add WARN_ON for qgroup reserved underflow
      btrfs: raid56: Remove unused variable in lock_stripe_add
      btrfs: Better csum error message for data csum mismatch
      btrfs: qgroup: Move half of the qgroup accounting time out of commit trans

Seraphime Kirkovski (2):
      Btrfs: code cleanup min/max -> min_t/max_t
      Btrfs: ACCESS_ONCE cleanup

Takafumi Kubota (1):
      Btrfs: add another missing end_page_writeback on submit_extent_page failure

 fs/btrfs/backref.c           |   7 +-
 fs/btrfs/btrfs_inode.h       |  44 ++--
 fs/btrfs/compression.c       |   6 +-
 fs/btrfs/ctree.c             | 128 +++++-----
 fs/btrfs/ctree.h             |  84 ++++---
 fs/btrfs/delayed-inode.c     |  57 +++--
 fs/btrfs/delayed-inode.h     |  16 +-
 fs/btrfs/delayed-ref.c       |  31 ++-
 fs/btrfs/delayed-ref.h       |   6 +-
 fs/btrfs/dir-item.c          |   5 +-
 fs/btrfs/disk-io.c           |  29 +--
 fs/btrfs/disk-io.h           |   6 +-
 fs/btrfs/export.c            |  13 +-
 fs/btrfs/extent-tree.c       | 282 +++++++++++----------
 fs/btrfs/extent_io.c         | 213 ++++++++--------
 fs/btrfs/extent_io.h         |   5 +-
 fs/btrfs/file-item.c         |   8 +-
 fs/btrfs/file.c              |  17 +-
 fs/btrfs/free-space-cache.c  |  65 ++---
 fs/btrfs/free-space-cache.h  |   7 +-
 fs/btrfs/free-space-tree.c   |   2 +-
 fs/btrfs/inode-map.c         |   2 +-
 fs/btrfs/inode.c             | 580 +++++++++++++++++++------------------------
 fs/btrfs/ioctl.c             |  95 +++----
 fs/btrfs/ordered-data.c      |  47 ++--
 fs/btrfs/ordered-data.h      |   4 +-
 fs/btrfs/props.c             |   4 +-
 fs/btrfs/qgroup.c            | 163 +++++++-----
 fs/btrfs/qgroup.h            |  36 ++-
 fs/btrfs/raid56.c            |   2 -
 fs/btrfs/relocation.c        |  25 +-
 fs/btrfs/root-tree.c         |   6 +-
 fs/btrfs/scrub.c             |  12 +-
 fs/btrfs/super.c             |   7 +-
 fs/btrfs/transaction.c       |  58 +++--
 fs/btrfs/tree-log.c          | 299 +++++++++++-----------
 fs/btrfs/tree-log.h          |  14 +-
 fs/btrfs/ulist.c             |  10 +-
 fs/btrfs/ulist.h             |   8 +-
 fs/btrfs/volumes.c           |  18 +-
 fs/btrfs/xattr.c             |  16 +-
 include/trace/events/btrfs.h |   2 +-
 42 files changed, 1199 insertions(+), 1240 deletions(-)
