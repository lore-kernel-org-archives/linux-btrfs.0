Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48609 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751500AbdBYA4U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 19:56:20 -0500
Date: Fri, 24 Feb 2017 19:56:09 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170225005608.GA32585@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.11 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

Has a series of fixes and cleanups that Dave Sterba has been collecting:

There is a pretty big variety here, cleaning up internal APIs and fixing 
corner cases.

David Sterba (46) commits (+235/-313):
     btrfs: remove unused parameter from btrfs_subvolume_release_metadata (+6/-11)
     btrfs: remove pointless rcu protection from btrfs_qgroup_inherit (+0/-2)
     btrfs: check quota status earlier and don't do unnecessary frees (+3/-2)
     btrfs: remove unused parameter from btrfs_prepare_extent_commit (+3/-5)
     btrfs: remove unnecessary mutex lock in qgroup_account_snapshot (+1/-5)
     btrfs: embed extent_changeset::range_changed to the structure (+11/-17)
     btrfs: remove unused parameter from cleanup_write_cache_enospc (+2/-3)
     btrfs: remove unused parameters from __btrfs_write_out_cache (+3/-8)
     btrfs: remove unused parameter from clone_copy_inline_extent (+2/-3)
     btrfs: remove unused parameter from extent_write_cache_pages (+2/-4)
     btrfs: remove unused parameter from tree_move_next_or_upnext (+2/-4)
     btrfs: remove unused parameter from btrfs_check_super_valid (+3/-5)
     btrfs: remove unused logic of limiting async delalloc pages (+0/-7)
     btrfs: fix over-80 lines introduced by previous cleanups (+74/-63)
     btrfs: remove unused parameter from read_block_for_search (+5/-5)
     btrfs: remove unused parameter from adjust_slots_upwards (+2/-3)
     btrfs: remove unused parameter from init_first_rw_device (+3/-5)
     btrfs: make space cache inode readahead failure nonfatal (+3/-7)
     btrfs: remove unused parameters from scrub_setup_wr_ctx (+3/-7)
     btrfs: remove unused parameter from __btrfs_alloc_chunk (+4/-6)
     btrfs: add wrapper for counting BTRFS_MAX_EXTENT_SIZE (+23/-31)
     btrfs: remove unused parameter from submit_extent_page (+3/-9)
     btrfs: remove unused parameter from clean_tree_block (+17/-19)
     btrfs: use GFP_KERNEL in btrfs_add/del_qgroup_relation (+2/-2)
     btrfs: remove unused parameter from __add_inline_refs (+2/-3)
     btrfs: remove unused parameter from add_pending_csums (+2/-4)
     btrfs: remove unused parameter from update_nr_written (+4/-4)
     btrfs: remove unused parameter from __push_leaf_right (+2/-3)
     btrfs: remove unused parameter from check_async_write (+2/-2)
     btrfs: remove unused parameter from btrfs_fill_super (+2/-3)
     btrfs: remove unused parameter from __push_leaf_left (+2/-3)
     btrfs: remove unused parameter from write_dev_supers (+3/-3)
     btrfs: remove unused parameter from __add_inode_ref (+1/-2)
     btrfs: remove unused parameters from btrfs_cmp_data (+2/-3)
     btrfs: remove unused parameter from create_snapshot (+2/-2)
     btrfs: ulist: make the finalization function public (+2/-1)
     btrfs: remove unused parameter from tree_move_down (+2/-2)
     btrfs: ulist: rename ulist_fini to ulist_release (+10/-10)
     btrfs: qgroups: make __del_qgroup_relation static (+1/-1)
     btrfs: use GFP_KERNEL in btrfs_read_qgroup_config (+1/-1)
     btrfs: remove unused parameter from split_item (+2/-3)
     btrfs: merge two superblock writing helpers (+4/-11)
     btrfs: qgroups: opencode qgroup_free helper (+9/-9)
     btrfs: use GFP_KERNEL in btrfs_quota_enable (+1/-1)
     btrfs: use GFP_KERNEL in create_snapshot (+2/-2)
     btrfs: remove unused ulist members (+0/-7)

Nikolay Borisov (36) commits (+476/-480):
     btrfs: Make btrfs_delayed_inode_reserve_metadata take btrfs_inode (+8/-8)
     btrfs: Make btrfs_inode_delayed_dir_index_count take btrfs_inode (+5/-5)
     btrfs: Make btrfs_commit_inode_delayed_items take btrfs_inode (+4/-4)
     btrfs: Make btrfs_commit_inode_delayed_inode take btrfs_inode (+6/-6)
     btrfs: Make btrfs_get_or_create_delayed_node take btrfs_inode (+5/-6)
     btrfs: Make btrfs_kill_delayed_inode_items take btrfs_inode (+4/-4)
     btrfs: Make btrfs_delayed_delete_inode_ref take btrfs_inode (+5/-5)
     btrfs: Make btrfs_delete_delayed_dir_index take btrfs_inode (+6/-6)
     btrfs: Make btrfs_insert_delayed_dir_index take btrfs_inode (+5/-5)
     btrfs: Make btrfs_check_ref_name_override take btrfs_inode (+4/-5)
     btrfs: Make btrfs_record_snapshot_destroy take btrfs_inode (+6/-6)
     btrfs: Make btrfs_must_commit_transaction take btrfs_inode (+9/-9)
     btrfs: Make btrfs_del_dir_entries_in_log take btrfs_inode (+7/-7)
     btrfs: Make btrfs_log_changed_extents take btrfs_inode (+11/-11)
     btrfs: Make btrfs_record_unlink_dir take btrfs_inode (+14/-14)
     btrfs: Make btrfs_remove_delayed_node take btrfs_inode (+5/-5)
     btrfs: Make btrfs_get_logged_extents take btrfs_inode (+4/-4)
     btrfs: Make btrfs_log_trailing_hole take btrfs_inode (+4/-4)
     btrfs: Make btrfs_get_delayed_node take btrfs_inode (+8/-9)
     btrfs: Make btrfs_ino take a struct btrfs_inode (+151/-151)
     btrfs: Make log_directory_changes take btrfs_inode (+5/-6)
     btrfs: Make btrfs_unlink_inode take btrfs_inode (+50/-44)
     btrfs: Make log_new_dir_dentries take btrfs_inode (+4/-4)
     btrfs: Make btrfs_log_all_xattrs take btrfs_inode (+5/-5)
     btrfs: Make btrfs_log_new_name take btrfs_inode (+13/-15)
     btrfs: Make btrfs_inode_in_log take btrfs_inode (+18/-20)
     btrfs: Make count_inode_extrefs take btrfs_inode (+3/-3)
     btrfs: Make btrfs_del_inode_ref take btrfs_inode (+7/-7)
     btrfs: Make btrfs_log_inode take btrfs_inode (+48/-49)
     btrfs: Make __add_inode_ref take btrfs_inode (+13/-12)
     btrfs: Make drop_one_dir_item take btrfs_inode (+6/-6)
     btrfs: Make logged_inode_size take btrfs_inode (+3/-3)
     btrfs: Make count_inode_refs take btrfs_inode (+3/-3)
     btrfs: Make log_inode_item take btrfs_inode (+5/-5)
     btrfs: Make log_dir_items take btrfs_inode (+3/-3)
     btrfs: Make copy_items take btrfs_inode (+19/-21)

