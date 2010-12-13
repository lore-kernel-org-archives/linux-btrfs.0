From: Shaohua Li <shaohua.li@intel.com>
Subject: [RFC 4/5] implement metadata_ra in btrfs
Date: Mon, 13 Dec 2010 15:22:16 +0800
Message-ID: <1292224936.2323.453.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Implementation btrfs .metadata_readahead. In btrfs, all metadata pages are in a
special btree_inode. We do readahead in it.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/disk-io.c |   10 ++++++++++
 fs/btrfs/super.c   |   13 +++++++++++++
 mm/readahead.c     |    1 +
 3 files changed, 24 insertions(+)

Index: linux/fs/btrfs/disk-io.c
===================================================================
--- linux.orig/fs/btrfs/disk-io.c	2010-12-07 13:32:24.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2010-12-07 13:33:08.000000000 +0800
@@ -776,6 +776,15 @@ static int btree_readpage(struct file *f
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
@@ -819,6 +828,7 @@ static void btree_invalidatepage(struct
 
 static const struct address_space_operations btree_aops = {
 	.readpage	= btree_readpage,
+	.readpages	= btree_readpages,
 	.writepage	= btree_writepage,
 	.writepages	= btree_writepages,
 	.releasepage	= btree_releasepage,
Index: linux/fs/btrfs/super.c
===================================================================
--- linux.orig/fs/btrfs/super.c	2010-12-07 13:32:24.000000000 +0800
+++ linux/fs/btrfs/super.c	2010-12-07 13:33:08.000000000 +0800
@@ -892,6 +892,18 @@ out:
 		return -ENOENT;
 }
 
+static int btrfs_metadata_readahead(struct super_block *sb, loff_t offset,
+	ssize_t size)
+{
+	struct btrfs_root *tree_root = btrfs_sb(sb);
+	struct inode *btree_inode = tree_root->fs_info->btree_inode;
+	struct address_space *mapping = btree_inode->i_mapping;
+
+	force_page_cache_readahead(mapping, NULL, offset >> PAGE_CACHE_SHIFT,
+		size >> PAGE_CACHE_SHIFT);
+	return 0;
+}
+
 static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
@@ -907,6 +919,7 @@ static const struct super_operations btr
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
 	.metadata_incore = btrfs_metadata_incore,
+	.metadata_readahead = btrfs_metadata_readahead,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
Index: linux/mm/readahead.c
===================================================================
--- linux.orig/mm/readahead.c	2010-12-07 13:32:24.000000000 +0800
+++ linux/mm/readahead.c	2010-12-07 13:33:08.000000000 +0800
@@ -228,6 +228,7 @@ int force_page_cache_readahead(struct ad
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(force_page_cache_readahead);
 
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a


