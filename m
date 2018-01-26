Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751883AbeAZH0Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:26:16 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 0/7] btrfs-progs: Do some clean up to be consistent
Date: Fri, 26 Jan 2018 15:25:59 +0800
Message-ID: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1~4 and 7: clean up use of btrfs_root.
Patch 5: remove redundancy value assignment.
Patch 6: remove no longer be used function define.

Changelog:
v2->v1:
Patch 2,4: To be consistent with kernel, change macro to inline function.
Patch 3:
	Change macro to inline function to be consistent with kernel.
	And change the function body to match kernel.

Gu Jinxiang (7):
  btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
  btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK
  btrfs-progs: Use fs_info instead of root for
    BTRFS_MAX_INLINE_DATA_SIZE
  btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
  btrfs-progs: do clean up for redundancy value assignment
  btrfs-progs: remove no longer be used btrfs_alloc_extent
  btrfs-progs: Cleanup use of root in leaf_data_end

 cmds-check.c              | 10 ++---
 convert/source-ext2.c     |  4 +-
 convert/source-reiserfs.c |  6 +--
 ctree.c                   | 96 +++++++++++++++++++++++++----------------------
 ctree.h                   | 45 +++++++++++++---------
 dir-item.c                |  3 +-
 extent-tree.c             |  1 -
 file-item.c               |  2 +-
 mkfs/main.c               |  4 +-
 print-tree.c              |  2 +-
 quick-test.c              |  2 +-
 volumes.c                 |  2 +-
 12 files changed, 97 insertions(+), 80 deletions(-)

-- 
2.14.3



