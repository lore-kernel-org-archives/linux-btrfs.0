From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Mon, 19 Jul 2010 13:43:23 +0800
Message-ID: <20100719054323.GA26564@sli10-desk.sh.intel.com>
References: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
 <20100714082645.GA32458@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100714082645.GA32458@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 14, 2010 at 04:26:45PM +0800, Shaohua Li wrote:
> On Wed, Jul 14, 2010 at 04:02:16PM +0800, Shaohua Li wrote:
> > Hi,
> >   We have file readahead to do asyn file read, but has no metadata
> > readahead. For a list of files, their metadata is stored in fragmented
> > disk space and metadata read is a sync operation, which impacts the
> > efficiency of readahead much. The patches try to add meatadata readahead
> > for btrfs.
> >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > the inode to a fd so we could use existing syscalls (readahead, mincore
> > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > no easy way for this from my understanding. So we add two ioctls for
> > this. One is like readahead syscall, the other is like micore/fincore
> > syscall.
> >   Under a harddisk based netbook with Meego, the metadata readahead
> > reduced about 3.5s boot time from total 16s.
> > 
> > Issues:
> > 1. it appears readahead metadata pages skipped checksum checking. I'm
> > still working on this.
> > 2. in latest kernel, I got a lockdep warning. It looks not related to
> > the patches but I only observed it with the patches. The warning looks
> > like a false warning, as in my debug the spin_lock isn't hold. from my
> > understanding, all extent_buffer share a lockdep class and in the btree
> > lookup we might lock several extent_buffer. But I don't know how to fix
> > it yet.
> Ha, sorry, actually the two issues are one issue. We set lockdep level class
> and doing checksum in one place. I have a debug patch for this and will
> send out later. But before this, I'd like know your comments about the idea.
Hi Chris,
Below is the patch to fix checksum check skip issue. It's applied after the
two ioctl patches. I did stress test here and can't find any issue. can you
please take a look at the three patches.

Thanks,
Shaohua



Subject: [patch]btrfs: do validation for extent_buffer if it's skipped before

With metadata readahead, we slightly change the behavior. Before it, we allocate
an extent_buffer (so set page->private), do metadata read and
btree_readpage_end_io_hook() will do validation. After it, we directly do
metadata readahead, and since in this case page hasn't ->private,
btree_readpage_end_io_hook() will not do validation. This patch fixes this.
It addes a new flag to indicate if a buffer is validated. If not and even
the buffer is uptodated, we will do a validation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/disk-io.c     |   67 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/disk-io.h     |    2 +
 fs/btrfs/extent-tree.c |    1 
 fs/btrfs/extent_io.c   |   14 ++++++++--
 fs/btrfs/extent_io.h   |    1 
 5 files changed, 58 insertions(+), 27 deletions(-)

Index: linux/fs/btrfs/disk-io.c
===================================================================
--- linux.orig/fs/btrfs/disk-io.c	2010-07-19 10:58:10.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2010-07-19 10:58:13.000000000 +0800
@@ -406,30 +406,18 @@ void btrfs_set_buffer_lockdep_class(stru
 }
 #endif
 
-static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state)
+int btree_validate_extent_buffer(struct btrfs_root *root,
+	struct extent_buffer *eb)
 {
-	struct extent_io_tree *tree;
+	int ret = 0;
 	u64 found_start;
 	int found_level;
-	unsigned long len;
-	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-	int ret = 0;
-
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	if (page->private == EXTENT_PAGE_PRIVATE)
-		goto out;
-	if (!page->private)
-		goto out;
-
-	len = page->private >> 2;
-	WARN_ON(len == 0);
 
-	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+	if (!test_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags))
+		return 0;
 
 	found_start = btrfs_header_bytenr(eb);
