Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933064AbcIUMJn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 08:09:43 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.7.3
Date: Wed, 21 Sep 2016 14:07:42 +0200
Message-Id: <1474459662-22006-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.7.3 have been released, bugfix release. There are some minor
fixes, notably the free-space-tree compat status was wrong, see [1] for more.
Some fuzzer bugs have been fixed, but there are still several open.

Changes:
  * fixed free space tree compat status
  * check: low-mem mode: handle partially dropped snapshots
  * dump-super: consolidate options for superblock copy
  * tree-stats: check mount status
  * subvol delete: handle verbosity option
  * defrag: print correct error string
  * mkfs: fix reading rotational status
  * other:
    * UBSAN build option
    * documentation updates
    * enhanced tests: convert, fuzzed images, more tools to run on fuzzed
      images

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg57738.html

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (18):
      btrfs-progs: dump-super: changes in options to specify superblocks
      btrfs-progs: build: add UBSAN to debugging features
      btrfs-progs: docs: update flushoncommit default value
      btrfs-progs: tree-stats: check and report mount status
      btrfs-progs: tests: add fuzzed image for a bad backref
      btrfs-progs: tests: rename test 001 to mention check
      btrfs-progs: tests: add fuzz test to try btrfs-image on all images
      btrfs-progs: tests: run check with various options on the fuzzed images
      btrfs-progs: remove stray newline from message in check_super
      btrfs-progs: tests: add fuzzed images for bad block group offset
      btrfs-progs: better error report in btrfs_scan_fs_devices
      btrfs-progs: reorganize extent_buffer and fix alignment of data
      btrfs-progs: subvol create: remove v from getopt
      btrfs-progs: defrag: set errno correctly in the callback
      btrfs-progs: mkfs: fix reading rotational status value
      btrfs-progs: mkfs: use preallocated buffers for config uuids
      btrfs-progs: update CHANGES for 4.7.3
      Btrfs progs v4.7.3

Jeff Mahoney (1):
      btrfs-progs: avoid looping forever when a bad blockgroup key is found

Lakshmipathi.G (1):
      btrfs-progs: tests: post btrfs-convert verify permissions and ACLs

Omar Sandoval (1):
      Revert "btrfs-progs: fix compat_ro mask for free space tree"

Qu Wenruo (2):
      btrfs-progs: mkfs: Warn user for minimal RAID5/6 devices setup
      btrfs-progs: docs: Add warning for build RAID btrfs on partions from the same device

Vincent Batts (1):
      btrfs-progs: subvol delete: add missing verbose option

Wang Xiaoguang (2):
      btrfs-progs: check: make low memory mode support partially dropped snapshots
      btrfs-progs: tests: add 021-partially-dropped-snapshot-case

adduxa (1):
      btrfs-progs: docs: fix typos in btrfs-subvolume

