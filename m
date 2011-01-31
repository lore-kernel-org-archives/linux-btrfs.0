From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: convert to the new truncate sequence V2
Date: Mon, 31 Jan 2011 16:27:37 -0500
Message-ID: <1296509257-27754-1-git-send-email-josef@redhat.com>
References: <1296507026-26230-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296507026-26230-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

->truncate() is going away, instead all of the work needs to be done in
->setattr().  So this converts us over to do this.  It's fairly straightforward,
just get rid of our .truncate inode operation and call btrfs_truncate() directly
from btrfs_setsize.  This works out better for us since truncate can technically
return ENOSPC, and before we had no way of letting anybody know.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: in btrfs_orphan_cleanup, call btrfs_truncate and WARN if the file is not
regular, since we took that check out of btrfs_truncate

 fs/btrfs/inode.c |   76 ++++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2808d0b..200075f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -84,7 +84,8 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
 
-static void btrfs_truncate(struct inode *inode);
+static int btrfs_setsize(struct inode *inode, loff_t newsize);
+static int btrfs_truncate(struct inode *inode);
 static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
@@ -2364,6 +2365,11 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
+			if (!S_ISREG(inode->i_mode)) {
+				WARN_ON(1);
+				iput(inode);
+				continue;
+			}
 			nr_truncate++;
 			btrfs_truncate(inode);
 		} else {
@@ -3609,27 +3615,17 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	return err;
 }
 
-static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
+static int btrfs_setsize(struct inode *inode, loff_t newsize)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
+	loff_t oldsize = i_size_read(inode);
 	unsigned long nr;
 	int ret;
 
-	if (attr->ia_size == inode->i_size)
+	if (newsize == oldsize)
 		return 0;
 
-	if (attr->ia_size > inode->i_size) {
-		unsigned long limit;
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-		if (attr->ia_size > inode->i_sb->s_maxbytes)
-			return -EFBIG;
-		if (limit != RLIM_INFINITY && attr->ia_size > limit) {
-			send_sig(SIGXFSZ, current, 0);
-			return -EFBIG;
-		}
-	}
-
 	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -3643,16 +3639,16 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 
-	if (attr->ia_size > inode->i_size) {
-		ret = btrfs_cont_expand(inode, attr->ia_size);
+	if (newsize > oldsize) {
+		i_size_write(inode, newsize);
+		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		truncate_pagecache(inode, oldsize, newsize);
+		ret = btrfs_cont_expand(inode, newsize);
 		if (ret) {
-			btrfs_truncate(inode);
+			btrfs_setsize(inode, oldsize);
 			return ret;
 		}
 
-		i_size_write(inode, attr->ia_size);
-		btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
-
 		trans = btrfs_start_transaction(root, 0);
 		BUG_ON(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
@@ -3668,22 +3664,22 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root, nr);
-		return 0;
-	}
+	} else {
 
-	/*
-	 * We're truncating a file that used to have good data down to
-	 * zero. Make sure it gets into the ordered flush list so that
-	 * any new writes get down to disk quickly.
-	 */
-	if (attr->ia_size == 0)
-		BTRFS_I(inode)->ordered_data_close = 1;
+		/*
+		 * We're truncating a file that used to have good data down to
+		 * zero. Make sure it gets into the ordered flush list so that
+		 * any new writes get down to disk quickly.
+		 */
+		if (newsize == 0)
+			BTRFS_I(inode)->ordered_data_close = 1;
 
-	/* we don't support swapfiles, so vmtruncate shouldn't fail */
-	ret = vmtruncate(inode, attr->ia_size);
-	BUG_ON(ret);
+		/* we don't support swapfiles, so vmtruncate shouldn't fail */
+		truncate_setsize(inode, newsize);
+		ret = btrfs_truncate(inode);
+	}
 
-	return 0;
+	return ret;
 }
 
 static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
@@ -3700,7 +3696,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 		return err;
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		err = btrfs_setattr_size(inode, attr);
+		err = btrfs_setsize(inode, attr->ia_size);
 		if (err)
 			return err;
 	}
@@ -6341,7 +6337,7 @@ out:
 	return ret;
 }
 
-static void btrfs_truncate(struct inode *inode)
+static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -6349,14 +6345,9 @@ static void btrfs_truncate(struct inode *inode)
 	unsigned long nr;
 	u64 mask = root->sectorsize - 1;
 
-	if (!S_ISREG(inode->i_mode)) {
-		WARN_ON(1);
-		return;
-	}
-
 	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
 	if (ret)
-		return;
+		return ret;
 
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
@@ -6431,6 +6422,8 @@ static void btrfs_truncate(struct inode *inode)
 	ret = btrfs_end_transaction_throttle(trans, root);
 	BUG_ON(ret);
 	btrfs_btree_balance_dirty(root, nr);
+
+	return ret;
 }
 
 /*
@@ -7230,7 +7223,6 @@ static const struct address_space_operations btrfs_symlink_aops = {
 };
 
 static const struct inode_operations btrfs_file_inode_operations = {
-	.truncate	= btrfs_truncate,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.setxattr	= btrfs_setxattr,
-- 
1.7.2.3

