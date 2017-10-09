Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57148 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751228AbdJIBvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Oct 2017 21:51:52 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v4 0/5] Enhance tree block validation checker
Date: Mon,  9 Oct 2017 01:51:01 +0000
Message-Id: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/linux/tree/checker_enhance

It's based on David's misc-next branch, with following commit as base:
a5e50b4b444c ("btrfs: Add checker for EXTENT_CSUM")

According to David's suggestion, enhance the output format of tree block
validation checker.

And move them into separate files: tree-checker.[ch].

Also added a output format rule to try to make all output message
follow the same format.

Some example output using btrfs-progs fsck-test images looks like:

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
v4:
  Code style change suggested by David.
  Use more easy-to-understand error message for NULL node pointer,
  suggested by Nikolay.
  Helper macro enhancement, including naming change and argument
  protection suggested by David.
  Separate tree-checker.h suggested by David.


Qu Wenruo (5):
  btrfs: Move leaf and node validation checker to tree-checker.ch
  btrfs: tree-checker: Enhance btrfs_check_node output
  btrfs: tree-checker: Enhance output for btrfs_check_leaf
  btrfs: tree-checker: Enhance output for check_csum_item
  btrfs: tree-checker: Enhance output for check_extent_data_item

 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/disk-io.c      | 285 +-------------------------------
 fs/btrfs/tree-checker.c | 429 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h |  23 +++
 4 files changed, 457 insertions(+), 282 deletions(-)
 create mode 100644 fs/btrfs/tree-checker.c
 create mode 100644 fs/btrfs/tree-checker.h

-- 
2.14.2

