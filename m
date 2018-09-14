Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60253 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727773AbeIOCT7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 22:19:59 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: remove wait_ordered_rane in btrfs_evict_inode
Date: Sat, 15 Sep 2018 05:03:28 +0800
Message-Id: <1536959008-17291-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
References: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we delete an inode,

btrfs_evict_inode() {
    truncate_inode_pages_final()
        truncate_inode_pages_range()
            lock_page()
            truncate_cleanup_page()
                 btrfs_invalidatepage()
                      wait_on_page_writeback
                           btrfs_lookup_ordered_range()
                 cancel_dirty_page()
           unlock_page()
     ...    
     btrfs_wait_ordered_range()
     ...

As VFS has called ->invalidatepage() to get all ordered extents done
(if there is any) and truncated all page cache pages (no dirty pages
to writeback after this step), wait_ordered_range() is just a noop.

Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: More details in the description.

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