Liu Bo (17) commits (+269/-337):
     Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly (+26/-2)
     Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist (+16/-47)
     Btrfs: pass delayed_refs directly to btrfs_find_delayed_ref_head (+7/-9)
     Btrfs: fix another race between truncate and lockless dio write (+3/-1)
     btrfs: teach __process_pages_contig about PAGE_LOCK operation (+44/-7)
     Btrfs: create helper for processing bits on contiguous pages (+22/-15)
     Btrfs: cleanup unused cached_state in __extent_writepage_io (+1/-8)
     Btrfs: specify a new ordered extent type for create_io_em (+6/-4)
     Btrfs: use the correct type when creating cow dio extent (+1/-1)
     Btrfs: fix wrong argument for btrfs_lookup_ordered_range (+1/-1)
     Btrfs: try to avoid acquiring free space ctl's lock (+13/-11)
     Btrfs: use helper to get used bytes of space_info (+19/-22)
     Btrfs: remove unused trans in read_block_for_search (+8/-9)
     Btrfs: use helper to simplify lock/unlock pages (+10/-64)
     Btrfs: create a helper to create em for IO (+74/-115)
     Btrfs: clean up btrfs_ordered_update_i_size (+13/-16)
     Btrfs: fix comment in btrfs_page_mkwrite (+5/-5)

Jeff Mahoney (8) commits (+150/-139):
     btrfs: pass fs_info to (more) routines that are only called with extent_root (+53/-50)
     btrfs: drop unused extent_op arg from btrfs_add_delayed_data_ref (+6/-10)
     btrfs: use btrfs_debug instead of pr_debug in transaction abort (+2/-1)
     btrfs: free-space-cache, clean up unnecessary root arguments (+22/-26)
     btrfs: btrfs_truncate_free_space_cache always allocates path (+7/-7)
     btrfs: convert btrfs_inc_block_group_ro to accept fs_info (+5/-6)
     btrfs: flush_space always takes fs_info->fs_root (+10/-10)
     btrfs: allow unlink to exceed subvolume quota (+45/-29)

Qu Wenruo (4) commits (+123/-25):
     btrfs: qgroup: Move half of the qgroup accounting time out of commit trans (+75/-11)
     btrfs: Better csum error message for data csum mismatch (+22/-7)
     btrfs: raid56: Remove unused variable in lock_stripe_add (+0/-2)
     btrfs: Add WARN_ON for qgroup reserved underflow (+26/-5)

Anand Jain (3) commits (+14/-14):
     btrfs: btrfs_defrag_root() doesn't defrag extent root tree (+0/-3)
     btrfs: use BTRFS_COMPRESS_NONE to specify no compression (+3/-3)
     btrfs: consolidate auto defrag kick off policies (+11/-8)

Omar Sandoval (2) commits (+81/-85):
     Btrfs: constify struct btrfs_{,disk_}key wherever possible (+69/-64)
     Btrfs: refactor btrfs_extent_same() slightly (+12/-21)

Seraphime Kirkovski (2) commits (+13/-13):
     Btrfs: code cleanup min/max -> min_t/max_t (+3/-3)
     Btrfs: ACCESS_ONCE cleanup (+10/-10)

Michal Hocko (2) commits (+6/-3):
     btrfs: fix up misleading GFP_NOFS usage in btrfs_releasepage (+6/-1)
     btrfs: drop gfp mask tweaking in try_release_extent_state (+0/-2)

Filipe Manana (1) commits (+12/-2):
     Btrfs: fix deadlock between dedup on same file and starting writeback

Takafumi Kubota (1) commits (+6/-2):
     Btrfs: add another missing end_page_writeback on submit_extent_page failure

Colin Ian King (1) commits (+0/-3):
     btrfs: remove redundant inode null check

Geliang Tang (1) commits (+4/-4):
     btrfs: use rb_entry() instead of container_of

Total: (124) commits (+1389/-1420)

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
  fs/btrfs/inode.c             | 582 +++++++++++++++++++------------------------
  fs/btrfs/ioctl.c             | 109 ++++----
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
  42 files changed, 1212 insertions(+), 1243 deletions(-)
