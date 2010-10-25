From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs: Allow to add new compression algorithm
Date: Mon, 25 Oct 2010 15:12:06 +0800
Message-ID: <4CC52DC6.8060702@cn.fujitsu.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC52D9A.3030709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Make the code aware of compression type, instead of always assuming
zlib compression.

Also make the zlib workspace function as common code for all
compression types.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h  |    2 +-
 fs/btrfs/compression.c  |  236 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/compression.h  |   66 +++++++++----
 fs/btrfs/ctree.h        |   10 +-
 fs/btrfs/extent_io.c    |    5 +-
 fs/btrfs/extent_io.h    |   17 +++-
 fs/btrfs/extent_map.c   |    2 +
 fs/btrfs/extent_map.h   |    3 +-
 fs/btrfs/file.c         |    2 +
 fs/btrfs/inode.c        |   82 ++++++++++------
 fs/btrfs/ioctl.c        |    4 +-
 fs/btrfs/ordered-data.c |   18 +++-
 fs/btrfs/ordered-data.h |    8 ++-
 fs/btrfs/super.c        |   41 +++++++-
 fs/btrfs/zlib.c         |  253 +++++++++-------------------------------------
 15 files changed, 472 insertions(+), 277 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6ad63f1..ccc991c 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -157,7 +157,7 @@ struct btrfs_inode {
 	/*
 	 * always compress this one file
 	 */
-	unsigned force_compress:1;
+	unsigned force_compress:4;
 
 	struct inode vfs_inode;
 };
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index cb3877c..4c6068b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -62,6 +62,9 @@ struct compressed_bio {
 	/* number of bytes on disk */
 	unsigned long compressed_len;
 
+	/* the compression algorithm for this bio */
+	int compress_type;
+
 	/* number of compressed pages in the array */
 	unsigned long nr_pages;
 
@@ -186,11 +189,12 @@ static void end_compressed_bio_read(struct bio *bio, int err)
 	/* ok, we're the last bio for this extent, lets start
 	 * the decompression.
 	 */
-	ret = btrfs_zlib_decompress_biovec(cb->compressed_pages,
-					cb->start,
-					cb->orig_bio->bi_io_vec,
-					cb->orig_bio->bi_vcnt,
-					cb->compressed_len);
+	ret = btrfs_decompress_biovec(cb->compress_type,
+				      cb->compressed_pages,
+				      cb->start,
+				      cb->orig_bio->bi_io_vec,
+				      cb->orig_bio->bi_vcnt,
+				      cb->compressed_len);
 csum_failed:
 	if (ret)
 		cb->errors = 1;
@@ -611,6 +615,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	cb->len = uncompressed_len;
 	cb->compressed_len = compressed_len;
+	cb->compress_type = extent_compress_type(bio_flags);
 	cb->orig_bio = bio;
 
 	nr_pages = (compressed_len + PAGE_CACHE_SIZE - 1) /
@@ -700,3 +705,224 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	bio_put(comp_bio);
 	return 0;
 }
