Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbcG2NcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 09:32:13 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.7
Date: Fri, 29 Jul 2016 15:31:49 +0200
Message-Id: <1469799109-26967-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.7 have been released. There are several new enhancements, a
handful of bugfixes and other cleanups. The changes since rc1 are more fixes
for unaligned access on sparc64.

Changes:

  * convert: fix creating discontig extents
  * check: speed up traversing heavily reflinked extents within a file
  * check: verify qgroups of higher levels
  * check: repair can now fix wrong qgroup numbers
  * balance: new option to run in the background
  * defrag: default extent target size changed to 32MiB
  * du: silently skip non-btrfs dirs/files
  * documentation updates: btrfs(5), btrfs(8), balance, subvolume, scrub,
    filesystem, convert
  * bugfixes:
    * unaligned access (reported for sparc64) in raid56 parity calculations
    * use /bin/bash
    * other stability fixes and cleanups
  * more tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Austin S. Hemmelgarn (1):
      btrfs-progs: add option to run balance as daemon

David Sterba (34):
      btrfs-progs: tests: use /bin/bash for scripts
      btrfs-progs: factor out repair mode
      btrfs-progs: docs: man5, document control device
      btrfs-progs: docs: update btrfs-balance manual page
      btrfs-progs: docs: update btrfs-subvolume manual page
      btrfs-progs: balance: cleanup, switch to common exit block
      btrfs-progs: balance: use errno directly
      btrfs-progs: do not set optind if not necessary
      btrfs-progs: docs: update btrfs-scrub manual page
      btrfs-progs: docs: update btrfs-filesystem manual page
      btrfs-progs: docs: update btrfs-convert manual page
      btrfs-progs: docs: update btrfs manual page
      btrfs-progs: tests: add 007-unsupported-block-sizes
      btrfs-progs: handle ulist_add errors in qgroup-verify
      btrfs-progs: image: fix minor resource leak
      btrfs-progs: corrupt block: pass eb as argument to debug_corrupt_block
      btrfs-progs: corrupt block: handle block mapping errors in debug_corrupt_block
      btrfs-progs: corrupt block: handle eb read and write errors
      btrfs-progs: balance: silence compiler warning
      btrfs-progs: balance: add another (shorter) option for background
      btrfs-progs: docs: update btrfs-balance manual page
      btrfs-progs: kerncompat: introduce put_unaligned_x helpers
      btrfs-progs: fix unaligned access calculating raid56 data
      btrfs-progs: use unsigned type for extent_buffer flags
      btrfs-progs: use values directly for BLOCK_GROUP_ macros
      btrfs-progs: refactor and extend btrfs_prepare_device arguments
      btrfs-progs: update values of EXTENT_* bits
      btrfs-progs: handle memory allocation error in __alloc_extent_buffer
      btrfs-progs: handler memory allocation error in write_data_to_disk
      btrfs-progs: fi defrag: change default extent target size to 32 MiB
      btrfs-progs: use proper unaligned helper in btrfs_csum_final
      btrfs-progs: fix unaligned access in raid6 calculations
      btrfs-progs: update CHANGES for 4.7
      Btrfs progs v4.7

Hans van Kranenburg (1):
      btrfs-progs: use the correct struct for BTRFS_IOC_LOGICAL_INO

Jeff Mahoney (3):
      btrfs-progs: check: add helpers for converting between structures
      btrfs-progs: check: supplement extent backref list with rbtree
      btrfs-progs: check: switch to iterating over the backref_tree

Justin Maggard (1):
      btrfs-progs: fix memory leak with missing device

Liu Bo (1):
      Btrfs-progs: fix btrfs-map-logical to only print extent mapping info

Luis Henriques (2):
      btrfs-progs: tests: 001-simple-unmounted: fix test failure due to bashism
      btrfs-progs: tests: 006-image-on-missing-device: fix btrfs tool path

Mark Fasheh (2):
      btrfs-progs: check: verify qgroups above level 0
      btrfs-progs: check: write corrected qgroup info to disk

Omar Sandoval (1):
      btrfs-progs: fix btrfsck of space_cache=v2 bitmaps on big-endian

Qu Wenruo (3):
      btrfs-progs: convert: Fix a bug leads to discontinuous extents
      btrfs-progs: convert-test: Add test case for discontinuous hole extent
      btrfs-progs: Doc: Fix format error in btrfs-send

Tsutomu Itoh (1):
      btrfs-progs: add the error message when open fails

Wang Shilong (1):
      btrfs-progs: du: fix to skip not btrfs dir/file

Wang Xiaoguang (1):
      btrfs-progs: mkfs: fix allocation information output of block group types

