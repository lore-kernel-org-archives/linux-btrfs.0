From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] btrfs: constify dentry_operations
Date: Sat, 3 Oct 2009 00:15:01 +0400
Message-ID: <20091002201501.GA32644@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2323,7 +2323,7 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 void btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t size);
 int btrfs_invalidate_inodes(struct btrfs_root *root);
-extern struct dentry_operations btrfs_dentry_operations;
+extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5805,6 +5805,6 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 };
 
-struct dentry_operations btrfs_dentry_operations = {
+const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
 };