+
+static struct list_head comp_idle_workspace[BTRFS_COMPRESS_TYPES];
+static spinlock_t comp_workspace_lock[BTRFS_COMPRESS_TYPES];
+static int comp_num_workspace[BTRFS_COMPRESS_TYPES];
+static atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES];
+static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
+
+struct btrfs_compress_op *btrfs_compress_op[] = {
+	&btrfs_zlib_compress,
+};
+
+int __init btrfs_init_compress(void)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+		INIT_LIST_HEAD(&comp_idle_workspace[i]);
+		spin_lock_init(&comp_workspace_lock[i]);
+		atomic_set(&comp_alloc_workspace[i], 0);
+		init_waitqueue_head(&comp_workspace_wait[i]);
+	}
+	return 0;
+}
+
+/*
+ * this finds an available workspace or allocates a new one
+ * ERR_PTR is returned if things go bad.
+ */
+static struct list_head *find_workspace(int type)
+{
+	struct list_head *workspace;
+	int cpus = num_online_cpus();
+	int idx = type - 1;
+
+	struct list_head *idle_workspace	= &comp_idle_workspace[idx];
+	spinlock_t *workspace_lock		= &comp_workspace_lock[idx];
+	atomic_t *alloc_workspace		= &comp_alloc_workspace[idx];
+	wait_queue_head_t *workspace_wait	= &comp_workspace_wait[idx];
+	int *num_workspace			= &comp_num_workspace[idx];
+again:
+	spin_lock(workspace_lock);
+	if (!list_empty(idle_workspace)) {
+		workspace = idle_workspace->next;
+		list_del(workspace);
+		(*num_workspace)--;
+		spin_unlock(workspace_lock);
+		return workspace;
+
+	}
+	if (atomic_read(alloc_workspace) > cpus) {
+		DEFINE_WAIT(wait);
+
+		spin_unlock(workspace_lock);
+		prepare_to_wait(workspace_wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (atomic_read(alloc_workspace) > cpus && !*num_workspace)
+			schedule();
+		finish_wait(workspace_wait, &wait);
+		goto again;
+	}
+	atomic_inc(alloc_workspace);
+	spin_unlock(workspace_lock);
+
+	workspace = btrfs_compress_op[idx]->alloc_workspace();
+	if (IS_ERR(workspace)) {
+		atomic_dec(alloc_workspace);
+		wake_up(workspace_wait);
+	}
+	return workspace;
+}
+
+/*
+ * put a workspace struct back on the list or free it if we have enough
+ * idle ones sitting around
+ */
+static void free_workspace(int type, struct list_head *workspace)
+{
+	int idx = type - 1;
+	struct list_head *idle_workspace	= &comp_idle_workspace[idx];
+	spinlock_t *workspace_lock		= &comp_workspace_lock[idx];
+	atomic_t *alloc_workspace		= &comp_alloc_workspace[idx];
+	wait_queue_head_t *workspace_wait	= &comp_workspace_wait[idx];
+	int *num_workspace			= &comp_num_workspace[idx];
+
+	spin_lock(workspace_lock);
+	if (*num_workspace < num_online_cpus()) {
+		list_add_tail(workspace, idle_workspace);
+		(*num_workspace)++;
+		spin_unlock(workspace_lock);
+		goto wake;
+	}
+	spin_unlock(workspace_lock);
+
+	btrfs_compress_op[idx]->free_workspace(workspace);
+	atomic_dec(alloc_workspace);
+wake:
+	if (waitqueue_active(workspace_wait))
+		wake_up(workspace_wait);
+}
+
+/*
+ * cleanup function for module exit
+ */
+static void free_workspaces(void)
+{
+	struct list_head *workspace;
+	int i;
+
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+		while (!list_empty(&comp_idle_workspace[i])) {
+			workspace = comp_idle_workspace[i].next;
+			list_del(workspace);
+			btrfs_compress_op[i]->free_workspace(workspace);
+			atomic_dec(&comp_alloc_workspace[i]);
+		}
+	}
+}
+
+/*
+ * given an address space and start/len, compress the bytes.
+ *
+ * pages are allocated to hold the compressed result and stored
+ * in 'pages'
+ *
+ * out_pages is used to return the number of pages allocated.  There
+ * may be pages allocated even if we return an error
+ *
+ * total_in is used to return the number of bytes actually read.  It
+ * may be smaller then len if we had to exit early because we
+ * ran out of room in the pages array or because we cross the
+ * max_out threshold.
+ *
+ * total_out is used to return the total number of compressed bytes
+ *
+ * max_out tells us the max number of bytes that we're allowed to
+ * stuff into pages
+ */
+int btrfs_compress_pages(int type, struct address_space *mapping,
+			 u64 start, unsigned long len,
+			 struct page **pages,
+			 unsigned long nr_dest_pages,
+			 unsigned long *out_pages,
+			 unsigned long *total_in,
+			 unsigned long *total_out,
+			 unsigned long max_out)
+{
+	struct list_head *workspace;
+	int ret;
+
+	workspace = find_workspace(type);
+	if (IS_ERR(workspace))
+		return -1;
+
+	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
+						      start, len, pages,
+						      nr_dest_pages, out_pages,
+						      total_in, total_out,
+						      max_out);
+	free_workspace(type, workspace);
+	return ret;
+}
+
+/*
+ * pages_in is an array of pages with compressed data.
+ *
+ * disk_start is the starting logical offset of this array in the file
+ *
+ * bvec is a bio_vec of pages from the file that we want to decompress into
+ *
+ * vcnt is the count of pages in the biovec
+ *
+ * srclen is the number of bytes in pages_in
+ *
+ * The basic idea is that we have a bio that was created by readpages.
+ * The pages in the bio are for the uncompressed data, and they may not
+ * be contiguous.  They all correspond to the range of bytes covered by
+ * the compressed extent.
+ */
+int btrfs_decompress_biovec(int type, struct page **pages_in, u64 disk_start,
+			    struct bio_vec *bvec, int vcnt, size_t srclen)
+{
+	struct list_head *workspace;
+	int ret;
+
+	workspace = find_workspace(type);
+	if (IS_ERR(workspace))
+		return -ENOMEM;
+
+	ret = btrfs_compress_op[type-1]->decompress_biovec(workspace, pages_in,
+							 disk_start,
+							 bvec, vcnt, srclen);
+	free_workspace(type, workspace);
+	return ret;
+}
+
+/*
+ * a less complex decompression routine.  Our compressed data fits in a
+ * single page, and we want to read a single page out of it.
+ * start_byte tells us the offset into the compressed data we're interested in
+ */
+int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
+		     unsigned long start_byte, size_t srclen, size_t destlen)
+{
+	struct list_head *workspace;
+	int ret;
+
+	workspace = find_workspace(type);
+	if (IS_ERR(workspace))
+		return -ENOMEM;
+
+	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
+						  dest_page, start_byte,
+						  srclen, destlen);
+
+	free_workspace(type, workspace);
+	return ret;
+}
+
+void __exit btrfs_exit_compress(void)
+{
+    free_workspaces();
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 421f5b4..9b5f2f3 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,24 +19,22 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
-int btrfs_zlib_decompress(unsigned char *data_in,
-			  struct page *dest_page,
-			  unsigned long start_byte,
-			  size_t srclen, size_t destlen);
-int btrfs_zlib_compress_pages(struct address_space *mapping,
-			      u64 start, unsigned long len,
-			      struct page **pages,
-			      unsigned long nr_dest_pages,
-			      unsigned long *out_pages,
-			      unsigned long *total_in,
-			      unsigned long *total_out,
-			      unsigned long max_out);
-int btrfs_zlib_decompress_biovec(struct page **pages_in,
-			      u64 disk_start,
-			      struct bio_vec *bvec,
-			      int vcnt,
-			      size_t srclen);
-void btrfs_zlib_exit(void);
+int btrfs_init_compress(void);
+void btrfs_exit_compress(void);
+
+int btrfs_compress_pages(int type, struct address_space *mapping,
+			 u64 start, unsigned long len,
+			 struct page **pages,
+			 unsigned long nr_dest_pages,
+			 unsigned long *out_pages,
+			 unsigned long *total_in,
+			 unsigned long *total_out,
+			 unsigned long max_out);
+int btrfs_decompress_biovec(int type, struct page **pages_in, u64 disk_start,
+			    struct bio_vec *bvec, int vcnt, size_t srclen);
+int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
+		     unsigned long start_byte, size_t srclen, size_t destlen);
+
 int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long len, u64 disk_start,
 				  unsigned long compressed_len,
