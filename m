From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] btrfs: Update directory link count correctly while creation
Date: Sun, 24 Jan 2010 02:08:08 +0530
Message-ID: <1264279089-14913-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch make sure we update directory link count correctly
during mkdir and rename


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32aa27d..9a56b3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4575,6 +4575,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	btrfs_set_trans_block_group(trans, inode);
 
 	btrfs_i_size_write(inode, 0);
+	/*
+	 * Directories have link count 2
+	 */
+	btrfs_inc_nlink(inode);
 	err = btrfs_update_inode(trans, root, inode);
 	if (err)
 		goto out_fail;
@@ -4585,6 +4589,13 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		goto out_fail;
 
+	/*
+	 * if we are adding a directory we need
+	 * to bump the link count of parent
+	 */
+	btrfs_inc_nlink(dentry->d_parent->d_inode);
+	btrfs_update_inode(trans, root, dentry->d_parent->d_inode);
+
 	d_instantiate(dentry, inode);
 	drop_on_err = 0;
 	btrfs_update_inode_block_group(trans, inode);
@@ -5613,6 +5624,16 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
+
+	if (!new_inode && S_ISDIR(old_inode->i_mode)) {
+		/*
+		 * Bump the parent directory link count, if we
+		 * end up adding a new inode
+		 */
+		btrfs_inc_nlink(new_dir);
+		btrfs_update_inode(trans, dest, new_dir);
+	}
+
 	BUG_ON(ret);
 
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
-- 
1.6.6.1.394.gdedc0

