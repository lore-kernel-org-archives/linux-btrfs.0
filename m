Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755004AbcLNOmp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 09:42:45 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.9-rc1
Date: Wed, 14 Dec 2016 15:42:24 +0100
Message-Id: <20161214144224.17846-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged. Contains almost the entire devel branch from
today. There are small fixes, the lowmem mode of check gets more updates but
still does not work in the --repair mode and is considered experimental.

ETA for 4.9 is in +6 days (2016-12-20).

Minor fixes, docs improvements or more testcases will be still considered for
4.9 release.

Changes:
  * check: many lowmem mode updates
  * send: use splice syscall to copy buffer from kernel
  * receive: new option to dump the stream in textual form
  * convert:
    * move sources to own directory
    * prevent accounting of blocks beyond end of the device
    * make it work with 64k sectorsize
  * mkfs: move sources to own directory
  * defrag: warns if directory used without -r
  * dev stats:
    * new option to check stats for non-zero values
    * add long option for -z
  * library: version bump to 0.1.2, added subvol_uuid_search2
  * other:
    * cleanups
    * docs updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Adam Borowski (1):
      btrfs-progs: man mkfs: warn about RAID5/6 being experimental

Anand Jain (1):
      btrfs-progs: recursive defrag cleanup duplicate code

Austin S. Hemmelgarn (1):
      btrfs-progs: dev stats: add dev stats returncode option

Chandan Rajendra (3):
      btrfs-progs: Use helper function to access btrfs_super_block->sys_chunk_array_size
      btrfs-progs: convert: Prevent accounting blocks beyond end of device
      btrfs-progs: convert: Fix migrate_super_block() to work with 64k sectorsize

David Sterba (35):
      btrfs-progs: remove extra newline from messages
      btrfs-progs: use symbolic name for first inode number when searching
      btrfs-progs: send: use splice syscall instead of read/write to transfer buffer
      btrfs-progs: send: rename thread callback to read data from kernel
      btrfs-progs: make incompat bit wrappers more compact
      btrfs-progs: receive: rename receive context variable
      btrfs-progs: check: use on-stack path buffer in check_fs_first_inode
      btrfs-progs: check: use on-stack path buffer in check_fs_root_v2
      btrfs-progs: check: use on-stack path buffer in check_fs_roots_v2
      btrfs-progs: send dump: introduce helper for printing escaped path
      btrfs-progs: send dump: print escaped path
      btrfs-progs: send dump: use reentrant variant of localtime
      btrfs-progs: tests: add more gobal option to test 001-btrfs
      btrfs-progs: docs: update receive help and manual page
      btrfs-progs: build: extend pattern rules for standalone directories
      btrfs-progs: move btrfs-convert to own directory
      btrfs-progs: move mkfs.btrfs sources to own directory
      btrfs-progs: tests: check for partscan support in misc/006-partitioned-loopdev
      btrfs-progs: run mkfs tests in CI
      btrfs-progs: mkfs: annotation of a case
      btrfs-progs: docs: clarify trim after mkfs -K
      btrfs-progs: docs: make documentation updates workflow more clear
      btrfs-progs: dev stats: adjust some error messages
      btrfs-progs: dev stats: use char type path
      btrfs-progs: dev stats: use table based printing of items
      btrfs-progs: dev stats: add long option for -z
      btrfs-progs: docs: update dev stats help and manual page
      btrfs-progs: help: fix printing of aliased commands
      btrfs-progs: fixup API after change in subvol_uuid_search
      btrfs-progs: library: bump to 0.1.2
      btrfs-progs: handle failed strdup in subvol_uuid_search2
      btrfs-progs: dev stats: update option name for checking non-zero status
      btrfs-progs: defrag: cleanup temporary errno value
      btrfs-progs: defrag: warn when deframgenting directories without -r
      btrfs-progs: update CHANGES for v4.9

Goldwyn Rodrigues (5):
      btrfs-progs: Correct value printed by assertions/BUG_ON/WARN_ON
      btrfs-progs: Remove duplicate printfs in warning_trace()/assert_trace()
      btrfs-progs: check: fix extents after finding all errors
      btrfs-progs: Initialize ret to suppress compiler warning
      btrfs-progs: find_free_dev_extent() closer to kernel code

Lu Fengqi (11):
      btrfs-progs: check: introduce function to find dir_item
      btrfs-progs: check: introduce function to check inode_ref
      btrfs-progs: check: introduce function to check inode_extref
      btrfs-progs: check: introduce function to find inode_ref
      btrfs-progs: check: introduce function to check dir_item
      btrfs-progs: check: introduce function to check file extent
      btrfs-progs: check: introduce function to check inode item
      btrfs-progs: check: introduce function to check fs root
      btrfs-progs: check: introduce function to check root ref
      btrfs-progs: check: introduce low_memory mode fs_tree check
      btrfs-progs: check: fix the return value bug of cmd_check()

Noah Massey (1):
      btrfs-progs: docs: fix typo in mkfs manual page

Prasanth K S R (3):
      btrfs-progs: subvol_uuid_search: return error on memory allocation failure
      btrfs-progs: subvol_uuid_search: return error encoded pointer
      btrfs-progs: subvol_uuid_search: return error code on memory allocation failure

Qu Wenruo (11):
      btrfs-progs: raid56: Introduce new function to calculate raid5 parity or data stripe
      btrfs-progs: volumes: Use new raid5_gen_result to calculate raid5 parity
      btrfs-progs: check: Enhance leaf traversal function to handle missing inode item
      btrfs-progs: fsck: Fix patch allocation check and leak in check_fs_first_inode
      btrfs-progs: check: fix NULL pointer dereference for possible memory allocation failure
      btrfs-progs: introduce new send-dump object
      btrfs-progs: receive: introduce option to dump send stream
      btrfs-progs: check: Fix assert when using lowmem on fs with tree reloc tree
      btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023
      btrfs-progs: check: Fix lowmem false alert on tree reloc tree
      btrfs-progs: check: Fix false alert on generation mismatch for tree reloc tree

Wang Xiaoguang (1):
      btrfs-progs: check: skip shared node or leaf check for low_memory mode