@@ -44,4 +42,36 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long nr_pages);
 int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
+
+struct btrfs_compress_op {
+	struct list_head *(*alloc_workspace)(void);
+
+	void (*free_workspace)(struct list_head *workspace);
+
+	int (*compress_pages)(struct list_head *workspace,
+			      struct address_space *mapping,
+			      u64 start, unsigned long len,
+			      struct page **pages,
+			      unsigned long nr_dest_pages,
+			      unsigned long *out_pages,
+			      unsigned long *total_in,
+			      unsigned long *total_out,
+			      unsigned long max_out);
+
+	int (*decompress_biovec)(struct list_head *workspace,
+				 struct page **pages_in,
+				 u64 disk_start,
+				 struct bio_vec *bvec,
+				 int vcnt,
+				 size_t srclen);
+
+	int (*decompress)(struct list_head *workspace,
+			  unsigned char *data_in,
+			  struct page *dest_page,
+			  unsigned long start_byte,
+			  size_t srclen, size_t destlen);
+};
+
+extern struct btrfs_compress_op btrfs_zlib_compress;
+
 #endif
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..b0f8b4d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -528,9 +528,10 @@ struct btrfs_timespec {
 } __attribute__ ((__packed__));
 
 enum btrfs_compression_type {
-	BTRFS_COMPRESS_NONE = 0,
-	BTRFS_COMPRESS_ZLIB = 1,
-	BTRFS_COMPRESS_LAST = 2,
+	BTRFS_COMPRESS_NONE  = 0,
+	BTRFS_COMPRESS_ZLIB  = 1,
+	BTRFS_COMPRESS_TYPES = 1,
+	BTRFS_COMPRESS_LAST  = 2,
 };
 
 struct btrfs_inode_item {
@@ -857,7 +858,8 @@ struct btrfs_fs_info {
 	 */
 	u64 last_trans_log_full_commit;
 	u64 open_ioctl_trans;
-	unsigned long mount_opt;
+	unsigned long mount_opt:20;
+	unsigned long compress_type:4;
 	u64 max_inline;
 	u64 alloc_start;
 	struct btrfs_transaction *running_transaction;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 41277d6..56eba19 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2072,8 +2072,11 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		BUG_ON(extent_map_end(em) <= cur);
 		BUG_ON(end < cur);
 
-		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 			this_bio_flag = EXTENT_BIO_COMPRESSED;
+			extent_set_compress_type(&this_bio_flag,
+						 em->compress_type);
+		}
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		cur_end = min(extent_map_end(em) - 1, end);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5691c7b..65f06c8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,8 +20,12 @@
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
-/* flags for bio submission */
+/*
+ * flags for bio submission. The high bits indicate the compression
+ * type for this bio
+ */
 #define EXTENT_BIO_COMPRESSED 1
+#define EXTENT_BIO_FLAG_SHIFT 16
 
 /* these are bit numbers for test/set bit */
 #define EXTENT_BUFFER_UPTODATE 0
@@ -135,6 +139,17 @@ struct extent_buffer {
 	wait_queue_head_t lock_wq;
 };
 
+static inline void extent_set_compress_type(unsigned long *bio_flags,
+					    int compress_type)
+{
+	*bio_flags |= compress_type << EXTENT_BIO_FLAG_SHIFT;
+}
+
+static inline int extent_compress_type(unsigned long bio_flags)
+{
+	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
+}
+
 struct extent_map_tree;
 
 static inline struct extent_state *extent_state_next(struct extent_state *state)
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 23cb8da..b0e1fce 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include "ctree.h"
 #include "extent_map.h"
 
 
@@ -54,6 +55,7 @@ struct extent_map *alloc_extent_map(gfp_t mask)
 		return em;
 	em->in_tree = 0;
 	em->flags = 0;
+	em->compress_type = BTRFS_COMPRESS_NONE;
 	atomic_set(&em->refs, 1);
 	return em;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index ab6d74b..28b44db 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -26,7 +26,8 @@ struct extent_map {
 	unsigned long flags;
 	struct block_device *bdev;
 	atomic_t refs;
-	int in_tree;
+	unsigned int in_tree:1;
+	unsigned int compress_type:4;
 };
 
 struct extent_map_tree {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7f29464..8585a72 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -220,6 +220,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 
 			split->bdev = em->bdev;
 			split->flags = flags;
+			split->compress_type = em->compress_type;
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret);
 			free_extent_map(split);
@@ -234,6 +235,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->len = em->start + em->len - (start + len);
 			split->bdev = em->bdev;
 			split->flags = flags;
+			split->compress_type = em->compress_type;
 
 			if (compressed) {
 				split->block_len = em->block_len;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32ae852..c2fb4be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -122,10 +122,10 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	size_t cur_size = size;
 	size_t datasize;
 	unsigned long offset;
-	int use_compress = 0;
+	int compress_type = BTRFS_COMPRESS_NONE;
 
 	if (compressed_size && compressed_pages) {
-		use_compress = 1;
+		compress_type = root->fs_info->compress_type;
 		cur_size = compressed_size;
 	}
 
@@ -159,7 +159,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_ram_bytes(leaf, ei, size);
 	ptr = btrfs_file_extent_inline_start(ei);
 
-	if (use_compress) {
+	if (compress_type != BTRFS_COMPRESS_NONE) {
 		struct page *cpage;
 		int i = 0;
 		while (compressed_size > 0) {
@@ -176,7 +176,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 			compressed_size -= cur_size;
 		}
 		btrfs_set_file_extent_compression(leaf, ei,
-						  BTRFS_COMPRESS_ZLIB);
+						  compress_type);
 	} else {
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_CACHE_SHIFT);
@@ -263,6 +263,7 @@ struct async_extent {
 	u64 compressed_size;
 	struct page **pages;
 	unsigned long nr_pages;
+	int compress_type;
 	struct list_head list;
 };
 
@@ -280,7 +281,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 start, u64 ram_size,
 				     u64 compressed_size,
 				     struct page **pages,
-				     unsigned long nr_pages)
+				     unsigned long nr_pages,
+				     int compress_type)
 {
 	struct async_extent *async_extent;
 
@@ -290,6 +292,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->compressed_size = compressed_size;
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
+	async_extent->compress_type = compress_type;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -332,6 +335,7 @@ static noinline int compress_file_range(struct inode *inode,
 	unsigned long max_uncompressed = 128 * 1024;
 	int i;
 	int will_compress;
+	int compress_type = root->fs_info->compress_type;
 
 	actual_end = min_t(u64, isize, end + 1);
 again:
@@ -381,12 +385,16 @@ again:
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
 
-		ret = btrfs_zlib_compress_pages(inode->i_mapping, start,
-						total_compressed, pages,
-						nr_pages, &nr_pages_ret,
-						&total_in,
-						&total_compressed,
-						max_compressed);
+		if (BTRFS_I(inode)->force_compress)
+			compress_type = BTRFS_I(inode)->force_compress;
+
+		ret = btrfs_compress_pages(compress_type,
+					   inode->i_mapping, start,
+					   total_compressed, pages,
+					   nr_pages, &nr_pages_ret,
+					   &total_in,
+					   &total_compressed,
+					   max_compressed);
 
 		if (!ret) {
 			unsigned long offset = total_compressed &
@@ -493,7 +501,8 @@ again:
 		 * and will submit them to the elevator.
 		 */
 		add_async_extent(async_cow, start, num_bytes,
-				 total_compressed, pages, nr_pages_ret);
+				 total_compressed, pages, nr_pages_ret,
+				 compress_type);
 
 		if (start + num_bytes < end && start + num_bytes < actual_end) {
 			start += num_bytes;
@@ -515,7 +524,8 @@ cleanup_and_bail_uncompressed:
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
-		add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0);
+		add_async_extent(async_cow, start, end - start + 1,
+				 0, NULL, 0, BTRFS_COMPRESS_NONE);
 		*num_added += 1;
 	}
 
@@ -640,6 +650,7 @@ retry:
 		em->block_start = ins.objectid;
 		em->block_len = ins.offset;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
+		em->compress_type = async_extent->compress_type;
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
@@ -656,11 +667,13 @@ retry:
 						async_extent->ram_size - 1, 0);
 		}
 
