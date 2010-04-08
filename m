From: Harshavardhana <harsha@gluster.com>
Subject: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Thu,  8 Apr 2010 15:47:00 -0700
Message-ID: <1270766820-7345-1-git-send-email-harsha@gluster.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Break the conditional to return EPERM for subvolumes,snapshots and 
ENOTEMPTY for normal directories with files.

Signed-off-by: Harshavardhana <harsha@gluster.com>
---
 fs/btrfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85b90c..465c3de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2591,9 +2591,11 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	unsigned long nr = 0;
 
-	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
-	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
-		return -ENOTEMPTY;
+	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE) 
+                return -ENOTEMPTY;
+
+        if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+		return -EPERM;
 
 	ret = btrfs_reserve_metadata_space(root, 5);
 	if (ret)
-- 
1.6.6.1

