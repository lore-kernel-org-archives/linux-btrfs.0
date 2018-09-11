Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35818 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbeILDIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:06 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove wait_ordered_range in btrfs_evict_inode
Date: Wed, 12 Sep 2018 06:06:22 +0800
Message-Id: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As VFS has called ->invalidatepage() to get all ordered extents done
and truncated all page cache pages, wait_ordered_range() is just a
noop.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff1d2ed2dc94..d3febc3a6bc0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5390,9 +5390,6 @@ void btrfs_evict_inode(struct inode *inode)
 
 	if (is_bad_inode(inode))
 		goto no_delete;
-	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
-	if (!special_file(inode->i_mode))
-		btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	btrfs_free_io_failure_record(BTRFS_I(inode), 0, (u64)-1);
 
-- 
1.8.3.1