-		ret = btrfs_add_ordered_extent(inode, async_extent->start,
-					       ins.objectid,
-					       async_extent->ram_size,
-					       ins.offset,
-					       BTRFS_ORDERED_COMPRESSED);
+		ret = btrfs_add_ordered_extent_compress(inode,
+						async_extent->start,
+						ins.objectid,
+						async_extent->ram_size,
+						ins.offset,
+						BTRFS_ORDERED_COMPRESSED,
+						async_extent->compress_type);
 		BUG_ON(ret);
 
 		/*
@@ -1650,7 +1663,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
-	int compressed = 0;
+	int compress_type = 0;
 	int ret;
 
 	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
@@ -1681,9 +1694,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
-		compressed = 1;
+		compress_type = ordered_extent->compress_type;
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
-		BUG_ON(compressed);
+		BUG_ON(compress_type);
 		ret = btrfs_mark_extent_written(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
@@ -1696,7 +1709,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 						ordered_extent->disk_len,
 						ordered_extent->len,
 						ordered_extent->len,
-						compressed, 0, 0,
+						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
 		unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 				   ordered_extent->file_offset,
@@ -1792,6 +1805,8 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 			logical = em->block_start;
 			failrec->bio_flags = EXTENT_BIO_COMPRESSED;
+			extent_set_compress_type(&failrec->bio_flags,
+						 em->compress_type);
 		}
 		failrec->logical = logical;
 		free_extent_map(em);
@@ -4878,8 +4893,10 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	size_t max_size;
 	unsigned long inline_size;
 	unsigned long ptr;
+	int compress_type;
 
 	WARN_ON(pg_offset != 0);
+	compress_type = btrfs_file_extent_compression(leaf, item);
 	max_size = btrfs_file_extent_ram_bytes(leaf, item);
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
@@ -4889,8 +4906,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	read_extent_buffer(leaf, tmp, ptr, inline_size);
 
 	max_size = min_t(unsigned long, PAGE_CACHE_SIZE, max_size);
-	ret = btrfs_zlib_decompress(tmp, page, extent_offset,
-				    inline_size, max_size);
+	ret = btrfs_decompress(compress_type, tmp, page,
+			       extent_offset, inline_size, max_size);
 	if (ret) {
 		char *kaddr = kmap_atomic(page, KM_USER0);
 		unsigned long copy_size = min_t(u64,
@@ -4932,7 +4949,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
-	int compressed;
+	int compress_type;
 
 again:
 	read_lock(&em_tree->lock);
@@ -4991,7 +5008,7 @@ again:
 
 	found_type = btrfs_file_extent_type(leaf, item);
 	extent_start = found_key.offset;
-	compressed = btrfs_file_extent_compression(leaf, item);
+	compress_type = btrfs_file_extent_compression(leaf, item);
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		extent_end = extent_start +
@@ -5037,8 +5054,9 @@ again:
 			em->block_start = EXTENT_MAP_HOLE;
 			goto insert;
 		}
-		if (compressed) {
+		if (compress_type != BTRFS_COMPRESS_NONE) {
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+			em->compress_type = compress_type;
 			em->block_start = bytenr;
 			em->block_len = btrfs_file_extent_disk_num_bytes(leaf,
 									 item);
@@ -5072,12 +5090,14 @@ again:
 		em->len = (copy_size + root->sectorsize - 1) &
 			~((u64)root->sectorsize - 1);
 		em->orig_start = EXTENT_MAP_INLINE;
-		if (compressed)
+		if (compress_type) {
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+			em->compress_type = compress_type;
+		}
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
 		if (create == 0 && !PageUptodate(page)) {
-			if (btrfs_file_extent_compression(leaf, item) ==
-			    BTRFS_COMPRESS_ZLIB) {
+			if (btrfs_file_extent_compression(leaf, item) !=
+			    BTRFS_COMPRESS_NONE) {
 				ret = uncompress_inline(path, inode, page,
 							pg_offset,
 							extent_offset, item);
@@ -6253,7 +6273,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
 	ei->dummy_inode = 0;
-	ei->force_compress = 0;
+	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree, GFP_NOFS);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ca52cfe..ecc49ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -585,7 +585,7 @@ static int btrfs_defrag_file(struct file *file,
 		total_read++;
 		mutex_lock(&inode->i_mutex);
 		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
-			BTRFS_I(inode)->force_compress = 1;
+			BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_ZLIB;
 
 		ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 		if (ret)
@@ -683,7 +683,7 @@ loop_unlock:
 		atomic_dec(&root->fs_info->async_submit_draining);
 
 		mutex_lock(&inode->i_mutex);
-		BTRFS_I(inode)->force_compress = 0;
+		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
 		mutex_unlock(&inode->i_mutex);
 	}
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5ebffc4..68c88ea 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -172,7 +172,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio)
+				      int type, int dio, int compress_type)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
@@ -189,6 +189,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->disk_len = disk_len;
 	entry->bytes_left = len;
 	entry->inode = inode;
+	entry->compress_type = compress_type;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -220,14 +221,25 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
-					  disk_len, type, 0);
+					  disk_len, type, 0,
+					  BTRFS_COMPRESS_NONE);
 }
 
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
-					  disk_len, type, 1);
+					  disk_len, type, 1,
+					  BTRFS_COMPRESS_NONE);
+}
+
+int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
+				      u64 start, u64 len, u64 disk_len,
+				      int type, int compress_type)
+{
+	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
+					  disk_len, type, 0,
+					  compress_type);
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8ac3654..47ba440 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -68,7 +68,7 @@ struct btrfs_ordered_sum {
 
 #define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */
 
