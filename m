Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51299 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163956AbeBOP3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 10:29:06 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.15.1-rc1
Date: Thu, 15 Feb 2018 16:26:42 +0100
Message-Id: <20180215152642.4370-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged.  This is going to be a minor maintenance
release.

ETA for 4.15.1 is in +1 days (2018-02-16).

Changes:

* build
  * fix build on musl
  * support asciidoctor for doc generation
* cleanups
  * sync some code with kernel
  * move code to own directory, split to more files
* tests
  * more build tests in travis
  * tests now pass with asan and ubsan
  * testsuite can be exported and used separately

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (1):
      btrfs-progs: print-tree: fix INODE_ITEM sequence and flags

David Sterba (17):
      btrfs-progs: check: rename files after moving code
      btrfs-progs: docs: fix manual page title format
      btrfs-progs: build: add support for asciidoctor doc generator
      btrfs-progs: convert: fix build on musl
      btrfs-progs: mkfs: fix build on musl
      btrfs-progs: ci: change clone depth to 1
      btrfs-progs: ci: add support scripts for docker build
      btrfs-progs: ci: add dockerfile for a musl build test
      btrfs-progs: ci: enable musl build tests in docker
      btrfs-progs: ci: use helper script for default build commands
      btrfs-progs: ci: replace inline shell commands with scripts
      btrfs-progs: rework testsuite export
      btrfs-progs: tests: update README.md
      btrfs-progs: tests: unify test drivers, make ready for extenral testsuite
      btrfs-progs: test: update clean-test.sh after the TEST_TOP update
      btrfs-progs: tests: document exported testsuite
      btrfs-progs: reorder tests in make target

Gu Jinxiang (12):
      btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
      btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK
      btrfs-progs: Sync code with kernel for BTRFS_MAX_INLINE_DATA_SIZE
      btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
      btrfs-progs: do clean up for redundancy value assignment
      btrfs-progs: remove no longer used btrfs_alloc_extent
      btrfs-progs: Cleanup use of root in leaf_data_end
      btrfs-progs: add prerequisite mkfs.btrfs for test-cli
      btrfs-progs: add prerequisite btrfs-image for test-fuzz
      btrfs-progs: add prerequisite btrfs-convert for test-misc
      btrfs-progs: Add make testsuite command for export tests
      btrfs-progs: introduce TEST_TOP and INTERNAL_BIN for tests

Qu Wenruo (22):
      btrfs-progs: tests: chang tree-reloc-tree test number from 027 to 015
      btrfs-progs: Move cmds-check.c to check/main.c
      btrfs-progs: check: Move original mode definitions to check/original.h
      btrfs-progs: check: Move definitions of lowmem mode to check/lowmem.h
      btrfs-progs: check: Move node_refs structure to check/common.h
      btrfs-progs: check: Export check global variables to check/common.h
      btrfs-progs: check: Move imode_to_type function to check/common.h
      btrfs-progs: check: Move fs_root_objectid function to check/common.h
      btrfs-progs: check: Move count_csum_range function to check/common.c
      btrfs-progs: check: Move __create_inode_item function to check/common.c
      btrfs-progs: check: Move link_inode_to_lostfound function to common.c
      btrfs-progs: check: Move check_dev_size_alignment to check/common.c
      btrfs-progs: check: move reada_walk_down to check/common.c
      btrfs-progs: check: Move check_child_node to check/common.c
      btrfs-progs: check: Move reset_cached_block_groups to check/common.c
      btrfs-progs: check: Move lowmem check code to its own check/lowmem.[ch]
      btrfs-progs: check/lowmem: Cleanup unnecessary _v2 suffixes
      btrfs-progs: check: Cleanup all checkpatch error and warning
      btrfs-progs: fsck-tests: Cleanup the restored image for 028
      btrfs-progs: btrfs-progs: Fix read beyond boundary bug in build_roots_info_cache()
      btrfs-progs: mkfs/rootdir: Fix memory leak in traverse_directory()
      btrfs-progs: convert/ext2: Fix memory leak caused by handled ext2_filsys

Su Yue (1):
      btrfs-progs: tests common: remove meaningless colon in extract_image()

