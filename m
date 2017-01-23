Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2848 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750728AbdAWJPR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 04:15:17 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework update
Date: Mon, 23 Jan 2017 17:13:49 +0800
Message-ID: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patches can be fetch from github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes

Although there are near 10 patches, but they are all small.
No need to be scared. :)

Thanks for reports from Chris Murphy and Christoph Anton Mitterer,
several new bugs are exposed for lowmem mode fsck.

And one original mode bug, not fixed in this patchset.
The original mode bug is caused by fsck/006, which repairs doesn't
fix backrefs of a data extent, which lowmem mode detects it correctly.

1) Block group used space false alert
   If a BLOCK_GROUP_ITEM or its first EXTENT/METADATA_ITEM is located at
   the first slot of a leaf, search_slot() used by lowmem mode can
   point to previous leaf, with path->slots[0] beyond valid leaf slots.

   This makes us to read out uninitialized data, and can abort block
   group used space check loop, causing a false alert.

   Fix it with a test case image inside fsck-tests/020/extent-ref-cases
   Reported by Christoph.

2) Partly written prealloc extent false alert
   If a prealloc extent gets partily written, lowmem mode will report
   prealloc extent shouldn't have csum.

   Lowmem mode passed wrong variable to csum checking code, causing it
   to check the whole range of the prealloc extent, making the bug
   happens.

   Fix it with a test case inside fsck-tests/020/extent-ref-cases.
   Reported by Chirs Murphy And Christoph.

3) Extent item size false alert.
   Under certain case, btrfs lowmem mode check reports data backref
   lost.
   It's because newly introduced extent item size check aborts normal
   check routine.

   It can happen if a data/metadata extent item has no inline ref.

   Fix it, test case already submitted before and merged, but due to
   fsck-tests framework bugs, it never get called for lowmem mode.

4) fsck-tests Lowmem mode override fixes
   Allow lowmem mode override to get called for all tests, and allow
   them all to pass lowmem mode except fsck-tests/006, which is a
   original repair mode bug.


Lu Fengqi (1):
  btrfs-progs: fsck: Fix lowmem mode override to allow it skip repair
    work

Qu Wenruo (8):
  btrfs-progs: lowmem check: Fix wrong block group check when search
    slot points to slot beyong leaf
  btrfs-progs: fsck-test: Add test image for lowmem mode block group
    false alert
  btrfs-progs: fsck: Output verbose error when fsck found a bug
  btrfs-progs: lowmem check: Fix false alert in checking data extent
    pointing to prealloc extent
  btrfs-progs: lowmem check: Fix extent item size false alert
  btrfs-progs: tests: Move fsck-tests/015 to fuzz tests
  btrfs-progs: fsck-tests: Make 013 compatible with lowmem mode
  btrfs-progs: fsck-tests: Add new test case for partly written prealloc
    extent

 cmds-check.c                                       |  80 ++++++++++++++++-----
 tests/common                                       |   8 +--
 tests/common.local                                 |   2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   |   2 +-
 .../block_group_item_false_alert.raw.xz            | Bin 0 -> 47792 bytes
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  30 ++++++--
 .../images}/bko-97171-btrfs-image.raw.txt          |   0
 .../images}/bko-97171-btrfs-image.raw.xz           | Bin
 8 files changed, 95 insertions(+), 27 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/block_group_item_false_alert.raw.xz
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.txt (100%)
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.xz (100%)

-- 
2.11.0



