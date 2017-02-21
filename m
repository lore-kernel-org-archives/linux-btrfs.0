Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25417 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750998AbdBUIex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:34:53 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5F1D447C4E8C
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2017 16:34:41 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/12] lowmem mode fixes
Date: Tue, 21 Feb 2017 16:34:26 +0800
Message-ID: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patches can be fetch from github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes

Thanks for reports from Chris Murphy and Christoph Anton Mitterer,
several new bugs are exposed for lowmem mode fsck.

Special thank to Christoph, who did rounds of test during the patch
development.

The following bugs are fixed in lowmem mode:

1) Block group used space false alert
   If a BLOCK_GROUP_ITEM or its first EXTENT/METADATA_ITEM is located at
   the first slot of a leaf, search_slot() used by lowmem mode can
   point to previous leaf, with path->slots[0] beyond valid leaf slots.

   This makes us to read out uninitialized data, and can abort block
   group used space check loop, causing a false alert.

   Fix it with a test case image inside fsck-tests/020/extent-ref-cases
   Also fix all possible backward search.
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

4) Compressed inline data extent
   The extra check on inline data extent length doesn't take compression
   into consideration and will cause false alert without outputting any
   error message.

   Fix it and add correct error message output for it.
   Also fix all possible silent error.
   Reported by Christoph.

5) fsck-tests Lowmem mode override fixes
   Allow lowmem mode override to get called for all tests, and allow
   them all to pass lowmem mode except fsck-tests/006, which is a
   original repair mode bug.


changelog:
  v2:
    More generic forward search bug fix, not restricted to block group
    item.
    Compressed inline extent false alert fix.
    Lowmem fsck-test enhance, to allow it really work.
    Fix walk_down_tree_v2() to continue after non-fatal errors detected
  v3:
    Update the last patch to make it works better for incoming lowmem
    mode repair patchset.

Lu Fengqi (1):
  btrfs-progs: fsck: Fix lowmem mode override to allow it skip repair
    work

Qu Wenruo (10):
  btrfs-progs: lowmem check: Fix several bugs related to afterward
    search
  btrfs-progs: check: Output verbose error when fsck found a bug in any
    tree
  btrfs-progs: lowmem check: Fix false alert in checking data extent
    csums
  btrfs-progs: lowmem check: Fix extent item size false alert
  btrfs-progs: lowmem check: Fix false alert on inline compressed extent
  btrfs-progs: lowmem check: Fix silent error if first inode item
    missing
  btrfs-progs: tests: Move fsck-tests/015 to fuzz tests
  btrfs-progs: fsck-test: Add test image for lowmem mode block group
    false alert
  btrfs-progs: fsck-test: Make 013 compatible with lowmem mode
  btrfs-progs: fsck-test: Add new test case for file extent false alerts

Su Yue (1):
  btrfs-progs: cmds-check.c: walk_down_tree_v2 break cause of leaf
    process

 cmds-check.c                                       | 175 +++++++++++++++------
 tests/common                                       |   8 +-
 tests/common.local                                 |   2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   |   2 +-
 .../block_group_item_false_alert.raw.xz            | Bin 0 -> 47792 bytes
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  15 +-
 tests/fsck-tests/025-file-extents/test.sh          |  42 +++++
 .../images}/bko-97171-btrfs-image.raw.txt          |   0
 .../images}/bko-97171-btrfs-image.raw.xz           | Bin
 9 files changed, 190 insertions(+), 54 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/block_group_item_false_alert.raw.xz
 create mode 100755 tests/fsck-tests/025-file-extents/test.sh
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.txt (100%)
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.xz (100%)

-- 
2.11.1