-#define BTRFS_ORDERED_COMPRESSED 3 /* writing a compressed extent */
+#define BTRFS_ORDERED_COMPRESSED 3 /* writing a zlib compressed extent */
 
 #define BTRFS_ORDERED_PREALLOC 4 /* set when writing to prealloced extent */
 
@@ -93,6 +93,9 @@ struct btrfs_ordered_extent {
 	/* flags (described above) */
 	unsigned long flags;
 
+	/* compression algorithm */
+	int compress_type;
+
 	/* reference count */
 	atomic_t refs;
 
@@ -145,6 +148,9 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
+int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
+				      u64 start, u64 len, u64 disk_len,
+				      int type, int compress_type);
 int btrfs_add_ordered_sum(struct inode *inode,
 			  struct btrfs_ordered_extent *entry,
 			  struct btrfs_ordered_sum *sum);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d50f813..a2e5c79 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -69,8 +69,8 @@ enum {
 	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
-	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
+	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -85,7 +85,9 @@ static match_table_t tokens = {
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
 	{Opt_compress, "compress"},
+	{Opt_compress_type, "compress=%s"},
 	{Opt_compress_force, "compress-force"},
+	{Opt_compress_force_type, "compress-force=%s"},
 	{Opt_ssd, "ssd"},
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd, "nossd"},
@@ -108,6 +110,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	char *p, *num, *orig;
 	int intarg;
 	int ret = 0;
+	char *compress_type;
 
 	if (!options)
 		return 0;
@@ -151,11 +154,31 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_compress:
-			printk(KERN_INFO "btrfs: use compression\n");
+		case Opt_compress_type:
+			if (token == Opt_compress ||
+			    strcmp(args[0].from, "zlib") == 0) {
+				compress_type = "zlib";
+				info->compress_type = BTRFS_COMPRESS_ZLIB;
+			} else {
+				ret = -EINVAL;
+				goto out;
+			}
+			printk(KERN_INFO "btrfs: use %s compression\n",
+			       compress_type);
 			btrfs_set_opt(info->mount_opt, COMPRESS);
 			break;
 		case Opt_compress_force:
-			printk(KERN_INFO "btrfs: forcing compression\n");
+		case Opt_compress_force_type:
+			if (token == Opt_compress_force ||
+			    strcmp(args[0].from, "zlib") == 0) {
+				compress_type = "zlib";
+				info->compress_type = BTRFS_COMPRESS_ZLIB;
+			} else {
+				ret = -EINVAL;
+				goto out;
+			}
+			printk(KERN_INFO "btrfs: force %s compression\n",
+			       compress_type);
 			btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
 			btrfs_set_opt(info->mount_opt, COMPRESS);
 			break;
@@ -840,10 +863,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		return err;
 
-	err = btrfs_init_cachep();
+	err = btrfs_init_compress();
 	if (err)
 		goto free_sysfs;
 
+	err = btrfs_init_cachep();
+	if (err)
+		goto free_compress;
+
 	err = extent_io_init();
 	if (err)
 		goto free_cachep;
@@ -871,6 +898,8 @@ free_extent_io:
 	extent_io_exit();
 free_cachep:
 	btrfs_destroy_cachep();
+free_compress:
+	btrfs_exit_compress();
 free_sysfs:
 	btrfs_exit_sysfs();
 	return err;
@@ -885,7 +914,7 @@ static void __exit exit_btrfs_fs(void)
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
 	btrfs_cleanup_fs_uuids();
-	btrfs_zlib_exit();
+	btrfs_exit_compress();
 }
 
 module_init(init_btrfs_fs)
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index e5b8b22..3d8c501 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -32,15 +32,6 @@
 #include <linux/bio.h>
 #include "compression.h"
 
