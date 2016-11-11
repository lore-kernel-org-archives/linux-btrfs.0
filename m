Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51933 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754181AbcKKPij (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 10:38:39 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8.3
Date: Fri, 11 Nov 2016 16:38:31 +0100
Message-Id: <20161111153831.22430-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.8.3 have been released. Handful of fixes and lots of
cleanups.

Changes:
  * check:
    * support for clearing space cache (v1)
    * size reduction of inode backref structure
  * send:
    * fix handling of multiple snapshots (-p and -c options)
    * transfer buffer increased (should reduce number of context switches)
    * reuse existing file for output (-f), eg. when root cannot create files (NFS)
  * dump-tree:
    * print missing items for various structures
    * new: dev stats, balance status item
    * sync key names with kernel (the persistent items)
  * subvol show: now able to print the toplevel subvolume -- the creation time
    might be wrong though
  * mkfs:
    * store the creation time of toplevel root inode
    * print UUID in the summary
  * build: travis CI for devel
  * other:
    * lots of cleanups and refactoring
    * switched to on-stack path structure
    * fixes from coverity, asan, ubsan
    * new tests
    * updates in testing infrastructure
    * fixed convert test 005

Changes since rc1:
  * fixed convert test 005
  * updates in testing infrastructure
  * mkfs: print UUID in the summary

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (147):
      btrfs-progs: tests: switch to dump- commands from inspect
      btrfs-progs: convert: switch more messages to common helpers
      btrfs-progs: qgroups show: handle errors when resolving root id
      btrfs-progs: remove unused function btrfs_get_path_rootid
      btrfs-progs: rename lookup_ino_rootid
      btrfs-progs: use existing rootid resolving helper in btrfs_list_get_path_rootid
      btrfs-progs: opencode trivial helper __free_all_subvolumn
      btrfs-progs: remove leading underscores from several helper
      btrfs-progs: use symbolic tree name when searching
      btrfs-progs: list: constify prefix arugment
      btrfs-progs: use enum for list layout type
      btrfs-progs: list: rename some helpers
      btrfs-progs: list: switch to common message helpers
      btrfs-progs: subvol list: setup list filters later
      btrfs-progs: return void from btrfs_list_setup_filter
      btrfs-progs: subvol list: cleanup layout argument setup
      btrfs-progs: subvol list: remove useless comments
      btrfs-progs: subvol list: simplify value assignments
      btrfs-progs: subvol list: consilidate naming of otime varaibles
      btrfs-progs: subvol list: add simplified helper for adding root backrefs
      btrfs-progs: subvol list: consolidate uuid types accross functions
      btrfs-progs: remove trivial helper root_lookup_init
      btrfs-progs: subvol list: remove ugly goto construct
      btrfs-progs: subvol list: better error message if subvol insertion fails
      btrfs-progs: subvol show: print more details about toplevel subvolume
      btrfs-progs: dump-tree: print missing dev_item data
      btrfs-progs: dump-tree: print missing chunk data
      btrfs-progs: dump-tree: print missing dev_extent data
      btrfs-progs: dump-tree: factor inode_item dump to function
      btrfs-progs: dump-tree: add helper to print timespec
      btrfs-progs: dump-tree: print missing inode_item data
      btrfs-progs: dump-tree: print missing dir_item data
      btrfs-progs: dump-tree: print more root_item data
      btrfs-progs: dump-tree: print missing data for file extent item
      btrfs-progs: mkfs: store creation time of the toplevel subvolume
      btrfs-progs: introduce key type for persistent temporary items
      btrfs-progs: print-tree: extract offset from the item key
      btrfs-progs: introduce key type for persistent permanent items
      btrfs-progs: switch dev stats item to the permanent item key
      btrfs-progs: teach print_leaf about permanent item subtypes
      btrfs-progs: teach print_leaf about temporary item subtypes
      btrfs-progs: add balance status structures
      btrfs-progs: dump-tree: print balance status item
      btrfs-progs: add dev stats on-disk structure
      btrfs-progs: dump-tree: print dev stats
      btrfs-progs: dump-tree: consolidate data key names
      btrfs-progs: remove unused parameter from print_inode_item
      btrfs-progs: dump-tree: pass item size instead of item
      btrfs-progs: dump-tree: return void from print_* functions
      btrfs-progs: dump-tree: simplify and fix check for empty uuid
      btrfs-progs: dump-tree: constify char argument in print_root_ref
      btrfs-progs: dump-tree: add untyped item ptr helper and use it
      btrfs-progs: dump-tree: rename extent buffer variable in btrfs_print_leaf
      btrfs-progs: dump-tree: move variable declarations closer to their use
      btrfs-progs: dump-tree: move remaining item variables to the scope of use
      btrfs-progs: dump-tree: cleanup types for item number iteration
      btrfs-progs: dump-tree: convert key-to-string to table
      btrfs-progs: dump-tree: convert dir-item-to-string to table
      btrfs-progs: tests: add test for multi-subvolume send from parent
      btrfs-progs: send: constify some arugments
      btrfs-progs: send: increase size of transfer buffer
      btrfs-progs: send: use proper type for read result, and rename the variable
      btrfs-progs: send: clean types in write_buf
      btrfs-progs: send: cleanup, rename some variables in dump_thread
      btrfs-progs: send: cleanup, rename send context variables
      btrfs-progs: send: cleanup use of ctransid delta temporary variable in find_good_parent
      btrfs-progs: check: unify type for inode_backref::filetype
      btrfs-progs: check: unify type for inode_backref::itemtype
      btrfs-progs: check: reorder fields in inode_backref for better packing
      btrfs-progs: mkfs: use const char for unmodified members of directory_name_entry
      btrfs-progs: mkfs: constify some char parameters
      btrfs-progs: reduce size of btrfs_path, locks are not used
      btrfs-progs: reduce size of btrfs_path::reada
      btrfs-progs: reduce size of btrfs_path::lowest_level
      btrfs-progs: mkfs: use on-stack path buffer in cleanup_temp_chunks
      btrfs-progs: convert: use on-stack path buffer in record_file_blocks
      btrfs-progs: convert: use on-stack path buffer in create_image
      btrfs-progs: convert: use on-stack path buffer in link_subvol
      btrfs-progs: image: use on-stack path buffer in create_metadump
      btrfs-progs: image: use on-stack path buffer in fixup_devices
      btrfs-progs: image: add symbolic constant for max thread count
      btrfs-progs: image: use fixed-size array for worker thread pointers
      btrfs-progs: image: use embedded array for metadump cluster buffer
      btrfs-progs: dump-tree: use new names for obsoleted keys
      btrfs-progs: fi du: don't redefine standard macro/function
      btrfs-progs: utils: remove useless check in make_btrfs
      btrfs-progs: qgroup: use on-stack path buffer in repair_qgroup_info
      btrfs-progs: qgroup: use on-stack path buffer in repair_qgroup_status
      btrfs-progs: convert bitfield to separate variables in btrfs_path
      btrfs-progs: check: use on-stack path buffer in add_missing_dir_index
      btrfs-progs: check: use on-stack path buffer in delete_dir_index
      btrfs-progs: check: use on-stack path buffer in find_normal_file_extent
      btrfs-progs: check: use on-stack path buffer in try_repair_inode
      btrfs-progs: check: use on-stack path buffer in repair_btree
      btrfs-progs: check: use on-stack path buffer in try_to_fix_bad_block
      btrfs-progs: check: use on-stack path buffer in verify_space_cache
      btrfs-progs: check: use on-stack path buffer in check_extent_csums
      btrfs-progs: check: use on-stack path buffer in check_extent_exists
      btrfs-progs: check: use on-stack path buffer in delete_duplicate_records
      btrfs-progs: check: use on-stack path buffer in record_orphan_data_extents
      btrfs-progs: check: use on-stack path buffer in fixup_extent_refs
      btrfs-progs: check: use on-stack path buffer in fixup_extent_flags
      btrfs-progs: check: use on-stack path buffer in reset_block_groups
      btrfs-progs: check: use on-stack path buffer in reset_balance
      btrfs-progs: check: use on-stack path buffer in recow_extent_buffer
      btrfs-progs: check: use on-stack path buffer in delete_bad_item
      btrfs-progs: check: use on-stack path buffer in fill_csum_tree_from_one_fs_root
      btrfs-progs: check: use on-stack path buffer in fill_csum_tree_from_fs
      btrfs-progs: check: use on-stack path buffer in fill_csum_tree_from_extent
      btrfs-progs: check: use on-stack path buffer in build_roots_info_cache
      btrfs-progs: check: use on-stack path buffer in repair_root_items
      btrfs-progs: tree-stats: use on-stack path buffer in calc_root_size
      btrfs-progs: restore: use on-stack path buffer in set_file_xattrs
      btrfs-progs: restore: use on-stack path buffer in copy_metadata
      btrfs-progs: restore: use on-stack path buffer in copy_file
      btrfs-progs: restore: use on-stack path buffer in copy_symlink
      btrfs-progs: restore: use on-stack path buffer in search_dir
      btrfs-progs: restore: use on-stack path buffer in do_list_roots
      btrfs-progs: restore: use on-stack path buffer in find_first_dir
      btrfs-progs: check: remove unused variable in record_extent
      btrfs-progs: chunk-recover: use on-stack path buffer in rebuild_block_group
      btrfs-progs: btrfstune: use on-stack path buffer in change_extents_uuid
      btrfs-progs: btrfstune: use on-stack path buffer in change_devices_uuid
      btrfs-progs: mkfs: simplify checks in directory_select
      btrfs-progs: docs: update mkfs help string and manual page
      btrfs-progs: fix unaligned u64 access in btrfs_alloc_data_chunk
      btrfs-progs: fix search tree v2 ioctl detection
      btrfs-progs: tests: teach scan-results about more errors
      btrfs-progs: crc32: use fallback implementation for unaligned buffers
      btrfs-progs: use correct type for device id iteration in get_fs_info
      btrfs-progs: tests: teach extract_image about packed streams
      btrfs-progs: send: check for output file existence before creating
      btrfs-progs: mkfs: add temporary variable for fs features
      btrfs-progs: mkfs: extend mkfs features with compat, safe and default versions
      btrfs-progs: mkfs: enhance feature table
      btrfs-progs: mkfs: add names of matching sysfs feature names
      btrfs-progs: mkfs: print the new UUID
      btrfs-progs: tests: check if kernel has btrfs support
      btrfs-progs: tests: refactor post-convert check helpers
      btrfs-progs: tests: add assertion helper
      btrfs-progs: tests: add path assertions to post-checks
      btrfs-progs: tests: add quotes around variables in common
      btrfs-progs: tests: add quotation around variables in common.convert
      btrfs-progs: tests: add quotation around variables in support scripts
      btrfs-progs: tests: enhance run_mayfail description comment
      btrfs-progs: update CHANGES for v4.8.3
      Btrfs progs v4.8.3

Qu Wenruo (5):
      btrfs-progs: check: add support to clear v1 free space cache
      btrfs-progs: fsck-tests: Check if clear space cache works
      btrfs-progs: Ignore clang complete file
      btrfs-progs: remove send-test tool
      btrfs-progs: Fix memory leak in write_raid56_with_parity

Roman Lebedev (1):
      btrfs-progs: Add travis CI build support

Tsutomu Itoh (3):
      btrfs-progs: send: fix handling of multiple snapshots (-p option)
      btrfs-progs: send: fix handling of -c option
      btrfs-progs: tests: add checking of send multiple clone source option
