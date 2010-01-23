From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] btrfs: Update the directory link count correctly
Date: Sun, 24 Jan 2010 02:08:09 +0530
Message-ID: <1264279089-14913-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch make sure we update the directory link count properly
during delete

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a56b3b..12b9d6e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2703,8 +2703,17 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 				 dentry->d_name.name, dentry->d_name.len);
 	if (!err) {
 		btrfs_i_size_write(inode, 0);
-		btrfs_drop_nlink(inode);
+		/*
+		 * Directories have link count 2.
+		 */
+		btrfs_clear_nlink(dentry->d_inode);
 		btrfs_update_inode(trans, root, inode);
+		/*
+		 * If we are removing a directory drop the link count from
+		 * the parent directory
+		 */
+		btrfs_drop_nlink(dir);
+		btrfs_update_inode(trans, root, dir);
 	}
 out:
 	nr = trans->blocks_used;
-- 
1.6.6.1.394.gdedc0

