From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 1/2]btrfs: add an ioctl to dump metadata info
Date: Wed, 14 Jul 2010 16:02:21 +0800
Message-ID: <1279094541.1528.94.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add an ioctl to dump btrfs btree_inode's existing pages. Userspace collects such
info and uses it to do metadata readahead.

we only account updated and referenced pages here. Say we collect metadata info
in one boot, do metadata readahead in next boot and we might collect metadata
again. The readahead could read garbage data in as metadata could be changed
from first run. If we only account updated pages, the metadata info collected
by userspace will increase every run. Btrfs alloc_extent_buffer will do
mark_page_accessed() for pages which will be used soon, so we could use
referenced bit to filter some garbage pages.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/ioctl.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   15 +++++++
 2 files changed, 120 insertions(+)

Index: linux/fs/btrfs/ioctl.c
===================================================================
--- linux.orig/fs/btrfs/ioctl.c	2010-07-14 09:58:20.000000000 +0800
+++ linux/fs/btrfs/ioctl.c	2010-07-14 10:13:55.000000000 +0800
@@ -40,6 +40,7 @@
 #include <linux/xattr.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -1974,6 +1975,108 @@ long btrfs_ioctl_trans_end(struct file *
 	return 0;
 }
 
+/*
+ * return value:
+ * > 0: entries put to user space vector
+ * = 0: no entries
+ * < 0: error
+ */
+static long btrfs_ioctl_meta_incore(struct btrfs_root *root, void __user *argp)
+{
+	struct inode *btree_inode = root->fs_info->btree_inode;
+	struct btrfs_ioctl_meta_incore_args args;
+	struct btrfs_ioctl_meta_incore_ent ent;
+	struct pagevec pvec;
+	__u64 index, last_begin, last_end;
+	__u64 __user vec_addr;
+	int start = 0, i, nr_pages, entries = 0;
+
+	if (copy_from_user(&args,
+	   (struct btrfs_ioctl_meta_incore_args __user *)argp,
+	    sizeof(args)))
+		return -EFAULT;
+
+	/* Check the start address: needs to be page-aligned.. */
+	if (args.offset & ~PAGE_CACHE_MASK)
+		return -EINVAL;
+
+	if ((args.vec_size % sizeof(struct btrfs_ioctl_meta_incore_ent)) != 0)
+		return -EINVAL;
+
+	if (!access_ok(VERIFY_WRITE, args.vec_addr, args.vec_size))
+		return -EFAULT;
+
+	index = args.offset >> PAGE_CACHE_SHIFT;
+	last_begin = 0;
+	last_end = 0;
+	ent.unused = 0;
+	vec_addr = args.vec_addr;
+
+	pagevec_init(&pvec, 0);
+	while (vec_addr < args.vec_addr + args.vec_size) {
+		nr_pages = pagevec_lookup(&pvec, btree_inode->i_mapping,
+				index, PAGEVEC_SIZE);
+		if (nr_pages == 0)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+			__u64 page_offset = page->index;
+			int valid;
+
+			index = page_offset + 1;
+
+			/* Only take pages with 'referenced' bit set */
+			valid = PageUptodate(page) && PageReferenced(page);
+			if (valid) {
+				if (!start) {
+					start = 1;
+					last_begin = page_offset;
+					last_end = page_offset + 1;
+					continue;
+				} else if (page_offset == last_end) {
+					last_end = page_offset + 1;
+					continue;
+				}
+			} else if (!start)
+				continue;
+
+			ent.offset = last_begin << PAGE_CACHE_SHIFT;
+			ent.size = (last_end - last_begin) << PAGE_CACHE_SHIFT;
+			if (copy_to_user((void *)(long)vec_addr, &ent,
+			    sizeof(ent))) {
+				pagevec_release(&pvec);
+				return -EFAULT;
+			}
+			vec_addr += sizeof(ent);
+			entries++;
+
+			if (valid) {
+				last_begin = page_offset;
+				last_end = page_offset + 1;
+			} else
+				start = 0;
+
+			if (vec_addr >= args.vec_addr + args.vec_size)
+				break;
+		}
+		pagevec_release(&pvec);
+
+		if (signal_pending(current))
+			return -EINTR;
+		cond_resched();
+	}
+	if (start && last_end > last_begin &&
+			vec_addr < args.vec_addr + args.vec_size) {
+		ent.offset = last_begin << PAGE_CACHE_SHIFT;
+		ent.size = (last_end - last_begin) << PAGE_CACHE_SHIFT;
+		if (copy_to_user((void *)(long)vec_addr, &ent, sizeof(ent)))
+			return -EFAULT;
+		entries++;
+	}
+
+	return entries;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2024,6 +2127,8 @@ long btrfs_ioctl(struct file *file, unsi
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_META_INCORE:
+		return btrfs_ioctl_meta_incore(root, argp);
 	}
 
 	return -ENOTTY;
Index: linux/fs/btrfs/ioctl.h
===================================================================
--- linux.orig/fs/btrfs/ioctl.h	2010-07-14 09:58:11.000000000 +0800
+++ linux/fs/btrfs/ioctl.h	2010-07-14 10:14:22.000000000 +0800
@@ -138,6 +138,19 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_meta_incore_ent {
+	__u64 offset;
+	__u32 size;
+	__u32 unused;
+};
+
+struct btrfs_ioctl_meta_incore_args {
+	__u64 offset; /* offset in meta address */
+	__u64 __user vec_addr; /* vector's address */
+	__u32 vec_size; /* vector's size */
+	__u32 unused;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -178,4 +191,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_META_INCORE _IOW(BTRFS_IOCTL_MAGIC, 21, \
+				   struct btrfs_ioctl_meta_incore_args)
 #endif


