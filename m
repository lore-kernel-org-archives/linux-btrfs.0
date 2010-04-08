From: Harshavardhana <harsha@gluster.com>
Subject: [PATCH] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Thu,  8 Apr 2010 13:35:31 -0700
Message-ID: <1270758931-5291-1-git-send-email-harsha@gluster.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

rmdir on subvolumes and snapshots should return "EPERM"
rather than ENOTEMPTY. Just to be more descriptive. 

Signed-off-by: Harshavardhana <harsha@gluster.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85b90c..c0fbe03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2593,7 +2593,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
-		return -ENOTEMPTY;
+		return -EPERM;
 
 	ret = btrfs_reserve_metadata_space(root, 5);
 	if (ret)
-- 
1.6.6.1

