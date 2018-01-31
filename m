Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36269 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbeAaPFv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:05:51 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.15-rc1
Date: Wed, 31 Jan 2018 16:03:35 +0100
Message-Id: <20180131150335.17038-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged.

The only significant change is removing the custom chunk allocator from mkfs
for the --rootdir option.

ETA for 4.15 is in +2 days (2018-02-02).

Changes:

* mkfs --rootdir reworked, does not minimize the final image but can be still
  done using a new option --shrink
* fix allocation of system chunk, don't allocate from the reserved area
* other
  * new and updated tests
  * cleanups, refactoring
  * doc updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (14):
      btrfs-progs: docs: update manual for mkfs --shrink
      btrfs-progs: tests: fix typo in error message
      btrfs-progs: tests: bump zstd version in CI to 1.3.3
      btrfs-progs: build: simplify version tracking
      btrfs-progs: tests: 029-super-recovery: cleanup the test
      btrfs-progs: tests: add more coverage to mkfs-tests/013-reserved-1M-for-single
      btrfs-progs: tests: truncate test image to 0 first
      btrfs-progs: don't clobber errno in close_file_or_dir
      btrfs-progs: build: update help text for zstd
      btrfs-progs: docs: clean all generated files
      btrfs-progs: tests: disable some mkfs/010 testcases inside travis
      btrfs-progs: tests: enhance common umount helper to take optional paths
      btrfs-progs: tests: fixup mount tests of fsck/028-unaligned-super-dev-sizes
      btrfs-progs: update CHANGES for v4.15

Gu Jinxiang (2):
      btrfs-progs: Remove unused parameter trans
      btrfs-progs: build: Remove unused variable TESTS

Hans van Kranenburg (2):
      btrfs-progs: Fix progs_extra build dependencies
      btrfs-progs: Fix build of btrfs-calc-size

Lu Fengqi (2):
      btrfs-progs: qgroup: move btrfs_show_qgroups's error handler to __qgroup_search
      btrfs-progs: qgroup: cleanup __qgroup_search

Nikolay Borisov (8):
      btrfs-progs: Print error on invalid extent item format during check
      btrfs-progs: tests: Explictly state test.sh must be executable
      btrfs-progs: Factor out common print_device_info
      btrfs-progs: Remove recover_get_good_super
      btrfs-progs: Replace usage of list_for_each with list_for_each_entry
      btrfs-progs: Document logic of btrfs_read_dev_super
      btrfs-progs: super-recover: fix the broken sb detection
      btrfs-progs: tests: Add test for super block recovery

Qu Wenruo (22):
      btrfs-progs: mkfs: move image creation of rootdir to its own files
      btrfs-progs: mkfs: move source dir size calculation to its own files
      btrfs-progs: test/mkfs: Test if the minimal device size is valid
      btrfs-progs: mkfs/rootdir: Introduce function to get end position of last device extent
      btrfs-progs: mkfs: Update allocation info before verbose output
      btrfs-progs: mkfs: Cleanup temporary chunks before filling rootdir
      btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
      btrfs-progs: mkfs/rootdir: Use over-reserve method to make size estimate easier
      btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
      btrfs-progs: mkfs: Separate shrink from rootdir
      btrfs-progs: mkfs: fix regression preventing --rootdir to create file
      btrfs-progs: tests/mkfs: Introduce test case to check if mkfs rootdir can create a new file
      btrfs-progs: mkfs: Use the whole file or block device to mkfs for rootdir
      btrfs-progs: tests/mkfs: verify that mkfs.btrfs rootdir+shrink behaves correctly
      btrfs-progs: mkfs: Prevent temporary system chunk to use space in reserved 1M range
      btrfs-progs: tests:mkfs/010: Output minimal device size
      btrfs-progs: tests: mkfs: don't overwrite first 1M for single
      btrfs-progs: Use bool parameter to determine if we're allocating data extent
      btrfs-progs: volumes: Make find_free_dev_extent_start static
      btrfs-progs: volumes: Remove unnecessary trans parameter
      btrfs-progs: volumes: Remove unnecessary parameters when allocating device extent
      btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group

Rosen Penev (1):
      btrfs-progs: treewide: Replace strerror(errno) with %m.

Su Yue (1):
      btrfs-progs: check: report more specific info about invalid location

William Giokas (1):
      btrfs-progs: docs: fix typo in btrfs-filesystem manual page

