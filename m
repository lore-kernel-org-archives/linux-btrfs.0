Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935343AbeFGPD2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 11:03:28 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.17-rc1
Date: Thu,  7 Jun 2018 17:00:40 +0200
Message-Id: <20180607150040.5527-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged. The full 4.17 release will be done next
Thursday.

Only fixes (with tests) or documentation updates will be added, exceptions on
case-by-case basis.

ETA for 4.17 is in +7 days (2018-06-14).

Changes:

  * check
    * many lowmem mode improvements
    * properly report qgroup mismatch errors
    * check symlinks with append/immutable flags
  * fi usage
    * correctly calculate allocated/unallocated for raid10
    * minor output updates
  * mkfs
    * detect ENOSPC on thinly provisioned devices
    * fix spurious EEXIST during directory traversal
  * restore: fix relative path for restore target
  * dump-tree: print symbolic tree names for backrefs
  * send: fix regression preventing send -p with subvolumes mounted on "/"
  * corrupt-tree: refactoring and command line updates
  * build
    * make it work with e2fsprogs < 1.42 again
    * restore support for autoconf 2.63
    * detect if -std=gnu90 is supported
  * other
    * new tests
    * cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Axel Burri (1):
      btrfs-progs: fix regression preventing send -p with subvolumes mounted on "/"

David Sterba (4):
      btrfs-progs: tests: update log markers
      btrfs-progs: tests: fix fsck-tests/031 when on NFS
      btrfs-progs: update CHANGES for v4.17
      Btrfs progs v4.17-rc1

Gu JinXiang (1):
      btrfs-progs: Add DEBUG_CFLAGS_INTERNAL for libbtrfsutil

Hans van Kranenburg (1):
      btrfs-progs: fi-usage: fix RAID10 raw disk usage

James Harvey (1):
      btrfs-progs: map-logical: fix spelling of a variable

Jeff Mahoney (3):
      btrfs-progs: convert: fix support for e2fsprogs < 1.42
      btrfs-progs: build: autoconf 2.63 compatibility
      btrfs-progs: build: detect whether -std=gnu90 is supported

Lu Fengqi (3):
      btrfs-progs: qgroup: swap the argument in the caller of update_qgroup_relation
      btrfs-progs: tests: check btrfs qgroup parent-child relation output
      btrfs-progs: print-tree: remove dead code from btrfs_print_tree

Matthias Benkard (1):
      btrfs-progs: mkfs: traverse_directory: Reset error code on continue

Misono Tomohiro (5):
      btrfs-progs: fi usage: change warning message more appropriately
      btrfs-progs: fi usage: change to output more info without root privilege
      btrfs-progs: ins: dump-tree: Use %lld for extent data backref offset
      btrfs-progs: ins: dump-tree: Print tree name for extent data/tree block backref
      btrfs-progs: check: Initialize all filed of btrfs_inode_item in insert_inode_item()

Nikolay Borisov (37):
      btrfs-progs: Remove devid parameter from btrfs_rmap_block
      btrfs-progs: Remove add_cache_extent2
      btrfs-progs: Remove objectid argument from alloc_cache_extent
      btrfs-progs: Use exclude_super_stripes instead of account_super_bytes
      btrfs-progs: check: fix DIR_ITEM checking in lowmem
      btrfs-progs: tests: Add test for collision DIR_ITEM handling
      btrfs-progs: check: Drop ext_ref parameter from find_inode_ref
      btrfs-progs: check: Drop ext_ref param from check_dir_item
      btrfs-progs: check: Drop ext_ref argument from check_inode_item
      btrfs-progs: check: Drop unused ext_ref parameter from process_one_leaf
      btrfs-progs: check: Remove ext_ref param from check_fs_first_inode
      btrfs-progs: check: Remove ext_ref param from walk_down_tree
      btrfs-progs: check: Drop ext_ref param from check_fs_first_inode
      btrfs-progs: check: Drop ext_ref arument from check_fs_root
      btrfs-progs: check: Remove ext_ref local variable from check_fs_roots_lowmem
      btrfs-progs: Make __btrfs_fs_incompat return bool
      btrfs-progs: check: Remove root argument from delete_extent_records
      btrfs-progs: check: Remove root parameter from btrfs_fix_block_accounting
      btrfs-progs: check: Remove root parameter from del_pending_extents
      btrfs-progs: check: Remove root argument from finish_current_insert
      btrfs-progs: check: Make update_pinned_extents take btrfs_fs_info
      btrfs-progs: Remove unused argument from clean_tree_block
      btrfs-progs: check: Remove unused root argument from btrfs_extent_post_op
      btrfs-progs: Change btrfs_root to btrfs_fs_info argument in btrfs_lookup_extent_info
      btrfs-progs: Remove root argument from btrfs_set_block_flags
      btrfs-progs: Remove root argument from write_one_cache_group
      btrfs-progs: Remove fs_info argument from write_ctree_super
      btrfs-progs: Use symbolic names for read ahead behavior
      btrfs-progs: corrupt-block: Factor out specific-root code
      btrfs-progs: corrupt-block: Correctly handle -r when passing -I
      btrfs-progs: corrupt-block: Factor out key parsing function
      btrfs-progs: corrupt-block: Change -I flag parameter format
      btrfs-progs: corrupt-block: Convert -K flag argument handling to common function
      btrfs-progs: corrupt-block: Factor out common "-r" handling code
      btrfs-progs: corrupt-block: Add support for handling specific root when using -K option
      btrfs-progs: corrupt-block: Change format of -d option
      btrfs-progs: corrupt-block: Fix -D option

