Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab3FKUdC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 16:33:02 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 4/4] btrfs: offline dedupe
Date: Tue, 11 Jun 2013 13:31:38 -0700
Message-Id: <1370982698-757-5-git-send-email-mfasheh@suse.de>
In-Reply-To: <1370982698-757-1-git-send-email-mfasheh@suse.de>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an ioctl, BTRFS_IOC_FILE_EXTENT_SAME which will try to
de-duplicate a list of extents across a range of files.

Internally, the ioctl re-uses code from the clone ioctl. This avoids
rewriting a large chunk of extent handling code.

Userspace passes in an array of file, offset pairs along with a length
argument. The ioctl will then (for each dedupe) do a byte-by-byte comparison
of the user data before deduping the extent. Status and number of bytes
deduped are returned for each operation.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c           | 329 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  27 ++++
 2 files changed, 356 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e90c519..9351b69 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -57,6 +57,9 @@
 #include "send.h"
 #include "dev-replace.h"
 
+static int btrfs_clone(struct inode *src, struct inode *inode,
+		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
+
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
 {
@@ -2456,6 +2459,54 @@ out:
 	return ret;
 }
 
+static noinline int fill_data(struct inode *inode, u64 off, u64 len,
+			      char *buffer)
+{
+	struct page *page;
+	void *addr;
+	pgoff_t index;
+	pgoff_t last_index;
+	int ret = 0;
+	int bytes_copied = 0;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+
+	index = off >> PAGE_CACHE_SHIFT;
+	last_index = (off + len - 1) >> PAGE_CACHE_SHIFT;
+
+	while (index <= last_index) {
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!PageUptodate(page)) {
+			extent_read_full_page_nolock(tree, page,
+						     btrfs_get_extent, 0);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+
+		addr = kmap(page);
+		memcpy(buffer + bytes_copied, addr, PAGE_CACHE_SIZE);
+		kunmap(page);
+		unlock_page(page);
+		page_cache_release(page);
+		bytes_copied += PAGE_CACHE_SIZE;
+		index++;
+	}
+
+out:
+	if (ret)
+		kfree(buffer);
+	return ret;
+}
+
 static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
 {
 	/* do any pending delalloc/csum calc on src, one way or
@@ -2476,6 +2527,282 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
 	}
 }
 
+static void btrfs_double_unlock(struct inode *inode1, u64 loff1,
+				struct inode *inode2, u64 loff2, u64 len)
+{
+	unlock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
+	unlock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
+
+	mutex_unlock(&inode1->i_mutex);
+	mutex_unlock(&inode2->i_mutex);
+}
+
+static void btrfs_double_lock(struct inode *inode1, u64 loff1,
+			      struct inode *inode2, u64 loff2, u64 len)
+{
+	if (inode1 < inode2) {
+		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
+		lock_extent_range(inode1, loff1, len);
+		lock_extent_range(inode2, loff2, len);
+	} else {
+		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
+		lock_extent_range(inode2, loff2, len);
+		lock_extent_range(inode1, loff1, len);
+	}
+}
+
+static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
+			     struct inode *dst, u64 dst_loff,
+			     char *src_buffer, char *dst_buffer)
+{
+	int ret;
+
+	/*
+	 * btrfs_clone() can't handle extents in the same file
+	 * yet. Once that works, we can drop this check and replace it
+	 * with a check for the same inode, but overlapping extents.
+	 */
+	if (src == dst)
+		return -EINVAL;
+
+	btrfs_double_lock(src, loff, dst, dst_loff, len);
+
+	ret = fill_data(src, loff, len, src_buffer);
+	if (ret)
+		goto out;
+
+	ret = fill_data(dst, dst_loff, len, dst_buffer);
+	if (ret)
+		goto out;
+
+	ret = memcmp(src_buffer, dst_buffer, len);
+	if (ret) {
+		ret = BTRFS_SAME_DATA_DIFFERS;
+		goto out;
+	}
+
+	ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
+
+out:
+	btrfs_double_unlock(src, loff, dst, dst_loff, len);
+
+	return ret;
+}
+
+static void *btrfs_kvmalloc(size_t size, gfp_t flags)
+{
+	void *ret;
+
+	ret = kmalloc(size, flags);
+	if (!ret)
+		ret = __vmalloc(size, flags, PAGE_KERNEL);
+	return ret;
+}
+
+static void btrfs_kvfree(void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+}
+
+#define BTRFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
+#define BTRFS_ONE_DEDUPE_LEN	(1 * 1024 * 1024)
+
+static long btrfs_ioctl_file_extent_same(struct file *file,
+					 void __user *argp)
+{
+	struct btrfs_ioctl_same_args *args;
+	struct btrfs_ioctl_same_args tmp;
+	struct btrfs_ioctl_same_extent_info *info;
+	struct inode *src = file->f_dentry->d_inode;
+	struct file *dst_file = NULL;
+	struct inode *dst;
+	u64 off;
+	u64 len;
+	int args_size;
+	int i;
+	int ret;
+	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
+	char *src_buffer = NULL;
+	char *dst_buffer = NULL;
+
+	if (!(file->f_mode & FMODE_READ))
+		return -EINVAL;
+
+	if (btrfs_root_readonly(BTRFS_I(src)->root))
+		return -EROFS;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(&tmp,
+			   (struct btrfs_ioctl_same_args __user *)argp,
+			   sizeof(tmp))) {
+		ret = -EFAULT;
+		goto out_drop_write;
+	}
+
+	args_size = sizeof(tmp) + (tmp.dest_count *
+			sizeof(struct btrfs_ioctl_same_extent_info));
+
+	/* Keep size of ioctl argument sane */
+	if (args_size > PAGE_CACHE_SIZE) {
+		ret = -E2BIG;
+		goto out_drop_write;
+	}
+
+	args = kmalloc(args_size, GFP_NOFS);
+	if (!args) {
+		ret = -ENOMEM;
+		goto out_drop_write;
+	}
+
+	ret = -EFAULT;
+	if (copy_from_user(args,
+			   (struct btrfs_ioctl_same_args __user *)argp,
+			   args_size))
+		goto out;
+	/* Make sure args didn't change magically between copies. */
+	if (memcmp(&tmp, args, sizeof(tmp)))
+		goto out;
+
+	if ((sizeof(tmp) + (sizeof(*info) * args->dest_count)) > args_size)
+		goto out;
+
+	/* pre-format 'out' fields to sane default values */
+	for (i = 0; i < args->dest_count; i++) {
+		info = &args->info[i];
+		info->bytes_deduped = 0;
+		info->status = 0;
+	}
+
+	off = args->logical_offset;
+	len = args->length;
+
+	/*
+	 * Limit the total length we will dedupe for each operation. 
+	 * This is intended to bound the entire ioctl to something sane.
+	 */
+	if (len > BTRFS_MAX_DEDUPE_LEN)
+		len = BTRFS_MAX_DEDUPE_LEN;
+
+	ret = -EINVAL;
+	if (off + len > src->i_size || off + len < off)
+		goto out;
+	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
+		goto out;
+
+	ret = -EISDIR;
+	if (S_ISDIR(src->i_mode))
+		goto out;
+
+	src_buffer = btrfs_kvmalloc(len, GFP_NOFS);
+	dst_buffer = btrfs_kvmalloc(len, GFP_NOFS);
+	if (!src_buffer || !dst_buffer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = 0;
+	for (i = 0; i < args->dest_count; i++) {
+		u64 dest_off;
+		u64 src_off;
+		u64 op_len;
+
+		info = &args->info[i];
+
+		dst_file = fget(info->fd);
+		if (!dst_file) {
+			info->status = -EBADF;
+			continue;
+		}
+
+		if (!(dst_file->f_mode & FMODE_WRITE)) {
+			info->status = -EINVAL;
+			goto next;
+		}
+
+		info->status = -EXDEV;
+		if (file->f_path.mnt != dst_file->f_path.mnt)
+			goto next;
+
+		dst = dst_file->f_dentry->d_inode;
+		if (src->i_sb != dst->i_sb)
+			goto next;
+
+		if (S_ISDIR(dst->i_mode)) {
+			info->status = -EISDIR;
+			goto next;
+		}
+
+		info->status = -EINVAL;
+		/* don't make the dst file partly checksummed */
+		if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+		    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
+			goto next;
+
+		dest_off = info->logical_offset;
+		if (dest_off + len > dst->i_size || dest_off + len < dest_off)
+			goto next;
+		if (!IS_ALIGNED(dest_off, bs))
+			goto next;
+
+		/*
+		 * The purpose of this loop is to limit the number of
+		 * bytes we dedupe during a single call to
+		 * btrfs_extent_same().
+		 *
+		 * In order to memcmp the data we have to allocate a
+		 * pair of buffers. We don't want to allocate too
+		 * large a buffer, so limiting the size for each
+		 * dedupe is an easy way to do this.
+		 */
+		src_off = off;
+		op_len = len;
+		while (op_len) {
+			u64 tmp_len;
+
+			tmp_len = op_len;
+			if (op_len > BTRFS_ONE_DEDUPE_LEN)
+				tmp_len = BTRFS_ONE_DEDUPE_LEN;
+
+			info->status = btrfs_extent_same(src, src_off, tmp_len,
+							 dst, dest_off,
+							 src_buffer, dst_buffer);
+			if (info->status == 0) {
+				info->bytes_deduped += tmp_len;
+			} else
+				break;
+
+			dest_off += tmp_len;
+			src_off += tmp_len;
+			op_len -= tmp_len;
+		}
+
+next:
+		fput(dst_file);
+		dst_file = NULL;
+	}
+
+	if (copy_to_user(argp, args, args_size))
+		ret = -EFAULT;
+
+out:
+	btrfs_kvfree(src_buffer);
+	btrfs_kvfree(dst_buffer);
+	if (dst_file)
+		fput(dst_file);
+	kfree(args);
+out_drop_write:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 /**
  * btrfs_clone() - clone a range from inode file to another
  *
@@ -4151,6 +4478,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_FILE_EXTENT_SAME:
+		return btrfs_ioctl_file_extent_same(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..5465bc2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -305,6 +305,31 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
 
+#define BTRFS_SAME_DATA_DIFFERS	1
+/* For extent-same ioctl */
+struct btrfs_ioctl_same_extent_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == BTRFS_SAME_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+struct btrfs_ioctl_same_args {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct btrfs_ioctl_same_extent_info info[0];
+};
+
 struct btrfs_ioctl_space_info {
 	__u64 flags;
 	__u64 total_bytes;
@@ -510,5 +535,7 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+					 struct btrfs_ioctl_same_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.1.4

