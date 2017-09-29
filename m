Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60475 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbdI2Gtc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 02:49:32 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v3 0/5] Enhance tree block validation checker
Date: Fri, 29 Sep 2017 06:48:44 +0000
Message-Id: <20170929064849.15086-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/linux/tree/checker_enhance

It's based on David's misc-next branch, with following commit as base:
a5e50b4b444c ("btrfs: Add checker for EXTENT_CSUM")

According to David's suggestion, enhance the output format of tree block
validation checker.

And move them into one separate file: tree-checker.c.

Also added a output format rule to try to make all output message
follow the same format.

Some example output using btrfsck fsck-test images looks like:

For unagliend file extent member:
---
BTRFS critical (device loop0): corrupt leaf: root=1 block=29360128 slot=7 ino=257 file_offset=0, invalid disk_bytenr for file extent, have 755944791, should be aligned to 4096
---

For bad leaf holes:
---
BTRFS critical (device loop0): corrupt leaf: root=1 block=29360128 slot=28, discontinious item end, have 9387 expect 15018
---

Changelog:
v2:
  Unify the error string format, so it should be easier to grep them
  from dmesg. Thanks Nikolay for pointing this out.
  Remove unused CORRUPT() macro.
v3:
  Replace EIO with EUCLEAN in 2nd patch. Thanks Nikolay for pointing
  this out.
  Correct "btrfs-progs:" to "btrfs:" for 1st patch.

Qu Wenruo (5):
  btrfs: Move leaf and node validation checker to tree-checker.c
  btrfs: tree-checker: Enhance btrfs_check_node output
  btrfs: tree-checker: Enhance output for btrfs_check_leaf
  btrfs: tree-checker: Enhance output for check_csum_item
  btrfs: tree-checker: Enhance output for check_extent_data_item

 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/ctree.h        |   4 +
 fs/btrfs/disk-io.c      | 284 +-------------------------------
 fs/btrfs/tree-checker.c | 429 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 437 insertions(+), 282 deletions(-)
 create mode 100644 fs/btrfs/tree-checker.c

-- 
2.14.2