Qu Wenruo (14):
      btrfs-progs: check: lowmem: Remove corupted link before readding correct link
      btrfs-progs: dir-item: Don't do extra filetype validation check for btrfs_match_dir_item_name
      btrfs-progs: dir-item: Make btrfs_delete_one_dir_name more robust to handle corrupted name len
      btrfs-progs: check: Check data csum for all copies
      btrfs-progs: check: Fix data csum check return value
      btrfs-progs: check: Continue check even if csum error is found
      btrfs-progs: check: Distinguish csum checking output for --check-data-csum
      btrfs-progs: print-tree: Avoid segfault for heavily corrupted item pointers
      btrfs-progs: tests: Add test case for dump-tree on heavily corrupted leaf
      btrfs-progs: check: Make btrfs check return error for qgroup mismatch
      btrfs-progs: tests: Add test case to ensure btrfs check returns error for corrupted qgroups
      btrfs-progs: Remove fs_info parameter from btrfs_leaf_free_space()
      btrfs-progs: Allow tree to be printed without an fs_info
      btrfs-progs: print-tree: Enhance btrfs_print_tree() check to avoid out-of-boundary memory access

Su Yue (26):
      btrfs-progs: check: lowmem: release path in repair_extent_data_item()
      btrfs-progs: check: lowmem: record returned errors after walk_down_tree_v2
      btrfs-progs: check: lowmem: assign parent early in repair_extent_data_item
      btrfs-progs: check: move pin_down_tree_blocks to mode-common.c
      btrfs-progs: check: lowmem: exclude extents of metadata blocks
      btrfs-progs: check: lowmem: introduce mark/clear_block_groups_full
      btrfs-progs: check: lowmem: introduce try_force_cow_in_new_chunk
      btrfs-progs: check: lowmem: introduce avoid_extents_overwrite
      btrfs-progs: check: lowmem: exclude extents if init-extent-tree in lowmem
      btrfs-progs: check: lowmem: start to remove parameters @trans in lowmem
      btrfs-progs: check: lowmem: remove parameter @trans of delete_extent_item
      btrfs-progs: check: lowmem: remove parameter @trans of repair_chunk_item
      btrfs-progs: check: lowmem: remove parameter @trans of repair_extent_item
      btrfs-progs: check: lowmem: remove parameter @trans of check_leaf_items
      btrfs-progs: check: lowmem: remove parameter @trans of repair_tree_back_ref
      btrfs-progs: check: lowmem: remove parameter @trans of check_btrfs_root
      btrfs-progs: check: lowmem: introduce repair_block_accounting
      btrfs-progs: check: lowmem: end of removing parameters @trans in lowmem
      btrfs-progs: tests: add image with no extent with normal device size
      btrfs-progs: remove comments about delayed ref in backref.c
      btrfs-progs: remove useless branch in __merge_refs
      btrfs-progs: do not merge tree block refs have different root_id
      btrfs-progs: tests: test mkfs.btrfs fails on small backing size thin provision device
      btrfs-progs: check: check symlinks with append/immutable flags
      btrfs-progs: check: lowmem: check symlinks with append/immutable flags
      btrfs-progs: fsck-tests: add test case to check symlinks with bad flags

Ting-Chang Hou (1):
      btrfs-progs: restore: fix mistake on overwrite_ok() if relative path is given

Yevgeny Popovych (1):
      btrfs-progs: mkfs: Fix typos in strings and comments

