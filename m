From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 1/2] btrq: uplevel the btrfs thread pool for md/raid456
	usage
Date: Wed, 24 Mar 2010 07:53:15 -0700
Message-ID: <20100324145315.15371.17762.stgit@dwillia2-linux>
References: <20100324144904.15371.2317.stgit@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100324144904.15371.2317.stgit@dwillia2-linux>
List-ID: <linux-btrfs.vger.kernel.org>

The current async thread pool is optimized for extracting subsystem init
parallelism.  The btrfs workqueue is targetted for load balancing high
cpu utilization works and is a better candidate for a raid thread pool.
---

 fs/btrfs/Kconfig         |    1 
 fs/btrfs/Makefile        |    2 -
 fs/btrfs/ctree.h         |   22 +++---
 fs/btrfs/disk-io.c       |  157 +++++++++++++++++++++++-----------------------
 fs/btrfs/extent-tree.c   |    7 +-
 fs/btrfs/inode.c         |   18 +++--
 fs/btrfs/relocation.c    |   22 +++---
 fs/btrfs/volumes.c       |   12 ++--
 fs/btrfs/volumes.h       |    4 +
 include/linux/btrqueue.h |   36 +++++------
 lib/Kconfig              |    6 ++
 lib/Makefile             |    2 +
 lib/btrqueue.c           |  119 ++++++++++++++++++-----------------
 13 files changed, 211 insertions(+), 197 deletions(-)
 rename fs/btrfs/async-thread.h => include/linux/btrqueue.h (76%)
 rename fs/btrfs/async-thread.c => lib/btrqueue.c (82%)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 7bb3c02..5d64c17 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -4,6 +4,7 @@ config BTRFS_FS
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select BTRQ
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
 	  support for multiple devices and many more features.
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..96fb502 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -5,6 +5,6 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
+	   extent_io.o volumes.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
 	   compression.o delayed-ref.o relocation.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 444b3e9..5fe630a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -26,10 +26,10 @@
 #include <linux/completion.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
+#include <linux/btrqueue.h>
 #include <asm/kmap_types.h>
 #include "extent_io.h"
 #include "extent_map.h"
-#include "async-thread.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -910,21 +910,21 @@ struct btrfs_fs_info {
 	 * A third pool does submit_bio to avoid deadlocking with the other
 	 * two
 	 */
-	struct btrfs_workers generic_worker;
-	struct btrfs_workers workers;
-	struct btrfs_workers delalloc_workers;
-	struct btrfs_workers endio_workers;
-	struct btrfs_workers endio_meta_workers;
-	struct btrfs_workers endio_meta_write_workers;
-	struct btrfs_workers endio_write_workers;
-	struct btrfs_workers submit_workers;
-	struct btrfs_workers enospc_workers;
+	struct btrq_workers generic_worker;
+	struct btrq_workers workers;
+	struct btrq_workers delalloc_workers;
+	struct btrq_workers endio_workers;
+	struct btrq_workers endio_meta_workers;
+	struct btrq_workers endio_meta_write_workers;
+	struct btrq_workers endio_write_workers;
+	struct btrq_workers submit_workers;
+	struct btrq_workers enospc_workers;
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
 	 * for the sys_munmap function call path
 	 */
-	struct btrfs_workers fixup_workers;
+	struct btrq_workers fixup_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02b6afb..922eda5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/crc32c.h>
+#include <linux/btrqueue.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -34,13 +35,12 @@
 #include "btrfs_inode.h"
 #include "volumes.h"
 #include "print-tree.h"
-#include "async-thread.h"
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
 
 static struct extent_io_ops btree_extent_io_ops;
-static void end_workqueue_fn(struct btrfs_work *work);
+static void end_workqueue_fn(struct btrq_work *work);
 static void free_fs_root(struct btrfs_root *root);
 
 static atomic_t btrfs_bdi_num = ATOMIC_INIT(0);
