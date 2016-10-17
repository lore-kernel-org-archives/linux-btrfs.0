Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3381 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbcJQB2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:04 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 1CA4F41B4BC3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:46 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 00/14] Offline scrub support, and hint to solve kernel scrub data silent corruption
Date: Mon, 17 Oct 2016 09:27:29 +0800
Message-Id: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

***Just RFC patch for early evaluation, please don't merge it***

For any one who wants to try it, it can be get from my repo:
https://github.com/adam900710/btrfs-progs/tree/fsck_scrub

Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
mirror or parity or data corrupted.
The tool are all able to detect them and give recoverbility report.

Several reports on kernel scrub screwing up good data stripes are in ML
for sometime.

The reason seems to be lack of csum check before and after reconstruction, and
unfinished parity write seems also involved.

To get a comparable tool for kernel scrub, we need a user-space tool to
act as benchmark to compare their different behaviors.

So here is the RFC patch set for user-space scrub.

Which can do:

1) All mirror/backup check for non-parity based stripe
   Which means for RAID1/DUP/RAID10, we can really check all mirrors
   other than the 1st good mirror.

   Current "--check-data-csum" option will be finally replace by scrub.
   As it doesn't really check all mirrors, if it hits a good copy, then
   resting copies will just be ignored.

2) Comprehensive RAID5 full stripe check
   It will check csum before reconstruction using parity.
   And if too many data stripes has csum mismatch, no need to
   reconstruct anyway.

   And after reconstruction, it will also check the csum of recovered
   data against csum, to ensure we didn't recover wrong result.

   For all csum match case, will re-calculate parity and compare it with
   ondisk parity, to detect parity error.

In fact, it can already expose one new btrfs kernel bug.
For example, after screwing up a data stripe, kernel did repairs using
parity, but recovered full stripe has wrong parity.
Need to scrub again to fix it.

And this patchset also introduced new map_block() function, which is
more flex than current btrfs_map_block(), and has a unified interface
for all profiles.
Check the 1st and 2nd patch for details.

They are already used in RAID5/6 scrub, but can also be used for other
profiles too.

Since it's just an evaluation patchset, it still has a long to-do list:

1) Repair support
   In fact, current tool can already report recoverability, repair is
   not hard to implement.

2) RAID6 support
   The mathematics behind RAID6 recover is more complex than RAID5.
   Need some more code to make it possible to recover data stripes,
   other than just calculating Q and P.

3) Test cases
   Need to make the infrastructure able to handle multi-device first.

4) Cleaner code and refined logical
   Need a better shared logical for all profiles to do scrub, and use
   new map_block_v2() to replace these old codes.

5) Make btrfsck able to handle RAID5 with missing device
   Now it doesn't even open RAID5 btrfs with missing device, even thouth
   scrub should be able to handle it.

Qu Wenruo (14):
  btrfs-progs: Introduce new btrfs_map_block function which returns more
    unified result.
  btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
  btrfs-progs: check/csum: Introduce function to read out one data csum
  btrfs-progs: check/scrub: Introduce structures to support fsck scrub
  btrfs-progs: check/scrub: Introduce function to scrub mirror based
    tree block
  btrfs-progs: check/scrub: Introduce function to scrub mirror based
    data blocks
  btrfs-progs: check/scrub: Introduce function to scrub one extent
  btrfs-progs: check/scrub: Introduce function to scrub one data stripe
  btrfs-progs: check/scrub: Introduce function to verify parities
  btrfs-progs: extent-tree: Introduce function to check if there is any
    extent in given range.
  btrfs-progs: check/scrub: Introduce function to recover data parity
  btrfs-progs: check/scrub: Introduce a function to scrub one full
    stripe
  btrfs-progs: check/scrub: Introduce function to check a whole block
    group
  btrfs-progs: fsck: Introduce offline scrub function

 Documentation/btrfs-check.asciidoc |   8 +
 Makefile.in                        |   6 +-
 check/check.h                      |  23 ++
 check/csum.c                       |  96 +++++
 check/scrub.c                      | 812 +++++++++++++++++++++++++++++++++++++
 cmds-check.c                       |  12 +-
 ctree.h                            |   2 +
 disk-io.c                          |   4 +-
 disk-io.h                          |   2 +
 extent-tree.c                      |  52 +++
 volumes.c                          | 282 +++++++++++++
 volumes.h                          |  49 +++
 12 files changed, 1343 insertions(+), 5 deletions(-)
 create mode 100644 check/check.h
 create mode 100644 check/csum.c
 create mode 100644 check/scrub.c

-- 
2.10.0



