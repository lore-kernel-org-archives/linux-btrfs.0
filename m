From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: remove warn_on from use_block_rsv
Date: Tue, 26 Oct 2010 12:57:33 -0400
Message-ID: <1288112253-2760-1-git-send-email-josef@redhat.com>
References: <y>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <y>
List-ID: <linux-btrfs.vger.kernel.org>

Because btrfs_dirty_inode does a btrfs_join_transaction, it doesn't actually
reserve space.  It does this so we can try and dirty the inode quickly without
having to deal with the ENOSPC problems.  But if it does get back ENOSPC it
handles it properly.  The problem is use_block_rsv does a WARN_ON whenever this
case happens, even tho btrfs_dirty_inode takes it into account and actually
expects to get -ENOSPC if things are particularly tight.  So instead just remove
the warning.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2dfd4a..3378533 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5358,11 +5358,6 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	if (!ret)
 		return block_rsv;
 
-	WARN_ON(1);
-	printk(KERN_INFO"block_rsv size %llu reserved %llu freed %llu %llu\n",
-		block_rsv->size, block_rsv->reserved,
-		block_rsv->freed[0], block_rsv->freed[1]);
-
 	return ERR_PTR(-ENOSPC);
 }
 
-- 
1.6.6.1

