Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8838 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751647AbeAaDJ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 22:09:26 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 0/7] btrfs-progs: Do some clean up to be consistent with kernel
Date: Wed, 31 Jan 2018 11:09:12 +0800
Message-ID: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1~4 and 7: clean up use of btrfs_root.
		Beside it, syncs code with kernel.
Patch 5: remove redundancy value assignment.
Patch 6: remove no longer be used function define.

Changelog:
v2->v1:
Patch 2,4: To be consistent with kernel, change macro to inline function.
Patch 3:
        Change macro to inline function to be consistent with kernel.
        And change the function body to match kernel.
v3->v2: 
Patch 3: Change the title to make it more exact.
Patch 7: 
	Add const to parameter leaf of function btrfs_item_offset_nr
	to keep type consistent with leaf_data_end.

Gu Jinxiang (7):
  btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
  btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK
  btrfs-progs: Sync code with kernel for BTRFS_MAX_INLINE_DATA_SIZE
  btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
  btrfs-progs: do clean up for redundancy value assignment
  btrfs-progs: remove no longer be used btrfs_alloc_extent
  btrfs-progs: Cleanup use of root in leaf_data_end

 cmds-check.c              | 10 ++---
 convert/source-ext2.c     |  4 +-
 convert/source-reiserfs.c |  6 +--
 ctree.c                   | 97 ++++++++++++++++++++++++++---------------------
 ctree.h                   | 47 +++++++++++++----------
 dir-item.c                |  3 +-
 extent-tree.c             |  1 -
 file-item.c               |  2 +-
 mkfs/main.c               |  4 +-
 print-tree.c              |  2 +-
 quick-test.c              |  2 +-
 volumes.c                 |  2 +-
 12 files changed, 99 insertions(+), 81 deletions(-)

-- 
1.9.1



