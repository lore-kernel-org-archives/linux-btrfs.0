Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15660 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754569AbdC3GVY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id DC07647EE21B
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:18 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/19] Btrfs-progs offline scrub
Date: Thu, 30 Mar 2017 14:20:56 +0800
Message-ID: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For any one who wants to try it, it can be get from my repo:
https://github.com/adam900710/btrfs-progs/tree/offline_scrub

Several reports on kernel scrub screwing up good data stripes are in ML
for sometime.

And since kernel scrub won't account P/Q corruption, it makes us quite
hard to detect error like kernel screwing up P/Q when scrubbing.

To get a comparable tool for kernel scrub, we need a user-space tool to
act as benchmark to compare their different behaviors.

So here is the patchset for user-space scrub.

Which can do:

1) All mirror/backup check for non-parity based stripe
   Which means for RAID1/DUP/RAID10, we can really check all mirrors
   other than the 1st good mirror.

   Current "--check-data-csum" option will be finally replaced by
   offline scrub.
   As it doesn't really check all mirrors, if it hits a good copy, then
   resting copies will just be ignored.

2) Comprehensive RAID5/6 full stripe check
   It will take full use of btrfs csum(both tree and data).
   It will only recover the full stripe if all recovered data matches
   with its csum.

In fact, it can already expose several btrfs kernel bug.
As it's the main tool I'm using when developing the kernel fixes.

For example, after screwing up a data stripe, kernel did repairs data
using parity, but recovered full stripe has wrong parity.
Need to scrub again to fix it.

And this patchset also introduced new btrfs_map_block() function, which is
more flex than current btrfs_map_block(), and has a unified interface
for all profiles, not just an array of physical addresses.

Check the 6th and 7th patch for details.

They are already used in RAID5/6 scrub, but can also be used for other
profiles too.

The to-do list has been shortened, since RAID6 and new check logical is
introduced.
1) Repair support
   In fact, current tool can already report recoverability, repair is
   easy to implement.

2) Test cases
   Need to make the infrastructure able to handle multi-device first.

3) Make btrfsck able to handle RAID5 with missing device
   Now it doesn't even open RAID5 btrfs with missing device, even though
   scrub should be able to handle it.

Changelog:
V0.8 RFC:
   Initial RFC patchset

v1:
   First formal patchset.
   RAID6 recovery support added, mainly copied from kernel radi6 lib.
   Cleaner recovery logical.

v2:
   More comments in both code and commit message, suggested by David.
   File re-arrangement, no check/ dir, raid56.ch moved to kernel-lib,
   Suggested by David

v3:
  Put "--offline" option to scrub, other than put it in fsck.
  Use bitmap to read multiple csums in one run, to improve performance.
  Add --progress/--no-progress option, to tell user we're not just
  wasting CPU and IO.

Qu Wenruo (19):
  btrfs-progs: raid56: Introduce raid56 header for later recovery usage
  btrfs-progs: raid56: Introduce tables for RAID6 recovery
  btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
  btrfs-progs: raid56: Allow raid6 to recover data and p
  btrfs-progs: Introduce wrapper to recover raid56 data
  btrfs-progs: Introduce new btrfs_map_block function which returns more
    unified result.
  btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
  btrfs-progs: csum: Introduce function to read out data csums
  btrfs-progs: scrub: Introduce structures to support fsck scrub for
    RAID56
  btrfs-progs: scrub: Introduce function to scrub mirror based tree
    block
  btrfs-progs: scrub: Introduce function to scrub mirror based data
    blocks
  btrfs-progs: scrub: Introduce function to scrub one extent
  btrfs-progs: scrub: Introduce function to scrub one data stripe
  btrfs-progs: scrub: Introduce function to verify parities
  btrfs-progs: extent-tree: Introduce function to check if there is any
    extent in given range.
  btrfs-progs: scrub: Introduce function to recover data parity
  btrfs-progs: scrub: Introduce a function to scrub one full stripe
  btrfs-progs: scrub: Introduce function to check a whole block group
  btrfs-progs: scrub: Introduce offline scrub function

 .gitignore                         |    2 +
 Documentation/btrfs-scrub.asciidoc |    9 +
 Makefile                           |   21 +-
 cmds-scrub.c                       |  114 +++-
 csum.c                             |  136 +++++
 ctree.h                            |   11 +
 disk-io.c                          |    4 +-
 disk-io.h                          |    6 +-
 extent-tree.c                      |   60 +++
 kernel-lib/mktables.c              |  148 +++++
 kernel-lib/raid56.c                |  359 +++++++++++++
 kernel-lib/raid56.h                |   58 ++
 raid56.c                           |  172 ------
 scrub.c                            | 1040 ++++++++++++++++++++++++++++++++++++
 utils.h                            |    6 +
 volumes.c                          |  283 ++++++++++
 volumes.h                          |   78 +++
 17 files changed, 2319 insertions(+), 188 deletions(-)
 create mode 100644 csum.c
 create mode 100644 kernel-lib/mktables.c
 create mode 100644 kernel-lib/raid56.c
 create mode 100644 kernel-lib/raid56.h
 delete mode 100644 raid56.c
 create mode 100644 scrub.c

-- 
2.12.1



