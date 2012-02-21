From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: avoid setting ->d_op twice
Date: Tue, 21 Feb 2012 17:04:28 +0800
Message-ID: <4F435E1C.8090902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Follow those instructions, and you'll trigger a warning in the
beginning of d_set_d_op():

  # mkfs.btrfs /dev/loop3
  # mount /dev/loop3 /mnt
  # btrfs sub create /mnt/sub
  # btrfs sub snap /mnt /mnt/snap
  # touch /mnt/snap/sub
  touch: cannot touch `tmp': Permission denied

__d_alloc() set d_op to sb->s_d_op (btrfs_dentry_operations), and
then simple_lookup() reset it to simple_dentry_operations, which
triggered the warning.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32214fe..2a623cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3908,7 +3908,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 	BTRFS_I(inode)->dummy_inode = 1;
 
 	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
-	inode->i_op = &simple_dir_inode_operations;
+	inode->i_op = &btrfs_dir_ro_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
@@ -3979,14 +3979,18 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 static int btrfs_dentry_delete(const struct dentry *dentry)
 {
 	struct btrfs_root *root;
+	struct inode *inode = dentry->d_inode;
 
-	if (!dentry->d_inode && !IS_ROOT(dentry))
-		dentry = dentry->d_parent;
+	if (!inode && !IS_ROOT(dentry))
+		inode = dentry->d_parent->d_inode;
 
-	if (dentry->d_inode) {
-		root = BTRFS_I(dentry->d_inode)->root;
+	if (inode) {
+		root = BTRFS_I(inode)->root;
 		if (btrfs_root_refs(&root->root_item) == 0)
 			return 1;
+
+		if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+			return 1;
 	}
 	return 0;
 }
-- 
1.7.3.1

