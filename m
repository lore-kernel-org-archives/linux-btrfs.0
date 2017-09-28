Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61560 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdI1DgV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 23:36:21 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/5] Enhance tree block validation checker
Date: Thu, 28 Sep 2017 12:36:05 +0900
Message-Id: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/linux/tree/checker_enhance

It's based on David's misc-next branch, with following commit as base:
a5e50b4b444c ("btrfs: Add checker for EXTENT_CSUM")

According to David's suggestion, enhance the output format of tree block
validation checker.

And move them into one separate file: tree-checker.c.

Some example output using btrfsck fsck-test images looks like:

For unagliend file extent member:
---
BTRFS critical (device loop0): corrupt leaf root=1 tree_block=29360128 slot=7 ino=257 file_offset=0: invalid file extent disk_bytenr, have 755944791, should be aligned to 4096
BTRFS error (device loop0): open_ctree failed
---

For bad leaf holes:
---
BTRFS critical (device loop0): corrupt leaf root=1 block=29360128 slot=28: uncontinuous item end, have 9387 expect 15018
BTRFS error (device loop0): open_ctree failed
---


Qu Wenruo (5):
  btrfs-progs: Move leaf and node validation checker to tree-checker.c
  btrfs: tree-checker: Enhance btrfs_check_node output
  btrfs: tree-checker: Enhance output for btrfs_check_leaf
  btrfs: tree-checker: Enhance output for check_csum_item
  btrfs: tree-checker: Enhance output for check_extent_data_item

 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/ctree.h        |   4 +
 fs/btrfs/disk-io.c      | 284 +--------------------------------
 fs/btrfs/tree-checker.c | 417 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 425 insertions(+), 282 deletions(-)
 create mode 100644 fs/btrfs/tree-checker.c

-- 
2.14.1