-/* Plan: call deflate() with avail_in == *sourcelen,
-	avail_out = *dstlen - 12 and flush == Z_FINISH.
-	If it doesn't manage to finish,	call it again with
-	avail_in == 0 and avail_out set to the remaining 12
-	bytes for it to clean up.
-   Q: Is 12 bytes sufficient?
-*/
-#define STREAM_END_SPACE 12
-
 struct workspace {
 	z_stream inf_strm;
 	z_stream def_strm;
@@ -48,155 +39,51 @@ struct workspace {
 	struct list_head list;
 };
 
-static LIST_HEAD(idle_workspace);
-static DEFINE_SPINLOCK(workspace_lock);
-static unsigned long num_workspace;
-static atomic_t alloc_workspace = ATOMIC_INIT(0);
-static DECLARE_WAIT_QUEUE_HEAD(workspace_wait);
+static void zlib_free_workspace(struct list_head *ws)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
-/*
- * this finds an available zlib workspace or allocates a new one
- * NULL or an ERR_PTR is returned if things go bad.
- */
-static struct workspace *find_zlib_workspace(void)
+	vfree(workspace->def_strm.workspace);
+	vfree(workspace->inf_strm.workspace);
+	kfree(workspace->buf);
+	kfree(workspace);
+}
+
+static struct list_head *zlib_alloc_workspace(void)
 {
 	struct workspace *workspace;
-	int ret;
-	int cpus = num_online_cpus();
-
-again:
-	spin_lock(&workspace_lock);
-	if (!list_empty(&idle_workspace)) {
-		workspace = list_entry(idle_workspace.next, struct workspace,
-				       list);
-		list_del(&workspace->list);
-		num_workspace--;
-		spin_unlock(&workspace_lock);
-		return workspace;
-
-	}
-	if (atomic_read(&alloc_workspace) > cpus) {
-		DEFINE_WAIT(wait);
-
-		spin_unlock(&workspace_lock);
-		prepare_to_wait(&workspace_wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&alloc_workspace) > cpus && !num_workspace)
-			schedule();
-		finish_wait(&workspace_wait, &wait);
-		goto again;
-	}
-	atomic_inc(&alloc_workspace);
-	spin_unlock(&workspace_lock);
 
 	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
