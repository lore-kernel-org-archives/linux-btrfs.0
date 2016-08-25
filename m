Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58445 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754757AbcHYRsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 13:48:45 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.7.1
Date: Thu, 25 Aug 2016 19:47:27 +0200
Message-Id: <1472147247-10994-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.7 have been released. Though it's a minor version release, there
are changes that could be considered big but I don't see a reason to hold them
until 4.8 is released.

There's expected bunch of bugfixes and improvements. The checker low-memory
mode has been in devel for a few releases, still needs some work, but releasing
it will allow for more testing. The improved error handling of mkfs/convert
should potential problems if the process fails in the middle and leaves a
partially created filesystem behind.

Tentative plan for the next development is to port reiserfs conversion to the
reworked convert and look again at the recent patchsets for dumping
extents/chunks or send stream.

Changes:
  * check:
    * new optional mode: optimized for low memory usage (memory/io tradeoff)
    * --mode=lowmem, not default, still considered experimental
    * does not work with --repair yet
  * convert: regression fix, ext2_subvol/image rw permissions
  * mkfs/convert:
    * two-staged creation, partially created filesystem will not be recognized
    * improved error handling (fewer BUG_ONs)
  * convert: preparation for more filesystems to convert from
  * documentation updates: quota, qgroup
  * other
    * message updates
    * more tests
    * more build options, enhanced debugging


Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (59):
      btrfs-progs: check: adjust command line options for the low-memory mode
      btrfs-progs: no BUG_ON in close_ctree
      btrfs-progs: mkfs: switch to new error message helpers
      btrfs-progs: docs: update btrfs-quota manual page
      btrfs-progs: docs: update btrfs-quota manual page, more sections
      btrfs-progs: docs: refer to btrfs(5) from btrfs(8)
      btrfs-progs: switch ternary op to an if in cmd_subvol_show
      btrfs-progs: build: add more debugging features
      btrfs-progs: pass OPEN_CTREE flags as unsigned
      btrfs-progs: make superblock reading/scanning api more generic
      btrfs-progs: introduce signature for a partially set up filesystem
      btrfs-progs: mkfs: do not scan partially initialized devices
      btrfs-progs: two staged filesystem creation
      btrfs-progs: mkfs: return errors from block group creation functions
      btrfs-progs: mkfs: improve error handling in main()
      btrfs-progs: mkfs: improve error handling in recow_roots
      btrfs-progs: document all btrfs_open_ctree_flags
      btrfs-progs: mkfs: switch BUG_ON to error handling in traverse_directory
      btrfs-progs: mkfs: handle and report transaction commit failures
      btrfs-progs: mkfs: help and usage now to to stdout
      btrfs-progs: mkfs: clean up make_image
      btrfs-progs: mkfs: kill print_version
      btrfs-progs: mkfs: cleanup, open_ctree to fs_info and use directly
      btrfs-progs: build: add per-tool cflags variable
      btrfs-progs: build: extend convert options
      btrfs-progs: convert: prefix all ext2-related helpers
      btrfs-progs: convert: move intersect_with_sb
      btrfs-progs: convert: move convert_insert_dirent
      btrfs-progs: convert: move read_disk_extent
      btrfs-progs: convert: move csum_disk_extent
      btrfs-progs: convert: move init_blk_iterate_data
      btrfs-progs: convert: move record_file_blocks
      btrfs-progs: convert: move block_iterate_proc
      btrfs-progs: convert: move create_image_file_range
      btrfs-progs: convert: move migrate_one_reserved_range
      btrfs-progs: convert: move migrate_reserved_ranges
      btrfs-progs: convert: move _expand_extent_cache
      btrfs-progs: convert: move wipe_one_reserved_range
      btrfs-progs: convert: move wipe_reserved_ranges
      btrfs-progs: convert: move calculate_available_space
      btrfs-progs: convert: move convert_read_used_space
      btrfs-progs: convert: move create_image
      btrfs-progs: convert: move link_subvol
      btrfs-progs: convert: move create_subvol
      btrfs-progs: convert: move make_convert_data_block_groups
      btrfs-progs: convert: move init_btrfs
      btrfs-progs: convert: move migrate_super_block
      btrfs-progs: convert: move prepare_system_chunk_sb
      btrfs-progs: convert: make ext2 compilation honor the configure options
      btrfs-progs: convert: improve error hanling of link_subvol
      btrfs-progs: convert: improve error hanling of create_subvol
      btrfs-progs: convert: improve error hanling of init_btrfs
      btrfs-progs: convert: remove redundant check
      btrfs-progs: convert: switch to message helpers in do_convert
      btrfs-progs: convert: reword message when conversion fails
      btrfs-progs: convert: switch to common error helpers in do_rollback
      btrfs-progs: add rest of stack operations for btrfs_dir_item
      btrfs-progs: update CHANGES for 4.7.1
      Btrfs progs v4.7.1

Lu Fengqi (16):
      btrfs-progs: check: introduce function to check tree block backref in extent tree
      btrfs-progs: check: introduce function to check data backref in extent tree
      btrfs-progs: check: introduce function to query tree block level
      btrfs-progs: check: introduce function to check referencer of a backref
      btrfs-progs: check: introduce function to check shared block ref
      btrfs-progs: check: introduce function to check referencer for data backref
      btrfs-progs: check: introduce function to check shared data backref
      btrfs-progs: check: introduce function to check an extent
      btrfs-progs: check: introduce function to check dev extent item
      btrfs-progs: check: introduce function to check dev used space
      btrfs-progs: check: introduce function to check block group item
      btrfs-progs: check: introduce function to check chunk item
      btrfs-progs: check: introduce main entry function for checking leaf items
      btrfs-progs: check: introduce function to speed up fs tree check
      btrfs-progs: check: introduce traversal function for fsck
      btrfs-progs: check: introduce low memory mode

Qu Wenruo (4):
      btrfs-progs: convert: Fix a regression that ext2_save/image is not readonly
      btrfs-progs: convert-test: Check if the ext2_save/image is read only
      btrfs-progs: print-tree: Print human readable inode flags
      btrfs-progs: print-tree: Print hex and human readable root flags

Wang Xiaoguang (1):
      btrfs-progs: eliminate some unnecessary btrfs_lookup_extent_info() calls in walk_down_tree()

