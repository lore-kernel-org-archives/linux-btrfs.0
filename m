From: Larry D'Anna <larry@elder-gods.org>
Subject: [PATCH 2/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 00:00:13 -0400
Message-ID: <fe0d8683672f6d7bb90bd46b60a49add53ed7f61.1301542805.git.larry@elder-gods.org>
References: <cover.1301542804.git.larry@elder-gods.org>
Cc: larry@elder-gods.org, "Yan Zheng" <zheng.z.yan@intel.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1301542804.git.larry@elder-gods.org>
In-Reply-To: <cover.1301542804.git.larry@elder-gods.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Larry D'Anna <larry@elder-gods.org>
---
 fs/btrfs/ioctl.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f9717b6..10095c7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1804,6 +1804,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *srcroot;
 	struct file *src_file;
 	struct inode *src;
 	struct btrfs_trans_handle *trans;
@@ -1846,6 +1847,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 
 	src = src_file->f_dentry->d_inode;
+	srcroot = BTRFS_I(src)->root;
 
 	ret = -EINVAL;
 	if (src == inode)
@@ -1860,11 +1862,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		goto out_fput;
 
 	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
+	if (src->i_sb != inode->i_sb)
 		goto out_fput;
 
 	ret = -ENOMEM;
-	buf = vmalloc(btrfs_level_size(root, 0));
+	buf = vmalloc(btrfs_level_size(srcroot, 0));
 	if (!buf)
 		goto out_fput;
 
@@ -1924,13 +1926,13 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, srcroot, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(root, path);
+			ret = btrfs_next_leaf(srcroot, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
-- 
1.7.0.rc2.40.g7d8aa