-	if (!workspace) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!workspace)
+		return ERR_PTR(-ENOMEM);
 
 	workspace->def_strm.workspace = vmalloc(zlib_deflate_workspacesize());
-	if (!workspace->def_strm.workspace) {
-		ret = -ENOMEM;
-		goto fail;
-	}
 	workspace->inf_strm.workspace = vmalloc(zlib_inflate_workspacesize());
-	if (!workspace->inf_strm.workspace) {
-		ret = -ENOMEM;
-		goto fail_inflate;
-	}
 	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
-	if (!workspace->buf) {
-		ret = -ENOMEM;
-		goto fail_kmalloc;
-	}
-	return workspace;
-
-fail_kmalloc:
-	vfree(workspace->inf_strm.workspace);
-fail_inflate:
-	vfree(workspace->def_strm.workspace);
-fail:
-	kfree(workspace);
-	atomic_dec(&alloc_workspace);
-	wake_up(&workspace_wait);
-	return ERR_PTR(ret);
-}
-
-/*
- * put a workspace struct back on the list or free it if we have enough
- * idle ones sitting around
- */
-static int free_workspace(struct workspace *workspace)
-{
-	spin_lock(&workspace_lock);
-	if (num_workspace < num_online_cpus()) {
-		list_add_tail(&workspace->list, &idle_workspace);
-		num_workspace++;
-		spin_unlock(&workspace_lock);
-		if (waitqueue_active(&workspace_wait))
-			wake_up(&workspace_wait);
-		return 0;
-	}
-	spin_unlock(&workspace_lock);
-	vfree(workspace->def_strm.workspace);
-	vfree(workspace->inf_strm.workspace);
-	kfree(workspace->buf);
-	kfree(workspace);
+	if (!workspace->def_strm.workspace ||
+	    !workspace->inf_strm.workspace || !workspace->buf)
+		goto fail;
 
-	atomic_dec(&alloc_workspace);
-	if (waitqueue_active(&workspace_wait))
-		wake_up(&workspace_wait);
-	return 0;
-}
+	INIT_LIST_HEAD(&workspace->list);
 
-/*
- * cleanup function for module exit
- */
-static void free_workspaces(void)
-{
-	struct workspace *workspace;
-	while (!list_empty(&idle_workspace)) {
-		workspace = list_entry(idle_workspace.next, struct workspace,
-				       list);
-		list_del(&workspace->list);
-		vfree(workspace->def_strm.workspace);
-		vfree(workspace->inf_strm.workspace);
-		kfree(workspace->buf);
-		kfree(workspace);
-		atomic_dec(&alloc_workspace);
-	}
+	return &workspace->list;
+fail:
+	zlib_free_workspace(&workspace->list);
+	return ERR_PTR(-ENOMEM);
 }
 
