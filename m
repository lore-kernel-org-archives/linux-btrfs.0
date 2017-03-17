Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCQOJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 10:09:15 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.10.1
Date: Fri, 17 Mar 2017 15:08:32 +0100
Message-Id: <20170317140832.3926-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.10.1 have been released.  The build breakages are fixed
now and convert rollback now works again.

Changes:
  * receive: handle subvolume in path clone
  * convert: rollback fixed (rewrite was needed to address previous design issues)
  * build: fix build of 3rd party tools, missing <linux/sizes.h>
  * dump-tree: print log trees
  * other
    * new and updated tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Baruch Siach (1):
      btrfs-progs: add missing limits headers

Benedikt Morbach (3):
      btrfs-progs: receive: better error reporting for snapshots
      btrfs-progs: receive: handle root subvol path in clone
      btrfs-progs: tests: correctly receive clones to mounted subvol

David Sterba (19):
      btrfs-progs: tests: port 019-receive-clones-on-munted-subvol
      btrfs-progs: library: distribute sizes.h, fix build
      btrfs-progs: library-test: update header inclusion
      btrfs-progs: library-test: update test to build outside of topdir
      btrfs-progs: tests: do test build of library-test.static
      btrfs-progs: docs: add preliminary do's & dont's for tests
      btrfs-progs: tests: use TEST_DEV in cli-tests
      btrfs-progs: tests: mkfs/002 and 003: use TEST_DEV instead of IMAGE
      btrfs-progs: tests: cleanup use of IMAGE and replace by helpers
      btrfs-progs: tests: add fssum utility
      btrfs-progs: tests: fssum, drop unnecessray build defines
      btrfs-progs: tests: fssum, use our endianity helper
      btrfs-progs: tests: fssum, drop *_SOURCE defines, already provided via config.h
      btrfs-progs: tests: fssum, update includes
      btrfs-progs: tests: add SHA256
      btrfs-progs: tests: fssum, switch from MD5 to SHA256
      btrfs-progs: tests: misc/019, use fssum
      btrfs-progs: update CHANGES for v4.10.1
      Btrfs progs v4.10.1

Qu Wenruo (11):
      btrfs-progs: convert: Add comment for the overall convert design
      btrfs-progs: convert: Introduce simple range structure for convert reserved ranges
      btrfs-progs: convert: Use reserved ranges array to cleanup open code
      btrfs-progs: file: Introduce function to read out file content
      btrfs-progs: convert: Introduce function to read out btrfs reserved range
      btrfs-progs: convert: Introduce function to check if convert image is able to be rolled back
      btrfs-progs: convert: Rework rollback
      btrfs-progs: dump-tree: Fix duplicated output when using -t option
      btrfs-progs: dump-tree: Also output log root tree
      btrfs-progs: kerncompat: Fix re-definition of __bitwise
      btrfs-progs: convert: Make btrfs_reserved_ranges const

