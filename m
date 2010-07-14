From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 2/2]btrfs: add an ioctl to do metadata readahead
Date: Wed, 14 Jul 2010 16:02:24 +0800
Message-ID: <1279094544.1528.95.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add metadata readahead ioctl.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/disk-io.c |   10 ++++++++++
 fs/btrfs/ioctl.c   |   23 +++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    7 +++++++
 mm/readahead.c     |    1 +
 4 files changed, 41 insertions(+)

Index: linux/mm/readahead.c
===================================================================
--- linux.orig/mm/readahead.c	2010-07-14 10:13:55.000000000 +0800
+++ linux/mm/readahead.c	2010-07-14 10:14:47.000000000 +0800
@@ -228,6 +228,7 @@ int force_page_cache_readahead(struct ad
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(force_page_cache_readahead);
 
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
Index: linux/fs/btrfs/disk-io.c
===================================================================
--- linux.orig/fs/btrfs/disk-io.c	2010-07-14 10:17:39.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2010-07-14 10:22:33.000000000 +0800
@@ -746,6 +746,15 @@ static int btree_readpage(struct file *f
 	return extent_read_full_page(tree, page, btree_get_extent);
 }
 
+static int btree_readpages(struct file *file, struct address_space *mapping,
+		struct list_head *pages, unsigned nr_pages)
+{
+	struct extent_io_tree *tree;
+	tree = &BTRFS_I(mapping->host)->io_tree;
+	return extent_readpages(tree, mapping, pages, nr_pages,
+			btree_get_extent);
+}
+
 static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	struct extent_io_tree *tree;
@@ -789,6 +798,7 @@ static void btree_invalidatepage(struct 
 
 static const struct address_space_operations btree_aops = {
 	.readpage	= btree_readpage,
+	.readpages	= btree_readpages,
 	.writepage	= btree_writepage,
 	.writepages	= btree_writepages,
 	.releasepage	= btree_releasepage,
Index: linux/fs/btrfs/ioctl.c
===================================================================
--- linux.orig/fs/btrfs/ioctl.c	2010-07-14 10:15:55.000000000 +0800
+++ linux/fs/btrfs/ioctl.c	2010-07-14 10:17:25.000000000 +0800
@@ -2077,6 +2077,27 @@ static long btrfs_ioctl_meta_incore(stru
 	return entries;
 }
 
+static long btrfs_ioctl_meta_readahead(struct btrfs_root *root,
+		void __user *argp)
+{
+	struct inode *btree_inode = root->fs_info->btree_inode;
+	struct address_space *mapping = btree_inode->i_mapping;
+	struct btrfs_ioctl_meta_readahead_args args;
+	pgoff_t index;
+	unsigned long nr_to_read;
+
+	if (copy_from_user(&args,
+	  (struct btrfs_ioctl_meta_readahead_args __user *)argp, sizeof(args)))
+		return -EFAULT;
+
+	index = args.offset >> PAGE_CACHE_SHIFT;
+	nr_to_read = (args.offset + args.size - 1) >> PAGE_CACHE_SHIFT;
+	nr_to_read = nr_to_read - index + 1;
+
+	force_page_cache_readahead(mapping, NULL, index, nr_to_read);
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2129,6 +2150,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return 0;
 	case BTRFS_IOC_META_INCORE:
 		return btrfs_ioctl_meta_incore(root, argp);
+	case BTRFS_IOC_META_READAHEAD:
+		return btrfs_ioctl_meta_readahead(root, argp);
 	}
 
 	return -ENOTTY;
Index: linux/fs/btrfs/ioctl.h
===================================================================
--- linux.orig/fs/btrfs/ioctl.h	2010-07-14 10:14:55.000000000 +0800
+++ linux/fs/btrfs/ioctl.h	2010-07-14 10:15:53.000000000 +0800
@@ -151,6 +151,11 @@ struct btrfs_ioctl_meta_incore_args {
 	__u32 unused;
 };
 
+struct btrfs_ioctl_meta_readahead_args {
+	__u64 offset;
+	__u64 size;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -193,4 +198,6 @@ struct btrfs_ioctl_meta_incore_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_META_INCORE _IOW(BTRFS_IOCTL_MAGIC, 21, \
 				   struct btrfs_ioctl_meta_incore_args)
+#define BTRFS_IOC_META_READAHEAD _IOW(BTRFS_IOCTL_MAGIC, 22, \
+				      struct btrfs_ioctl_meta_readahead_args)
 #endif


