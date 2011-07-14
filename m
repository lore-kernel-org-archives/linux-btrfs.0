From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: kill reserved_bytes in inode
Date: Thu, 14 Jul 2011 16:02:42 -0400
Message-ID: <1310673762-30560-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

reserved_bytes is not used for anything in the inode, remove it.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    5 -----
 fs/btrfs/extent-tree.c |    2 --
 fs/btrfs/inode.c       |    1 -
 3 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 120240a..25e2ceb 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -100,11 +100,6 @@ struct btrfs_inode {
 	 */
 	u64 delalloc_bytes;
 
-	/* total number of bytes that may be used for this inode for
-	 * delalloc
-	 */
-	u64 reserved_bytes;
-
 	/*
 	 * the size of the file stored in the metadata on disk.  data=ordered
 	 * means the in-memory i_size might be larger than the size on disk
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 152669b..33e5205 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3113,7 +3113,6 @@ commit_trans:
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
-	BTRFS_I(inode)->reserved_bytes += bytes;
 	spin_unlock(&data_sinfo->lock);
 
 	return 0;
@@ -3135,7 +3134,6 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	data_sinfo = BTRFS_I(inode)->space_info;
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
-	BTRFS_I(inode)->reserved_bytes -= bytes;
 	spin_unlock(&data_sinfo->lock);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index faf516e..3a32131 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6771,7 +6771,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
-	ei->reserved_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
 	ei->index_cnt = (u64)-1;
-- 
1.7.5.2

