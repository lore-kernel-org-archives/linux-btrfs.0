Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753545AbdIHQmp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 12:42:45 -0400
Date: Fri, 8 Sep 2017 18:41:15 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.13
Message-ID: <20170908164115.GT31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.13 have been released.

Changes:
  * convert: reiserfs support
  * check: new option --force to allow check of a mounted filesystem (no repair)
  * mkfs: --rootdir will now copy special files
  * dump-tree: minor output changes
  * inspect rootid: accept file as arugment
  * dev usage: don't calculate slack space for missing devices
  * fi du: don't print error on EMPTY_SUBVOL (inode number 2)
  * build:
    * fixed support for sanitization features on gcc (tsan, asan, ubsan)
    * fix PIE build
  * other:
    * misc cleanups and stability fixes
    * travis CI enhancements
    * new tests, fuzzed images
    * testsuite cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (74):
      btrfs-progs: docs: update btrfs-convert regarding reiserfs
      btrfs-progs: convert: move duplicated acl code to common header
      btrfs-progs: convert: move acl helper to common source file
      btrfs-progs: convert: move and rename dev_t helpers to common file
      btrfs-progs: convert: move reiserfs struct definitions to header
      btrfs-progs: build: fix PIE build
      btrfs-progs: drop local blocksize variables if they're nodesize
      btrfs-progs: drop blocksize from read_tree_block
      btrfs-progs: check: cleanup use of level_size
      btrfs-progs: drop redundant check of blocksize in read_tree_block
      btrfs-progs: drop blocksize argument from btrfs_find_create_tree_block
      btrfs-progs: drop blocksize argument from readahead_tree_block
      btrfs-progs: handle blockgroup errors when opening filesystem
      btrfs-progs: tests: add more fuzzed images from bugzilla
      btrfs-progs: build: add internal LDFLAGS for the D= features
      btrfs-progs: build: properly pass the LDFLAGS during tsan build
      btrfs-progs: build: fix building libbtrfs.so with tsan
      btrfs-progs: build: fix asan and ubsan build
      btrfs-progs: tests: add build checks for sanitization features
      btrfs-progs: tests: pull and build reiserfs lib inside CI
      btrfs-progs: add crude error handling when transaction start fails
      btrfs-progs: return errors from btrfs_start_transaction
      btrfs-progs: switch fs_info::system_allocs to bit
      btrfs-progs: use kzalloc to allocate transaction handle
      btrfs-progs: move transaction implementation out of header
      btrfs-progs: move transaction code out of disk-io
      btrfs-progs: store pointer to fs_info in transaction handle
      btrfs-progs: start framework for transaction abort
      btrfs-progs: don't start or commit after transaction abort
      btrfs-progs: tests: build preparation phases out of script section
      btrfs-progs: tests: add more checks for tools used in convert tests
      btrfs-progs: tests: install missing CI packages
      btrfs-progs: tests: update README
      btrfs-progs: handle transaction start failure in close_ctree
      btrfs-progs: tests: fix TEST_LOG=dump in convert tests
      btrfs-progs: add more error handling to btrfs_free_block_group
      btrfs-progs: handle failed search in find_search_start better
      btrfs-progs: tests: limit size of log dump from conver tests
      btrfs-progs: convert: don't print message when fs is not recognized, ext2
      btrfs-progs: tests: add more sanitizer message patterns to log scanner
      btrfs-progs: check: remove old mixed backref code
      btrfs-progs: check: move more of space cache clearing to a helper
      btrfs-progs: check: verify critical root pointers before use
      btrfs-progs: check: pass fs_info to check_chunks_and_extents
      btrfs-progs: check: use local fs_info in check_chunks_and_extents
      btrfs-progs: check: pass fs_info to check_chunks_and_extents_v2
      btrfs-progs: check: move chunk and extent check mode switch to a helper
      btrfs-progs: check: pass fs_info to check_fs_roots
      btrfs-progs: check: cleanup use of fs_info in check_fs_roots
      btrfs-progs: check: move fs roots check mode switch to a helper
      btrfs-progs: print-tree: rename item callbacks to match the key name
      btrfs-progs: print-tree: don't print the item type for all items
      btrfs-progs: print-tree: factor out block_group_item dump
      btrfs-progs: print-tree: factor out extent_data_ref dump
      btrfs-progs: print-tree: factor out shared_data_ref dump
      btrfs-progs: print-tree: factor out free_space_info dump
      btrfs-progs: print-tree: factor out dev_extent dump
      btrfs-progs: print-tree: factor out qgroup_status dump
      btrfs-progs: print-tree: factor out qgroup_info dump
      btrfs-progs: print-tree: factor out qgroup_limit dump
      btrfs-progs: print-tree: factor out persistent_item dump
      btrfs-progs: print-tree: factor out temporary_item dump
      btrfs-progs: check: add option to skip mount checks
      btrfs-progs: tests: add test for check --force
      btrfs-progs: tests: add testcase for 'fi du' and empty subvol
      btrfs-progs: print-tree: factor out extent_csum dump
      btrfs-progs: tests: cleanup loop device helpers
      btrfs-progs: tests: move loopdev helpers out of the testcase to common
      btrfs-progs: tests: convert misc/006-image-on-missing-device to loopdevs
      btrfs-progs: tests: convert misc/011-delete-missing-device to loopdevs
      btrfs-progs: tests: missing device and slack space report
      btrfs-progs: tests: enhance post-rollback fsck tests
      btrfs-progs: tests: check for kernel support for reiserfs
      btrfs-progs: update CHANGES for v4.13

Goffredo Baroncelli (2):
      btrfs-progs: reset the ret value when ignoring an error from du_add_file
      btrfs-progs: fi du: don't call lookup_path_rootid for BTRFS_EMPTY_SUBVOL_DIR_OBJECTID

Gu Jinxiang (2):
      btrfs-progs: mkfs: Replace number with enum
      btrfs-progs: mkfs: Move the tree root creation to own function

Jeff Mahoney (2):
      btrfs-progs: convert: add support for converting reiserfs
      btrfs-progs: tests: add support for converting reiserfs

Josef Bacik (1):
      btrfs-progs: print the csum length in debug-tree

Misono, Tomohiro (4):
      btrfs-progs: inspect rootid: Allow a file to be specified
      btrfs-progs: test: fix run_check_stdout() call _fail()
      btrfs-progs: test: fix name generation not to contain trailing spaces
      btrfs-progs: test: add new test for inspect-internal rootid

Nikolay Borisov (1):
      btrfs-progs: Use named constants for common sizes

Patrik Lundquist (1):
      btrfs-progs: device usage: don't calculate slack on missing device

Qu Wenruo (2):
      btrfs-progs: mkfs: Fix wrong file type for dir items and indexes when specifying root directory
      btrfs-progs: tests: Add test case for mkfs --rootdir parameter

Zhang Yu (1):
      Btrfs-progs: print-tree: check num_stripes in print_chunk