-/*
- * given an address space and start/len, compress the bytes.
- *
- * pages are allocated to hold the compressed result and stored
- * in 'pages'
- *
- * out_pages is used to return the number of pages allocated.  There
- * may be pages allocated even if we return an error
- *
- * total_in is used to return the number of bytes actually read.  It
- * may be smaller then len if we had to exit early because we
- * ran out of room in the pages array or because we cross the
- * max_out threshold.
- *
- * total_out is used to return the total number of compressed bytes
- *
- * max_out tells us the max number of bytes that we're allowed to
- * stuff into pages
- */
-int btrfs_zlib_compress_pages(struct address_space *mapping,
-			      u64 start, unsigned long len,
-			      struct page **pages,
-			      unsigned long nr_dest_pages,
-			      unsigned long *out_pages,
-			      unsigned long *total_in,
-			      unsigned long *total_out,
-			      unsigned long max_out)
+static int zlib_compress_pages(struct list_head *ws,
+			       struct address_space *mapping,
+			       u64 start, unsigned long len,
+			       struct page **pages,
+			       unsigned long nr_dest_pages,
+			       unsigned long *out_pages,
+			       unsigned long *total_in,
+			       unsigned long *total_out,
+			       unsigned long max_out)
 {
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret;
-	struct workspace *workspace;
 	char *data_in;
 	char *cpage_out;
 	int nr_pages = 0;
@@ -208,10 +95,6 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	*total_out = 0;
 	*total_in = 0;
 
-	workspace = find_zlib_workspace();
-	if (IS_ERR(workspace))
-		return -1;
-
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
 		printk(KERN_WARNING "deflateInit failed\n");
 		ret = -1;
@@ -317,35 +200,18 @@ out:
 		kunmap(in_page);
 		page_cache_release(in_page);
 	}
-	free_workspace(workspace);
 	return ret;
 }
 
-/*
- * pages_in is an array of pages with compressed data.
- *
- * disk_start is the starting logical offset of this array in the file
- *
- * bvec is a bio_vec of pages from the file that we want to decompress into
- *
- * vcnt is the count of pages in the biovec
- *
- * srclen is the number of bytes in pages_in
- *
- * The basic idea is that we have a bio that was created by readpages.
- * The pages in the bio are for the uncompressed data, and they may not
- * be contiguous.  They all correspond to the range of bytes covered by
- * the compressed extent.
- */
-int btrfs_zlib_decompress_biovec(struct page **pages_in,
-			      u64 disk_start,
-			      struct bio_vec *bvec,
-			      int vcnt,
-			      size_t srclen)
+static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
+				  u64 disk_start,
+				  struct bio_vec *bvec,
+				  int vcnt,
+				  size_t srclen)
 {
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0;
 	int wbits = MAX_WBITS;
-	struct workspace *workspace;
 	char *data_in;
 	size_t total_out = 0;
 	unsigned long page_bytes_left;
@@ -363,10 +229,6 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 	unsigned long current_buf_start;
 	char *kaddr;
 
-	workspace = find_zlib_workspace();
-	if (IS_ERR(workspace))
-		return -ENOMEM;
-
 	data_in = kmap(pages_in[page_in_index]);
 	workspace->inf_strm.next_in = data_in;
 	workspace->inf_strm.avail_in = min_t(size_t, srclen, PAGE_CACHE_SIZE);
@@ -392,8 +254,7 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
 		printk(KERN_WARNING "inflateInit failed\n");
-		ret = -1;
-		goto out;
+		return -1;
 	}
 	while (workspace->inf_strm.total_in < srclen) {
 		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
@@ -519,35 +380,21 @@ done:
 	zlib_inflateEnd(&workspace->inf_strm);
 	if (data_in)
 		kunmap(pages_in[page_in_index]);
-out:
-	free_workspace(workspace);
 	return ret;
 }
 
-/*
- * a less complex decompression routine.  Our compressed data fits in a
- * single page, and we want to read a single page out of it.
- * start_byte tells us the offset into the compressed data we're interested in
- */
-int btrfs_zlib_decompress(unsigned char *data_in,
-			  struct page *dest_page,
-			  unsigned long start_byte,
-			  size_t srclen, size_t destlen)
+static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
+			   struct page *dest_page,
+			   unsigned long start_byte,
+			   size_t srclen, size_t destlen)
 {
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0;
 	int wbits = MAX_WBITS;
-	struct workspace *workspace;
 	unsigned long bytes_left = destlen;
 	unsigned long total_out = 0;
 	char *kaddr;
 
-	if (destlen > PAGE_CACHE_SIZE)
-		return -ENOMEM;
-
-	workspace = find_zlib_workspace();
-	if (IS_ERR(workspace))
-		return -ENOMEM;
-
 	workspace->inf_strm.next_in = data_in;
 	workspace->inf_strm.avail_in = srclen;
 	workspace->inf_strm.total_in = 0;
@@ -568,8 +415,7 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
 		printk(KERN_WARNING "inflateInit failed\n");
-		ret = -1;
-		goto out;
+		return -1;
 	}
 
 	while (bytes_left > 0) {
@@ -619,12 +465,13 @@ next:
 		ret = 0;
 
 	zlib_inflateEnd(&workspace->inf_strm);
-out:
-	free_workspace(workspace);
 	return ret;
 }
 
-void btrfs_zlib_exit(void)
-{
-    free_workspaces();
-}
+struct btrfs_compress_op btrfs_zlib_compress = {
+	.alloc_workspace	= zlib_alloc_workspace,
+	.free_workspace		= zlib_free_workspace,
+	.compress_pages		= zlib_compress_pages,
+	.decompress_biovec	= zlib_decompress_biovec,
+	.decompress		= zlib_decompress,
+};
-- 
1.7.0.1