-	if (found_start != start) {
+	if (found_start != eb->start) {
 		if (printk_ratelimit()) {
 			printk(KERN_INFO "btrfs bad tree block start "
 			       "%llu %llu\n",
@@ -439,13 +427,7 @@ static int btree_readpage_end_io_hook(st
 		ret = -EIO;
 		goto err;
 	}
-	if (eb->first_page != page) {
-		printk(KERN_INFO "btrfs bad first page %lu %lu\n",
-		       eb->first_page->index, page->index);
-		WARN_ON(1);
-		ret = -EIO;
-		goto err;
-	}
+
 	if (check_tree_block_fsid(root, eb)) {
 		if (printk_ratelimit()) {
 			printk(KERN_INFO "btrfs bad fsid on block %llu\n",
@@ -461,6 +443,41 @@ static int btree_readpage_end_io_hook(st
 	ret = csum_tree_block(root, eb, 1);
 	if (ret)
 		ret = -EIO;
+err:
+	if (ret == 0)
+		clear_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags);
+	return ret;
+}
+
+static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
+			       struct extent_state *state)
+{
+	struct extent_io_tree *tree;
+	unsigned long len;
+	struct extent_buffer *eb;
+	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	int ret = 0;
+
+	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	if (page->private == EXTENT_PAGE_PRIVATE)
+		goto out;
+	if (!page->private)
+		goto out;
+
+	len = page->private >> 2;
+	WARN_ON(len == 0);
+
+	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+
+	if (eb->first_page != page) {
+		printk(KERN_INFO "btrfs bad first page %lu %lu\n",
+		       eb->first_page->index, page->index);
+		WARN_ON(1);
+		ret = -EIO;
+		goto err;
+	}
+
+	ret = btree_validate_extent_buffer(root, eb);
 
 	end = min_t(u64, eb->len, PAGE_CACHE_SIZE);
 	end = eb->start + end - 1;
Index: linux/fs/btrfs/disk-io.h
===================================================================
--- linux.orig/fs/btrfs/disk-io.h	2010-07-19 10:56:33.000000000 +0800
+++ linux/fs/btrfs/disk-io.h	2010-07-19 10:58:13.000000000 +0800
@@ -36,6 +36,8 @@ static inline u64 btrfs_sb_offset(int mi
 struct btrfs_device;
 struct btrfs_fs_devices;
 
+int btree_validate_extent_buffer(struct btrfs_root *root,
+	struct extent_buffer *eb);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
Index: linux/fs/btrfs/extent_io.c
===================================================================
--- linux.orig/fs/btrfs/extent_io.c	2010-07-19 10:56:33.000000000 +0800
+++ linux/fs/btrfs/extent_io.c	2010-07-19 10:58:13.000000000 +0800
@@ -14,6 +14,7 @@
 #include "extent_map.h"
 #include "compat.h"
 #include "ctree.h"
+#include "disk-io.h"
 #include "btrfs_inode.h"
 
 static struct kmem_cache *extent_state_cache;
@@ -3162,6 +3163,7 @@ struct extent_buffer *alloc_extent_buffe
 			uptodate = 0;
 		unlock_page(p);
 	}
+	set_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags);
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
@@ -3387,9 +3389,10 @@ int read_extent_buffer_pages(struct exte
 	unsigned long num_pages;
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
+	struct btrfs_root *root = BTRFS_I(tree->mapping->host)->root;
 
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
-		return 0;
+		goto out;
 
 	if (test_range_bit(tree, eb->start, eb->start + eb->len - 1,
 			   EXTENT_UPTODATE, 1, NULL)) {
@@ -3454,8 +3457,10 @@ int read_extent_buffer_pages(struct exte
 			ret = -EIO;
 	}
 
-	if (!ret)
+	if (!ret) {
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+		goto out;
+	}
 	return ret;
 
 unlock_exit:
@@ -3466,6 +3471,11 @@ unlock_exit:
 		unlock_page(page);
 		locked_pages--;
 	}
+out:
+	if (!ret && test_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags) &&
+		test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+		return btree_validate_extent_buffer(root, eb);
+
 	return ret;
 }
 
Index: linux/fs/btrfs/extent_io.h
===================================================================
--- linux.orig/fs/btrfs/extent_io.h	2010-07-19 10:56:33.000000000 +0800
+++ linux/fs/btrfs/extent_io.h	2010-07-19 10:58:13.000000000 +0800
@@ -27,6 +27,7 @@
 #define EXTENT_BUFFER_UPTODATE 0
 #define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
+#define EXTENT_BUFFER_UNCHECKED 3
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
Index: linux/fs/btrfs/extent-tree.c
===================================================================
--- linux.orig/fs/btrfs/extent-tree.c	2010-07-19 10:56:33.000000000 +0800
+++ linux/fs/btrfs/extent-tree.c	2010-07-19 10:58:13.000000000 +0800
@@ -5277,6 +5277,7 @@ struct extent_buffer *btrfs_init_new_buf
 	clean_tree_block(trans, root, buf);
 
 	btrfs_set_lock_blocking(buf);
+	clear_bit(EXTENT_BUFFER_UNCHECKED, &buf->bflags);
 	btrfs_set_buffer_uptodate(buf);
 
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
