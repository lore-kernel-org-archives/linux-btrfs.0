Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3HFSnX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 14:43:23 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@redhat.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/4] btrfs_ioctl_clone: Move clone code into it's own function
Date: Tue,  6 Aug 2013 11:42:49 -0700
Message-Id: <1375814571-31753-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
References: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's some 250+ lines here that are easily encapsulated into their own
function. I don't change how anything works here, just create and document
the new btrfs_clone() function from btrfs_ioctl_clone() code.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 232 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 128 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ef53952..e90c519 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2476,125 +2476,43 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
 	}
 }
 
-static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
-				       u64 off, u64 olen, u64 destoff)
+/**
+ * btrfs_clone() - clone a range from inode file to another
+ *
+ * @src: Inode to clone from
+ * @inode: Inode to clone to
+ * @off: Offset within source to start clone from
+ * @olen: Original length, passed by user, of range to clone
+ * @olen_aligned: Block-aligned value of olen, extent_same uses
+ *               identical values here
+ * @destoff: Offset within @inode to start clone
+ */
+static int btrfs_clone(struct inode *src, struct inode *inode,
+		       u64 off, u64 olen, u64 olen_aligned, u64 destoff)
 {
-	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct fd src_file;
-	struct inode *src;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_path *path;
+	struct btrfs_path *path = NULL;
 	struct extent_buffer *leaf;
-	char *buf;
+	struct btrfs_trans_handle *trans;
+	char *buf = NULL;
 	struct btrfs_key key;
 	u32 nritems;
 	int slot;
 	int ret;
-	u64 len = olen;
-	u64 bs = root->fs_info->sb->s_blocksize;
-
-	/*
-	 * TODO:
-	 * - split compressed inline extents.  annoying: we need to
-	 *   decompress into destination's address_space (the file offset
-	 *   may change, so source mapping won't do), then recompress (or
-	 *   otherwise reinsert) a subrange.
-	 * - allow ranges within the same file to be cloned (provided
-	 *   they don't overlap)?
-	 */
-
-	/* the destination must be opened for writing */
-	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
-		return -EINVAL;
-
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-
-	ret = mnt_want_write_file(file);
-	if (ret)
-		return ret;
-
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		ret = -EBADF;
-		goto out_drop_write;
-	}
-
-	ret = -EXDEV;
-	if (src_file.file->f_path.mnt != file->f_path.mnt)
-		goto out_fput;
-
-	src = file_inode(src_file.file);
-
-	ret = -EINVAL;
-	if (src == inode)
-		goto out_fput;
-
-	/* the src must be open for reading */
-	if (!(src_file.file->f_mode & FMODE_READ))
-		goto out_fput;
-
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		goto out_fput;
-
-	ret = -EISDIR;
-	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
-		goto out_fput;
-
-	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb)
-		goto out_fput;
+	u64 len = olen_aligned;
 
 	ret = -ENOMEM;
 	buf = vmalloc(btrfs_level_size(root, 0));
 	if (!buf)
-		goto out_fput;
+		return ret;
 
 	path = btrfs_alloc_path();
 	if (!path) {
 		vfree(buf);
-		goto out_fput;
-	}
-	path->reada = 2;
-
-	if (inode < src) {
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
-	} else {
-		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-	}
-
-	/* determine range to clone */
-	ret = -EINVAL;
-	if (off + len > src->i_size || off + len < off)
-		goto out_unlock;
-	if (len == 0)
-		olen = len = src->i_size - off;
-	/* if we extend to eof, continue to block boundary */
-	if (off + len == src->i_size)
-		len = ALIGN(src->i_size, bs) - off;
-
-	/* verify the end result is block aligned */
-	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
-	    !IS_ALIGNED(destoff, bs))
-		goto out_unlock;
-
-	if (destoff > inode->i_size) {
-		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
-		if (ret)
-			goto out_unlock;
+		return ret;
 	}
 
-	/* truncate page cache pages from target inode range */
-	truncate_inode_pages_range(&inode->i_data, destoff,
-				   PAGE_CACHE_ALIGN(destoff + len) - 1);
-
-	lock_extent_range(src, off, len);
-
+	path->reada = 2;
 	/* clone data */
 	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -2840,14 +2758,120 @@ next:
 		key.offset++;
 	}
 	ret = 0;
+
 out:
 	btrfs_release_path(path);
+	btrfs_free_path(path);
+	vfree(buf);
+	return ret;
+}
+
+static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
+				       u64 off, u64 olen, u64 destoff)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct fd src_file;
+	struct inode *src;
+	int ret;
+	u64 len = olen;
+	u64 bs = root->fs_info->sb->s_blocksize;
+
+	/*
+	 * TODO:
+	 * - split compressed inline extents.  annoying: we need to
+	 *   decompress into destination's address_space (the file offset
+	 *   may change, so source mapping won't do), then recompress (or
+	 *   otherwise reinsert) a subrange.
+	 * - allow ranges within the same file to be cloned (provided
+	 *   they don't overlap)?
+	 */
+
+	/* the destination must be opened for writing */
+	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
+		return -EINVAL;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	src_file = fdget(srcfd);
+	if (!src_file.file) {
+		ret = -EBADF;
+		goto out_drop_write;
+	}
+
+	ret = -EXDEV;
+	if (src_file.file->f_path.mnt != file->f_path.mnt)
+		goto out_fput;
+
+	src = src_file.file->f_dentry->d_inode;
+
+	ret = -EINVAL;
+	if (src == inode)
+		goto out_fput;
+
+	/* the src must be open for reading */
+	if (!(src_file.file->f_mode & FMODE_READ))
+		goto out_fput;
+
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
+		goto out_fput;
+
+	ret = -EISDIR;
+	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
+		goto out_fput;
+
+	ret = -EXDEV;
+	if (src->i_sb != inode->i_sb)
+		goto out_fput;
+
+	if (inode < src) {
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
+	} else {
+		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+	}
+
+	/* determine range to clone */
+	ret = -EINVAL;
+	if (off + len > src->i_size || off + len < off)
+		goto out_unlock;
+	if (len == 0)
+		olen = len = src->i_size - off;
+	/* if we extend to eof, continue to block boundary */
+	if (off + len == src->i_size)
+		len = ALIGN(src->i_size, bs) - off;
+
+	/* verify the end result is block aligned */
+	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
+	    !IS_ALIGNED(destoff, bs))
+		goto out_unlock;
+
+	if (destoff > inode->i_size) {
+		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
+		if (ret)
+			goto out_unlock;
+	}
+
+	/* truncate page cache pages from target inode range */
+	truncate_inode_pages_range(&inode->i_data, destoff,
+				   PAGE_CACHE_ALIGN(destoff + len) - 1);
+
+	lock_extent_range(src, off, len);
+
+	ret = btrfs_clone(src, inode, off, olen, len, destoff);
+
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
-	vfree(buf);
-	btrfs_free_path(path);
 out_fput:
 	fdput(src_file);
 out_drop_write:
-- 
1.8.1.4