@@ -58,7 +58,7 @@ struct end_io_wq {
 	int error;
 	int metadata;
 	struct list_head list;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
 /*
@@ -75,7 +75,7 @@ struct async_submit_bio {
 	int rw;
 	int mirror_num;
 	unsigned long bio_flags;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
 /* These are used to set the lockdep class on the extent buffer locks.
@@ -476,18 +476,18 @@ static void end_workqueue_bio(struct bio *bio, int err)
 
 	if (bio->bi_rw & (1 << BIO_RW)) {
 		if (end_io_wq->metadata)
-			btrfs_queue_worker(&fs_info->endio_meta_write_workers,
-					   &end_io_wq->work);
+			btrq_queue_worker(&fs_info->endio_meta_write_workers,
+					  &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_write_workers,
-					   &end_io_wq->work);
+			btrq_queue_worker(&fs_info->endio_write_workers,
+					  &end_io_wq->work);
 	} else {
 		if (end_io_wq->metadata)
-			btrfs_queue_worker(&fs_info->endio_meta_workers,
-					   &end_io_wq->work);
+			btrq_queue_worker(&fs_info->endio_meta_workers,
+					  &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_workers,
-					   &end_io_wq->work);
+			btrq_queue_worker(&fs_info->endio_workers,
+					  &end_io_wq->work);
 	}
 }
 
@@ -525,7 +525,7 @@ int btrfs_congested_async(struct btrfs_fs_info *info, int iodone)
 		btrfs_async_submit_limit(info);
 }
 
-static void run_one_async_start(struct btrfs_work *work)
+static void run_one_async_start(struct btrq_work *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
@@ -536,7 +536,7 @@ static void run_one_async_start(struct btrfs_work *work)
 			       async->mirror_num, async->bio_flags);
 }
 
-static void run_one_async_done(struct btrfs_work *work)
+static void run_one_async_done(struct btrq_work *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
@@ -558,7 +558,7 @@ static void run_one_async_done(struct btrfs_work *work)
 			       async->mirror_num, async->bio_flags);
 }
 
-static void run_one_async_free(struct btrfs_work *work)
+static void run_one_async_free(struct btrq_work *work)
 {
 	struct async_submit_bio *async;
 
@@ -595,9 +595,9 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	atomic_inc(&fs_info->nr_async_submits);
 
 	if (rw & (1 << BIO_RW_SYNCIO))
-		btrfs_set_work_high_prio(&async->work);
+		btrq_set_work_high_prio(&async->work);
 
-	btrfs_queue_worker(&fs_info->workers, &async->work);
+	btrq_queue_worker(&fs_info->workers, &async->work);
 
 	while (atomic_read(&fs_info->async_submit_draining) &&
 	      atomic_read(&fs_info->nr_async_submits)) {
@@ -1435,7 +1435,7 @@ static int bio_ready_for_csum(struct bio *bio)
  * called by the kthread helper functions to finally call the bio end_io
  * functions.  This is where read checksum verification actually happens
  */
-static void end_workqueue_fn(struct btrfs_work *work)
+static void end_workqueue_fn(struct btrq_work *work)
 {
 	struct bio *bio;
 	struct end_io_wq *end_io_wq;
@@ -1453,8 +1453,8 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	 */
 	if (!(bio->bi_rw & (1 << BIO_RW)) && end_io_wq->metadata &&
 	    !bio_ready_for_csum(bio)) {
-		btrfs_queue_worker(&fs_info->endio_meta_workers,
-				   &end_io_wq->work);
+		btrq_queue_worker(&fs_info->endio_meta_workers,
+				  &end_io_wq->work);
 		return;
 	}
 	error = end_io_wq->error;
@@ -1749,24 +1749,23 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_iput;
 	}
 
-	btrfs_init_workers(&fs_info->generic_worker,
-			   "genwork", 1, NULL);
+	btrq_init_workers(&fs_info->generic_worker, "btrfs-genwork", 1, NULL);
 
-	btrfs_init_workers(&fs_info->workers, "worker",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->workers, "btrfs-worker",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
 
-	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->delalloc_workers, "btrfs-delalloc",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
 
-	btrfs_init_workers(&fs_info->submit_workers, "submit",
-			   min_t(u64, fs_devices->num_devices,
-			   fs_info->thread_pool_size),
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->enospc_workers, "enospc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->submit_workers, "btrfs-submit",
+			  min_t(u64, fs_devices->num_devices,
+			  fs_info->thread_pool_size),
+			  &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->enospc_workers, "btrfs-enospc",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
 
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
@@ -1780,20 +1779,20 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->delalloc_workers.idle_thresh = 2;
 	fs_info->delalloc_workers.ordered = 1;
 
-	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_workers, "endio",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_meta_workers, "endio-meta",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_meta_write_workers,
-			   "endio-meta-write", fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->fixup_workers, "btrfs-fixup", 1,
+			  &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->endio_workers, "btrfs-endio",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->endio_meta_workers, "btrfs-endio-meta",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->endio_meta_write_workers,
+			  "btrfs-endio-meta-write", fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
+	btrq_init_workers(&fs_info->endio_write_workers, "btrfs-endio-write",
+			  fs_info->thread_pool_size,
+			  &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -1805,16 +1804,16 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->endio_write_workers.idle_thresh = 2;
 	fs_info->endio_meta_write_workers.idle_thresh = 2;
 
-	btrfs_start_workers(&fs_info->workers, 1);
-	btrfs_start_workers(&fs_info->generic_worker, 1);
-	btrfs_start_workers(&fs_info->submit_workers, 1);
-	btrfs_start_workers(&fs_info->delalloc_workers, 1);
-	btrfs_start_workers(&fs_info->fixup_workers, 1);
-	btrfs_start_workers(&fs_info->endio_workers, 1);
-	btrfs_start_workers(&fs_info->endio_meta_workers, 1);
-	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
-	btrfs_start_workers(&fs_info->endio_write_workers, 1);
-	btrfs_start_workers(&fs_info->enospc_workers, 1);
+	btrq_start_workers(&fs_info->workers, 1);
+	btrq_start_workers(&fs_info->generic_worker, 1);
+	btrq_start_workers(&fs_info->submit_workers, 1);
+	btrq_start_workers(&fs_info->delalloc_workers, 1);
+	btrq_start_workers(&fs_info->fixup_workers, 1);
+	btrq_start_workers(&fs_info->endio_workers, 1);
+	btrq_start_workers(&fs_info->endio_meta_workers, 1);
+	btrq_start_workers(&fs_info->endio_meta_write_workers, 1);
+	btrq_start_workers(&fs_info->endio_write_workers, 1);
+	btrq_start_workers(&fs_info->enospc_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2020,16 +2019,16 @@ fail_chunk_root:
 	free_extent_buffer(chunk_root->node);
 	free_extent_buffer(chunk_root->commit_root);
 fail_sb_buffer:
-	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->fixup_workers);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->enospc_workers);
+	btrq_stop_workers(&fs_info->generic_worker);
+	btrq_stop_workers(&fs_info->fixup_workers);
+	btrq_stop_workers(&fs_info->delalloc_workers);
+	btrq_stop_workers(&fs_info->workers);
+	btrq_stop_workers(&fs_info->endio_workers);
+	btrq_stop_workers(&fs_info->endio_meta_workers);
+	btrq_stop_workers(&fs_info->endio_meta_write_workers);
+	btrq_stop_workers(&fs_info->endio_write_workers);
+	btrq_stop_workers(&fs_info->submit_workers);
+	btrq_stop_workers(&fs_info->enospc_workers);
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
@@ -2447,16 +2446,16 @@ int close_ctree(struct btrfs_root *root)
 
 	iput(fs_info->btree_inode);
 
-	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->fixup_workers);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->enospc_workers);
+	btrq_stop_workers(&fs_info->generic_worker);
+	btrq_stop_workers(&fs_info->fixup_workers);
+	btrq_stop_workers(&fs_info->delalloc_workers);
+	btrq_stop_workers(&fs_info->workers);
+	btrq_stop_workers(&fs_info->endio_workers);
+	btrq_stop_workers(&fs_info->endio_meta_workers);
+	btrq_stop_workers(&fs_info->endio_meta_write_workers);
+	btrq_stop_workers(&fs_info->endio_write_workers);
+	btrq_stop_workers(&fs_info->submit_workers);
+	btrq_stop_workers(&fs_info->enospc_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 94627c4..ece1b59 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2867,10 +2867,10 @@ static void check_force_delalloc(struct btrfs_space_info *meta_sinfo)
 struct async_flush {
 	struct btrfs_root *root;
 	struct btrfs_space_info *info;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
-static noinline void flush_delalloc_async(struct btrfs_work *work)
+static noinline void flush_delalloc_async(struct btrq_work *work)
 {
 	struct async_flush *async;
 	struct btrfs_root *root;
@@ -2950,8 +2950,7 @@ static void flush_delalloc(struct btrfs_root *root,
 	async->info = info;
 	async->work.func = flush_delalloc_async;
 
-	btrfs_queue_worker(&root->fs_info->enospc_workers,
-			   &async->work);
+	btrq_queue_worker(&root->fs_info->enospc_workers, &async->work);
 	wait_on_flush(info);
 	return;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b3ad168..541f104 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -261,7 +261,7 @@ struct async_cow {
 	u64 start;
 	u64 end;
 	struct list_head extents;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -854,7 +854,7 @@ out:
 /*
  * work queue call back to started compression on a file and pages
  */
-static noinline void async_cow_start(struct btrfs_work *work)
+static noinline void async_cow_start(struct btrq_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
@@ -870,7 +870,7 @@ static noinline void async_cow_start(struct btrfs_work *work)
 /*
  * work queue call back to submit previously compressed pages
  */
-static noinline void async_cow_submit(struct btrfs_work *work)
+static noinline void async_cow_submit(struct btrq_work *work)
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root;
@@ -893,7 +893,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 		submit_compressed_extents(async_cow->inode, async_cow);
 }
 
-static noinline void async_cow_free(struct btrfs_work *work)
+static noinline void async_cow_free(struct btrq_work *work)
 {
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
@@ -936,8 +936,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 			PAGE_CACHE_SHIFT;
 		atomic_add(nr_pages, &root->fs_info->async_delalloc_pages);
 
-		btrfs_queue_worker(&root->fs_info->delalloc_workers,
-				   &async_cow->work);
+		btrq_queue_worker(&root->fs_info->delalloc_workers,
+				  &async_cow->work);
 
 		if (atomic_read(&root->fs_info->async_delalloc_pages) > limit) {
 			wait_event(root->fs_info->async_submit_wait,
@@ -1507,10 +1507,10 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end)
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
-static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
+static void btrfs_writepage_fixup_worker(struct btrq_work *work)
 {
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
@@ -1588,7 +1588,7 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 	page_cache_get(page);
 	fixup->work.func = btrfs_writepage_fixup_worker;
 	fixup->page = page;
-	btrfs_queue_worker(&root->fs_info->fixup_workers, &fixup->work);
+	btrq_queue_worker(&root->fs_info->fixup_workers, &fixup->work);
 	return -EAGAIN;
 }
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cfcc93c..3c72366 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -21,13 +21,13 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/rbtree.h>
+#include <linux/btrqueue.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "volumes.h"
 #include "locking.h"
 #include "btrfs_inode.h"
-#include "async-thread.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -137,7 +137,7 @@ struct reloc_control {
 	struct btrfs_root *extent_root;
 	/* inode for moving data */
 	struct inode *data_inode;
-	struct btrfs_workers workers;
+	struct btrq_workers workers;
 	/* tree blocks have been processed */
 	struct extent_io_tree processed_blocks;
 	/* map start of tree root to corresponding reloc tree */
@@ -161,7 +161,7 @@ struct reloc_control {
  * merge reloc tree to corresponding fs tree in worker threads
  */
 struct async_merge {
-	struct btrfs_work work;
+	struct btrq_work work;
 	struct reloc_control *rc;
 	struct btrfs_root *root;
 	struct completion *done;
@@ -1777,7 +1777,7 @@ out:
  * this function merges reloc tree with corresponding fs tree,
  * and then drops the reloc tree.
  */
-static void merge_func(struct btrfs_work *work)
+static void merge_func(struct btrq_work *work)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
@@ -1832,7 +1832,7 @@ static int merge_reloc_roots(struct reloc_control *rc)
 		async->done = &done;
 		async->num_pending = &num_pending;
 		atomic_inc(&num_pending);
-		btrfs_queue_worker(&rc->workers, &async->work);
+		btrq_queue_worker(&rc->workers, &async->work);
 	}
 
 	if (!atomic_dec_and_test(&num_pending))
@@ -3517,8 +3517,8 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	rc->block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!rc->block_group);
 
-	btrfs_init_workers(&rc->workers, "relocate",
-			   fs_info->thread_pool_size, NULL);
+	btrq_init_workers(&rc->workers, "btrfs-relocate",
+			  fs_info->thread_pool_size, NULL);
 
 	rc->extent_root = extent_root;
 	btrfs_prepare_block_group_relocation(extent_root, rc->block_group);
@@ -3588,7 +3588,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
 out:
 	iput(rc->data_inode);
-	btrfs_stop_workers(&rc->workers);
+	btrq_stop_workers(&rc->workers);
 	btrfs_put_block_group(rc->block_group);
 	kfree(rc);
 	return err;
@@ -3700,8 +3700,8 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 
 	mapping_tree_init(&rc->reloc_root_tree);
 	INIT_LIST_HEAD(&rc->reloc_roots);
-	btrfs_init_workers(&rc->workers, "relocate",
-			   root->fs_info->thread_pool_size, NULL);
+	btrq_init_workers(&rc->workers, "btrfs-relocate",
+			  root->fs_info->thread_pool_size, NULL);
 	rc->extent_root = root->fs_info->extent_root;
 
 	set_reloc_control(rc);
@@ -3736,7 +3736,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	btrfs_commit_transaction(trans, rc->extent_root);
 out:
 	if (rc) {
-		btrfs_stop_workers(&rc->workers);
+		btrq_stop_workers(&rc->workers);
 		kfree(rc);
 	}
 	while (!list_empty(&reloc_roots)) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7eda483..371052c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/iocontext.h>
+#include <linux/btrqueue.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -29,7 +30,6 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
-#include "async-thread.h"
 
 struct map_lookup {
 	u64 type;
@@ -316,7 +316,7 @@ loop_lock:
 			device->running_pending = 1;
 
 			spin_unlock(&device->io_lock);
-			btrfs_requeue_work(&device->work);
+			btrq_requeue_work(&device->work);
 			goto done;
 		}
 	}
@@ -350,7 +350,7 @@ done:
 	return 0;
 }
 
-static void pending_bios_fn(struct btrfs_work *work)
+static void pending_bios_fn(struct btrq_work *work)
 {
 	struct btrfs_device *device;
 
@@ -2907,7 +2907,7 @@ struct async_sched {
 	struct bio *bio;
 	int rw;
 	struct btrfs_fs_info *info;
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
 /*
@@ -2961,8 +2961,8 @@ static noinline int schedule_bio(struct btrfs_root *root,
 	spin_unlock(&device->io_lock);
 
 	if (should_queue)
-		btrfs_queue_worker(&root->fs_info->submit_workers,
-				   &device->work);
+		btrq_queue_worker(&root->fs_info->submit_workers,
+				  &device->work);
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 31b0fab..f36e6ec 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -20,7 +20,7 @@
 #define __BTRFS_VOLUMES_
 
 #include <linux/bio.h>
-#include "async-thread.h"
+#include <linux/btrqueue.h>
 
 struct buffer_head;
 struct btrfs_pending_bios {
@@ -82,7 +82,7 @@ struct btrfs_device {
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 
-	struct btrfs_work work;
+	struct btrq_work work;
 };
 
 struct btrfs_fs_devices {
diff --git a/fs/btrfs/async-thread.h b/include/linux/btrqueue.h
similarity index 76%
rename from fs/btrfs/async-thread.h
rename to include/linux/btrqueue.h
index 5077746..d5093e6 100644
--- a/fs/btrfs/async-thread.h
+++ b/include/linux/btrqueue.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_ASYNC_THREAD_
 #define __BTRFS_ASYNC_THREAD_
 
-struct btrfs_worker_thread;
+struct btrq_worker_thread;
 
 /*
  * This is similar to a workqueue, but it is meant to spread the operations
@@ -28,14 +28,14 @@ struct btrfs_worker_thread;
  * cut down on context switches.
  *
  * By default threads are added on demand up to 2 * the number of cpus.
- * Changing struct btrfs_workers->max_workers is one way to prevent
+ * Changing struct btrq_workers->max_workers is one way to prevent
  * demand creation of kthreads.
  *
- * the basic model of these worker threads is to embed a btrfs_work
+ * the basic model of these worker threads is to embed a btrq_work
  * structure in your own data struct, and use container_of in a
  * work function to get back to your data struct.
  */
-struct btrfs_work {
+struct btrq_work {
 	/*
 	 * func should be set to the function you want called
 	 * your work struct is passed as the only arg
@@ -44,9 +44,9 @@ struct btrfs_work {
 	 * and it is called to complete a given work item in the same
 	 * order they were sent to the queue.
 	 */
-	void (*func)(struct btrfs_work *work);
-	void (*ordered_func)(struct btrfs_work *work);
-	void (*ordered_free)(struct btrfs_work *work);
+	void (*func)(struct btrq_work *work);
+	void (*ordered_func)(struct btrq_work *work);
+	void (*ordered_free)(struct btrq_work *work);
 
 	/*
 	 * flags should be set to zero.  It is used to make sure the
@@ -55,18 +55,18 @@ struct btrfs_work {
 	unsigned long flags;
 
 	/* don't touch these */
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	struct list_head list;
 	struct list_head order_list;
 };
 
-struct btrfs_workers {
+struct btrq_workers {
 	/* current number of running workers */
 	int num_workers;
 
 	int num_workers_starting;
 
-	/* max number of workers allowed.  changed by btrfs_start_workers */
+	/* max number of workers allowed.  changed by btrq_start_workers */
 	int max_workers;
 
 	/* once a worker has this many requests or fewer, it is idle */
@@ -83,7 +83,7 @@ struct btrfs_workers {
 	 * to start them at a later time?  If we can't sleep, this indicates
 	 * which queue we need to use to schedule thread creation.
 	 */
-	struct btrfs_workers *atomic_worker_start;
+	struct btrq_workers *atomic_worker_start;
 
 	/* list with all the work threads.  The workers on the idle thread
 	 * may be actively servicing jobs, but they haven't yet hit the
@@ -109,11 +109,11 @@ struct btrfs_workers {
 	char *name;
 };
 
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
-int btrfs_start_workers(struct btrfs_workers *workers, int num_workers);
-int btrfs_stop_workers(struct btrfs_workers *workers);
-void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
-			struct btrfs_workers *async_starter);
-int btrfs_requeue_work(struct btrfs_work *work);
-void btrfs_set_work_high_prio(struct btrfs_work *work);
+int btrq_queue_worker(struct btrq_workers *workers, struct btrq_work *work);
+int btrq_start_workers(struct btrq_workers *workers, int num_workers);
+int btrq_stop_workers(struct btrq_workers *workers);
+void btrq_init_workers(struct btrq_workers *workers, char *name, int max,
+		       struct btrq_workers *async_starter);
+int btrq_requeue_work(struct btrq_work *work);
+void btrq_set_work_high_prio(struct btrq_work *work);
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 8d75d35..181d100 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -118,6 +118,12 @@ config DECOMPRESS_LZMA
 	tristate
 
 #
+# "Butter" workqueue for load balanced work
+#
+config BTRQ
+	tristate
+
+#
 # Generic allocator support is selected if needed
 #
 config GENERIC_ALLOCATOR
diff --git a/lib/Makefile b/lib/Makefile
index 012506f..29bdca1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -70,6 +70,8 @@ lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 
+obj-$(CONFIG_BTRQ) += btrqueue.o
+
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
 obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
diff --git a/fs/btrfs/async-thread.c b/lib/btrqueue.c
similarity index 82%
rename from fs/btrfs/async-thread.c
rename to lib/btrqueue.c
index c0861e7..d22d11f 100644
--- a/fs/btrfs/async-thread.c
+++ b/lib/btrqueue.c
@@ -20,7 +20,8 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
-#include "async-thread.h"
+#include <linux/btrqueue.h>
+#include <linux/module.h>
 
 #define WORK_QUEUED_BIT 0
 #define WORK_DONE_BIT 1
@@ -31,15 +32,15 @@
  * container for the kthread task pointer and the list of pending work
  * One of these is allocated per thread.
  */
-struct btrfs_worker_thread {
+struct btrq_worker_thread {
 	/* pool we belong to */
-	struct btrfs_workers *workers;
+	struct btrq_workers *workers;
 
-	/* list of struct btrfs_work that are waiting for service */
+	/* list of struct btrq_work that are waiting for service */
 	struct list_head pending;
 	struct list_head prio_pending;
 
-	/* list of worker threads from struct btrfs_workers */
+	/* list of worker threads from struct btrq_workers */
 	struct list_head worker_list;
 
 	/* kthread */
@@ -64,12 +65,12 @@ struct btrfs_worker_thread {
 };
 
 /*
- * btrfs_start_workers uses kthread_run, which can block waiting for memory
+ * btrq_start_workers uses kthread_run, which can block waiting for memory
  * for a very long time.  It will actually throttle on page writeback,
- * and so it may not make progress until after our btrfs worker threads
+ * and so it may not make progress until after our btrq worker threads
  * process all of the pending work structs in their queue
  *
- * This means we can't use btrfs_start_workers from inside a btrfs worker
+ * This means we can't use btrq_start_workers from inside a btrq worker
  * thread that is used as part of cleaning dirty memory, which pretty much
  * involves all of the worker threads.
  *
@@ -79,19 +80,19 @@ struct btrfs_worker_thread {
  * another worker.
  */
 struct worker_start {
-	struct btrfs_work work;
-	struct btrfs_workers *queue;
+	struct btrq_work work;
+	struct btrq_workers *queue;
 };
 
-static void start_new_worker_func(struct btrfs_work *work)
+static void start_new_worker_func(struct btrq_work *work)
 {
 	struct worker_start *start;
 	start = container_of(work, struct worker_start, work);
-	btrfs_start_workers(start->queue, 1);
+	btrq_start_workers(start->queue, 1);
 	kfree(start);
 }
 
-static int start_new_worker(struct btrfs_workers *queue)
+static int start_new_worker(struct btrq_workers *queue)
 {
 	struct worker_start *start;
 	int ret;
@@ -102,7 +103,7 @@ static int start_new_worker(struct btrfs_workers *queue)
 
 	start->work.func = start_new_worker_func;
 	start->queue = queue;
-	ret = btrfs_queue_worker(queue->atomic_worker_start, &start->work);
+	ret = btrq_queue_worker(queue->atomic_worker_start, &start->work);
 	if (ret)
 		kfree(start);
 	return ret;
@@ -112,7 +113,7 @@ static int start_new_worker(struct btrfs_workers *queue)
  * helper function to move a thread onto the idle list after it
  * has finished some requests.
  */
-static void check_idle_worker(struct btrfs_worker_thread *worker)
+static void check_idle_worker(struct btrq_worker_thread *worker)
 {
 	if (!worker->idle && atomic_read(&worker->num_pending) <
 	    worker->workers->idle_thresh / 2) {
@@ -133,7 +134,7 @@ static void check_idle_worker(struct btrfs_worker_thread *worker)
  * helper function to move a thread off the idle list after new
  * pending work is added.
  */
-static void check_busy_worker(struct btrfs_worker_thread *worker)
+static void check_busy_worker(struct btrq_worker_thread *worker)
 {
 	if (worker->idle && atomic_read(&worker->num_pending) >=
 	    worker->workers->idle_thresh) {
@@ -149,9 +150,9 @@ static void check_busy_worker(struct btrfs_worker_thread *worker)
 	}
 }
 
-static void check_pending_worker_creates(struct btrfs_worker_thread *worker)
+static void check_pending_worker_creates(struct btrq_worker_thread *worker)
 {
-	struct btrfs_workers *workers = worker->workers;
+	struct btrq_workers *workers = worker->workers;
 	unsigned long flags;
 
 	rmb();
@@ -176,8 +177,8 @@ out:
 	spin_unlock_irqrestore(&workers->lock, flags);
 }
 
-static noinline int run_ordered_completions(struct btrfs_workers *workers,
-					    struct btrfs_work *work)
+static noinline int run_ordered_completions(struct btrq_workers *workers,
+					    struct btrq_work *work)
 {
 	if (!workers->ordered)
 		return 0;
@@ -189,10 +190,10 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 	while (1) {
 		if (!list_empty(&workers->prio_order_list)) {
 			work = list_entry(workers->prio_order_list.next,
-					  struct btrfs_work, order_list);
+					  struct btrq_work, order_list);
 		} else if (!list_empty(&workers->order_list)) {
 			work = list_entry(workers->order_list.next,
-					  struct btrfs_work, order_list);
+					  struct btrq_work, order_list);
 		} else {
 			break;
 		}
@@ -221,13 +222,13 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 	return 0;
 }
 
-static void put_worker(struct btrfs_worker_thread *worker)
+static void put_worker(struct btrq_worker_thread *worker)
 {
 	if (atomic_dec_and_test(&worker->refs))
 		kfree(worker);
 }
 
-static int try_worker_shutdown(struct btrfs_worker_thread *worker)
+static int try_worker_shutdown(struct btrq_worker_thread *worker)
 {
 	int freeit = 0;
 
@@ -252,11 +253,11 @@ static int try_worker_shutdown(struct btrfs_worker_thread *worker)
 	return freeit;
 }
 
-static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
+static struct btrq_work *get_next_work(struct btrq_worker_thread *worker,
 					struct list_head *prio_head,
 					struct list_head *head)
 {
-	struct btrfs_work *work = NULL;
+	struct btrq_work *work = NULL;
 	struct list_head *cur = NULL;
 
 	if(!list_empty(prio_head))
@@ -287,7 +288,7 @@ refill:
 		goto out_fail;
 
 out:
-	work = list_entry(cur, struct btrfs_work, list);
+	work = list_entry(cur, struct btrq_work, list);
 
 out_fail:
 	return work;
@@ -298,10 +299,10 @@ out_fail:
  */
 static int worker_loop(void *arg)
 {
-	struct btrfs_worker_thread *worker = arg;
+	struct btrq_worker_thread *worker = arg;
 	struct list_head head;
 	struct list_head prio_head;
-	struct btrfs_work *work;
+	struct btrq_work *work;
 
 	INIT_LIST_HEAD(&head);
 	INIT_LIST_HEAD(&prio_head);
@@ -403,17 +404,17 @@ again:
 /*
  * this will wait for all the worker threads to shutdown
  */
-int btrfs_stop_workers(struct btrfs_workers *workers)
+int btrq_stop_workers(struct btrq_workers *workers)
 {
 	struct list_head *cur;
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	int can_stop;
 
 	spin_lock_irq(&workers->lock);
 	list_splice_init(&workers->idle_list, &workers->worker_list);
 	while (!list_empty(&workers->worker_list)) {
 		cur = workers->worker_list.next;
-		worker = list_entry(cur, struct btrfs_worker_thread,
+		worker = list_entry(cur, struct btrq_worker_thread,
 				    worker_list);
 
 		atomic_inc(&worker->refs);
@@ -433,12 +434,13 @@ int btrfs_stop_workers(struct btrfs_workers *workers)
 	spin_unlock_irq(&workers->lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btrq_stop_workers);
 
 /*
- * simple init on struct btrfs_workers
+ * simple init on struct btrq_workers
  */
-void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
-			struct btrfs_workers *async_helper)
+void btrq_init_workers(struct btrq_workers *workers, char *name, int max,
+			struct btrq_workers *async_helper)
 {
 	workers->num_workers = 0;
 	workers->num_workers_starting = 0;
@@ -455,15 +457,16 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 	workers->atomic_start_pending = 0;
 	workers->atomic_worker_start = async_helper;
 }
+EXPORT_SYMBOL_GPL(btrq_init_workers);
 
 /*
  * starts new worker threads.  This does not enforce the max worker
  * count in case you need to temporarily go past it.
  */
-static int __btrfs_start_workers(struct btrfs_workers *workers,
+static int __btrq_start_workers(struct btrq_workers *workers,
 				 int num_workers)
 {
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	int ret = 0;
 	int i;
 
@@ -483,7 +486,7 @@ static int __btrfs_start_workers(struct btrfs_workers *workers,
 		atomic_set(&worker->refs, 1);
 		worker->workers = workers;
 		worker->task = kthread_run(worker_loop, worker,
-					   "btrfs-%s-%d", workers->name,
+					   "%s/%d", workers->name,
 					   workers->num_workers + i);
 		if (IS_ERR(worker->task)) {
 			ret = PTR_ERR(worker->task);
@@ -500,26 +503,27 @@ static int __btrfs_start_workers(struct btrfs_workers *workers,
 	}
 	return 0;
 fail:
-	btrfs_stop_workers(workers);
+	btrq_stop_workers(workers);
 	return ret;
 }
 
-int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
+int btrq_start_workers(struct btrq_workers *workers, int num_workers)
 {
 	spin_lock_irq(&workers->lock);
 	workers->num_workers_starting += num_workers;
 	spin_unlock_irq(&workers->lock);
-	return __btrfs_start_workers(workers, num_workers);
+	return __btrq_start_workers(workers, num_workers);
 }
+EXPORT_SYMBOL_GPL(btrq_start_workers);
 
 /*
  * run through the list and find a worker thread that doesn't have a lot
  * to do right now.  This can return null if we aren't yet at the thread
  * count limit and all of the threads are busy.
  */
-static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
+static struct btrq_worker_thread *next_worker(struct btrq_workers *workers)
 {
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	struct list_head *next;
 	int enforce_min;
 
@@ -534,7 +538,7 @@ static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
 	 */
 	if (!list_empty(&workers->idle_list)) {
 		next = workers->idle_list.next;
-		worker = list_entry(next, struct btrfs_worker_thread,
+		worker = list_entry(next, struct btrq_worker_thread,
 				    worker_list);
 		return worker;
 	}
@@ -548,7 +552,7 @@ static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
 	 * requests submitted at roughly the same time onto the same worker.
 	 */
 	next = workers->worker_list.next;
-	worker = list_entry(next, struct btrfs_worker_thread, worker_list);
+	worker = list_entry(next, struct btrq_worker_thread, worker_list);
 	worker->sequence++;
 
 	if (worker->sequence % workers->idle_thresh == 0)
@@ -561,9 +565,9 @@ static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
  * an idle worker, start a new worker up to the max count, or just return
  * one of the existing busy workers.
  */
-static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
+static struct btrq_worker_thread *find_worker(struct btrq_workers *workers)
 {
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	unsigned long flags;
 	struct list_head *fallback;
 
@@ -582,7 +586,7 @@ again:
 			workers->num_workers_starting++;
 			spin_unlock_irqrestore(&workers->lock, flags);
 			/* we're below the limit, start another worker */
-			__btrfs_start_workers(workers, 1);
+			__btrq_start_workers(workers, 1);
 			goto again;
 		}
 	}
@@ -600,7 +604,7 @@ fallback:
 		fallback = workers->idle_list.next;
 	BUG_ON(!fallback);
 	worker = list_entry(fallback,
-		  struct btrfs_worker_thread, worker_list);
+		  struct btrq_worker_thread, worker_list);
 found:
 	/*
 	 * this makes sure the worker doesn't exit before it is placed
@@ -612,13 +616,13 @@ found:
 }
 
 /*
- * btrfs_requeue_work just puts the work item back on the tail of the list
+ * btrq_requeue_work just puts the work item back on the tail of the list
  * it was taken from.  It is intended for use with long running work functions
  * that make some progress and want to give the cpu up for others.
  */
-int btrfs_requeue_work(struct btrfs_work *work)
+int btrq_requeue_work(struct btrq_work *work)
 {
-	struct btrfs_worker_thread *worker = work->worker;
+	struct btrq_worker_thread *worker = work->worker;
 	unsigned long flags;
 	int wake = 0;
 
@@ -654,18 +658,20 @@ out:
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btrq_requeue_work);
 
-void btrfs_set_work_high_prio(struct btrfs_work *work)
+void btrq_set_work_high_prio(struct btrq_work *work)
 {
 	set_bit(WORK_HIGH_PRIO_BIT, &work->flags);
 }
+EXPORT_SYMBOL_GPL(btrq_set_work_high_prio);
 
 /*
- * places a struct btrfs_work into the pending queue of one of the kthreads
+ * places a struct btrq_work into the pending queue of one of the kthreads
  */
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
+int btrq_queue_worker(struct btrq_workers *workers, struct btrq_work *work)
 {
-	struct btrfs_worker_thread *worker;
+	struct btrq_worker_thread *worker;
 	unsigned long flags;
 	int wake = 0;
 
@@ -714,3 +720,4 @@ int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 out:
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btrq_queue_worker);

