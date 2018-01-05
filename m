Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbeAEShL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 13:37:11 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.14.1
Date: Fri,  5 Jan 2018 19:34:58 +0100
Message-Id: <20180105183458.3884-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.14.1 have been released.

Changes:
  * dump-tree: print times of root items
  * check: fix several lowmem mode bugs
  * convert: fix rollback after balance
  * other
    * new and updated tests, enabled lowmem mode in CI
    * docs updates
    * fix travis CI build
    * build fixes
    * cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (9):
      btrfs-progs: tests: fix path for travis helper script
      btrfs-progs: fix build of btrfs-show-super
      btrfs-progs: tests: enable check lowmem in travis CI
      btrfs-progs: tests: mkfs/008 mkfs with force
      btrfs-progs: tests: fix typos in test names
      btrfs-progs: build: specify minimal library version for reiserfs support
      btrfs-progs: docs: make option -A of mkfs less visible
      btrfs-progs: update CHANGES for v4.14.1
      Btrfs progs v4.14.1

Faalagorn (1):
      btrfs-progs: docs: fix typo in btrfs-man5

Hans van Kranenburg (1):
      btrfs-progs: dump_tree: remove superfluous _TREE

Howard (1):
      btrfs-progs: docs: update btrfs-subvolume manual page

Lu Fengqi (1):
      btrfs-progs: lowmem check: Reword an unclear error message about file extent gap

Misono, Tomohiro (2):
      btrfs-progs: dump-tree: print c/o/s/r time of ROOT_ITEM
      btrfs-progs: mkfs: check the status of file at mkfs

Nicholas D Steeves (1):
      btrfs-progs: docs: annual typo, clarity, & grammar review & fixups

Qu Wenruo (20):
      btrfs-progs: lowmem check: Fix regression which screws up extent allocator
      btrfs-progs: lowmem check: Fix NULL pointer access caused by large tree reloc tree
      btrfs-progs: lowmem check: Fix inlined data extent ref lookup
      btrfs-progs: lowmem check: Fix false backref lost warning for keyed extent data ref
      btrfs-progs: fsck-test: Introduce test case for false data extent backref lost
      btrfs-progs: backref: Allow backref walk to handle direct parent ref
      btrfs-progs: lowmem check: Fix function call stack overflow caused by wrong tree reloc tree detection
      btrfs-progs: lowmem check: Fix false alerts for image with shared block ref only backref
      btrfs-progs: fsck-test: Add new image with shared block ref only metadata backref
      btrfs-progs: lowmem check: Fix false alerts of referencer count mismatch for snapshot
      btrfs-progs: fsck-tests: Introduce test case with keyed data backref with shared tree blocks
      btrfs-progs: test/fsck: Introduce test images containing tree reloc tree
      btrfs-progs: test/fsck/020: Cleanup custom check function by overriding check_image function
      btrfs-progs: test/fsck/021: Cleanup custom check by overriding check_image
      btrfs-progs: test/common: Introduce run_mustfail_stdout
      btrfs-progs: test/common: Enhance prepare_test_dev to reset device size
      btrfs-progs: mkfs: Enhance minimal device size calculation to fix mkfs failure on small file
      btrfs-progs: mkfs: Only zero out the first 1M for rootdir
      btrfs-progs: convert: Fix a bug in rollback check which overwrite return value
      btrfs-progs: tests/convert: ensure btrfs-convert won't rollback the filesystem after balance

Su Yue (1):
      btrfs-progs: fi defrag: clean up duplicate code if find errors

