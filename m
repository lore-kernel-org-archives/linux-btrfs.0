Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485Ab3DPWO0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 18:14:26 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, chris.mason@fusionio.com,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 4/4] btrfs: offline dedupe
Date: Tue, 16 Apr 2013 15:15:35 -0700
Message-Id: <1366150535-18750-5-git-send-email-mfasheh@suse.de>
In-Reply-To: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
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
 fs/btrfs/ioctl.c |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   28 +++++-
 2 files changed, 299 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d237447..7cad49e 100644
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
@@ -2412,6 +2415,61 @@ out:
 	return ret;
 }
 
+static noinline int fill_data(struct inode *inode, u64 off, u64 len,
+			      char **cur_buffer)
+{
+	struct page *page;
+	void *addr;
+	char *buffer;
+	pgoff_t index;
+	pgoff_t last_index;
+	int ret = 0;
+	int bytes_copied = 0;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+
+	buffer = kmalloc(len, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
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
+	*cur_buffer = buffer;
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
@@ -2432,6 +2490,218 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
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
+			     struct inode *dst, u64 dst_loff)
+{
+	char *orig_buffer = NULL;
+	char *dst_inode_buffer = NULL;
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
+	ret = fill_data(src, loff, len, &orig_buffer);
+	if (ret) {
+		printk(KERN_ERR "btrfs: unable to source populate data "
+		       "buffer.\n");
+		goto out;
+	}
+
+	ret = fill_data(dst, dst_loff, len, &dst_inode_buffer);
+	if (ret) {
+		printk(KERN_ERR "btrfs: unable to populate destination data "
+		       "buffer.\n");
+		goto out;
+	}
+
+	ret = memcmp(orig_buffer, dst_inode_buffer, len);
+	if (ret) {
+		ret = BTRFS_SAME_DATA_DIFFERS;
+		printk(KERN_ERR "btrfs: data for inode %lu does not "
+		       "match\n", dst->i_ino);
+		goto out;
+	}
+
+	ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
+
+out:
+	btrfs_double_unlock(src, loff, dst, dst_loff, len);
+
+	kfree(dst_inode_buffer);
+	kfree(orig_buffer);
+	return ret;
+}
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
+
+	if (copy_from_user(&tmp,
+			   (struct btrfs_ioctl_same_args __user *)argp,
+			   sizeof(tmp)))
+		return -EFAULT;
+
+	args_size = sizeof(tmp) + (tmp.total_files *
+			sizeof(struct btrfs_ioctl_same_extent_info));
+
+	/* Keep size of ioctl argument sane */
+	if (args_size > PAGE_CACHE_SIZE)
+		return -ENOMEM;
+
+	args = kmalloc(args_size, GFP_NOFS);
+	if (!args)
+		return -ENOMEM;
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
+	if ((sizeof(tmp) + (sizeof(*info) * args->total_files)) > args_size)
+		goto out;
+
+	/* pre-format 'out' fields to sane default values */
+	args->files_deduped = 0;
+	for (i = 0; i < args->total_files; i++) {
+		info = &args->info[i];
+		info->bytes_deduped = 0;
+		info->status = 0;
+	}
+
+	off = args->logical_offset;
+	len = args->length;
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
+	/*
+	 * Since we have to memcmp the data to make sure it does actually match
+	 * eachother we need to allocate 2 buffers to handle this.  So limit the
+	 * blocksize to 1 megabyte to make sure nobody abuses this.
+	 */ 
+	ret = -ENOMEM;
+	if (len > 1 * 1024 * 1024)
+		goto out;
+
+	ret = 0;
+	for (i = 0; i < args->total_files; i++) {
+		u64 dest_off;
+
+		info = &args->info[i];
+
+		dst_file = fget(info->fd);
+		if (!dst_file) {
+			printk(KERN_ERR "btrfs: invalid fd %lld\n", info->fd);
+			info->status = -EBADF;
+			continue;
+		}
+
+		dst = dst_file->f_dentry->d_inode;
+		if (S_ISDIR(dst->i_mode)) {
+			printk(KERN_ERR "btrfs: file is dir %lld\n", info->fd);
+			info->status = -EISDIR;
+			goto next;
+		}
+
+		info->status = -EINVAL;
+		if (dst == src) {
+			printk(KERN_ERR "btrfs: file dup %lld\n", info->fd);
+			goto next;
+		}
+
+		if (BTRFS_I(dst)->root != BTRFS_I(src)->root) {
+			printk(KERN_ERR "btrfs: cannot dedup across subvolumes"
+			       " %lld\n", info->fd);
+			goto next;
+		}
+
+		dest_off = info->logical_offset;
+
+		if (dest_off + len > dst->i_size || dest_off + len < dest_off)
+			goto next;
+		if (!IS_ALIGNED(dest_off, bs))
+			goto next;
+
+		info->status = btrfs_extent_same(src, off, len, dst,
+						 info->logical_offset);
+		if (info->status == 0) {
+			info->bytes_deduped = len;
+			args->files_deduped++;
+		} else {
+			printk(KERN_ERR "error %d from btrfs_extent_same\n",
+				info->status);
+		}
+next:
+		fput(dst_file);
+		dst_file = NULL;
+	}
+
+	if (copy_to_user(argp, args, args_size))
+		ret = -EFAULT;
+
+out:
+	if (dst_file)
+		fput(dst_file);
+	kfree(args);
+	return ret;
+}
+
 /**
  * btrfs_clone() - clone a range from inode file to another
  *
@@ -4044,6 +4314,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_limit(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(root, argp);
+	case BTRFS_IOC_FILE_EXTENT_SAME:
+		return btrfs_ioctl_file_extent_same(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index dabca9c..445e448 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -304,6 +304,31 @@ struct btrfs_ioctl_clone_range_args {
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
+	__u16 total_files;	/* in - total elements in info array */
+	__u16 files_deduped;	/* out - number of files that got deduped */
+	__u32 reserved;
+	struct btrfs_ioctl_same_extent_info info[0];
+};
+
 struct btrfs_ioctl_space_info {
 	__u64 flags;
 	__u64 total_bytes;
@@ -498,5 +523,6 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
-
+#define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+					 struct btrfs_ioctl_same_args)
 #endif
-- 
1.7.10.4

