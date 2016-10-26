Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933276AbcJZRzl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 13:55:41 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8.2
Date: Wed, 26 Oct 2016 19:55:35 +0200
Message-Id: <20161026175535.9832-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.8.2 have been released. Build fixes again and some small
fixes that arrived. There's one change since -rc1, a mkfs fix introduced by one
of the post 4.8.1 patches.

Changes:
  * convert: also convert file attributes
  * convert: fix wrong tree block alignment for unalianged block group
  * check: quota verify fixes, handle reloc tree
  * build: add stub for FIEMAP_EXTENT_SHARED, compiles on ancient kernels
  * build: add stub for BUILD_ASSERT when ioctl.h is included
  * dump-tree: don't crash on unrecognized tree id for -t
  * tests:
    * add more ioctl tests
    * convert: more symlink tests, attribute tests
    * quota verify for reloc tree
  * other cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (10):
      btrfs-progs: ioctl: add 32bit compat for SET_RECEIVED_SUBVOL
      btrfs-progs: ioctl: add 64bit compat for SEND
      btrfs-progs: tests: make the ioctl-test actually useful
      btrfs-progs: test: add default ioctl-test build
      btrfs-progs: mkfs: detect version of running kernel
      btrfs-progs: build: detect fiemap shared flag but don't fail build
      btrfs-progs: dump-tree: fix crash on unrecognized tree id
      btrfs-progs: ioctl: fix build failure if BUILD_ASSERT is not defined
      btrfs-progs: update CHANGES for v4.8.2
      Btrfs progs v4.8.2

Goldwyn Rodrigues (1):
      btrfs-progs: check: release path after usage

Karel Zak (1):
      btrfs-progs: rename btrfs_scan_lblkid() to btrfs_scan_devices()

Lakshmipathi.G (2):
      btrfs-progs: btrfs-debugfs: cleanup unused variables reported by pylint
      btrfs-progs: Add fast,slow symlinks, fifo types to convert test

Lu Fengqi (1):
      btrfs-progs: move btrfs_extref_hash() to hash.h

Qu Wenruo (10):
      btrfs-progs: Copy btrfs inode flags from kernel header
      btrfs-progs: Make btrfs-debug-tree print all readable strings for inode flags
      btrfs-progs: convert: Convert ext inode flags to btrfs inode flags
      btrfs-progs: convert-test: Add test case for common inode flags
      btrfs-progs: Fix stack overflow for checking qgroup on tree reloc tree
      btrfs-progs: test: Add test image for btrfsck qgroup rescan detection
      btrfs-progs: test: Add image for quota verify stack overflow
      btrfs-progs: rename raid6.c to raid56.c
      btrfs-progs: volumes: Remove BUG_ON in raid56 write routine
      btrfs-progs: Fix wrong tree block alignment for unalianged block group

Tsutomu Itoh (2):
      btrfs-progs: image: fix compiler warning
      btrfs-progs: send: remove unnecessary code
