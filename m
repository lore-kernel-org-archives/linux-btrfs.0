From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: convert to the new truncate sequence V2
Date: Fri,  4 Mar 2011 14:58:51 -0500
Message-ID: <1299268731-3983-1-git-send-email-josef@redhat.com>
References: <1299268540-3918-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299268540-3918-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Argh it helps if I send the right damn patch...

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e4802f1..6e86afe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2528,7 +2528,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 				struct btrfs_pending_snapshot *pending);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
-int btrfs_cont_expand(struct inode *inode, loff_t size);
+int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
 int btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_root *root);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 275481a..44ebd50 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -782,7 +782,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
 
 	if (start_pos > inode->i_size) {
-		err = btrfs_cont_expand(inode, start_pos);
+		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
 		if (err)
 			return err;
 	}
@@ -1327,7 +1327,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 		goto out;
 
 	if (alloc_start > inode->i_size) {
-		ret = btrfs_cont_expand(inode, alloc_start);
+		ret = btrfs_cont_expand(inode, i_size_read(inode),
+					alloc_start);
 		if (ret)
 			goto out;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ae5fbc3..00e3303 100644
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
@@ -2371,6 +2372,11 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 
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
@@ -3538,7 +3544,7 @@ out:
 	return ret;
 }
 
-int btrfs_cont_expand(struct inode *inode, loff_t size)
+int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3546,7 +3552,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	u64 mask = root->sectorsize - 1;
-	u64 hole_start = (inode->i_size + mask) & ~mask;
+	u64 hole_start = (oldsize + mask) & ~mask;
 	u64 block_end = (size + mask) & ~mask;
 	u64 last_byte;
 	u64 cur_offset;
@@ -3617,27 +3623,17 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
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
@@ -3651,16 +3647,16 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 
-	if (attr->ia_size > inode->i_size) {
-		ret = btrfs_cont_expand(inode, attr->ia_size);
+	if (newsize > oldsize) {
+		i_size_write(inode, newsize);
+		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		truncate_pagecache(inode, oldsize, newsize);
+		ret = btrfs_cont_expand(inode, oldsize, newsize);
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
@@ -3676,22 +3672,22 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
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
@@ -3708,7 +3704,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 		return err;
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		err = btrfs_setattr_size(inode, attr);
+		err = btrfs_setsize(inode, attr->ia_size);
 		if (err)
 			return err;
 	}
@@ -6476,7 +6472,7 @@ out:
 	return ret;
 }
 
-static void btrfs_truncate(struct inode *inode)
+static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -6484,14 +6480,9 @@ static void btrfs_truncate(struct inode *inode)
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
@@ -6566,6 +6557,8 @@ static void btrfs_truncate(struct inode *inode)
 	ret = btrfs_end_transaction_throttle(trans, root);
 	BUG_ON(ret);
 	btrfs_btree_balance_dirty(root, nr);
+
+	return ret;
 }
 
 /*
@@ -7365,7 +7358,6 @@ static const struct address_space_operations btrfs_symlink_aops = {
 };
 
 static const struct inode_operations btrfs_file_inode_operations = {
-	.truncate	= btrfs_truncate,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.setxattr	= btrfs_setxattr,
-- 
1.7.2.3

