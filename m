From: bchociej@gmail.com
Subject: [RFC PATCH 5/5] Btrfs: Add hooks to enable hot data tracking
Date: Tue, 27 Jul 2010 17:00:23 -0500
Message-ID: <1280268023-18408-6-git-send-email-bchociej@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bcchocie@us.ibm.com>

Miscellaneous features that enable hot data tracking features, open the
door for future hot data migration to faster media, and generally make
the hot data functions a bit more friendly.

ctree.h: Add the root hot_inode_tree and heat hashlists. Defines some
mount options and inode flags for turning all of the hot data
functionality on and off globally and per file. Defines some guard
macros that enforce the mount options and inode flags.

disk-io.c: Initialization and freeing of various structures.

extent_io.c: Add hook into extent_write_cache_pages to enable hot data
tracking functionality. Actual IO tracking is done here (and in
inode.c).

inode.c: Add hooks into btrfs_direct_IO and btrfs_readpages to enable
hot data tracking functionality. Actual IO tracking is done here (and
in extent_io.c).

super.c: Implements aforementioned mount options, does various
initializing and freeing.

Signed-off-by: Ben Chociej <bcchocie@us.ibm.com>
Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Signed-off-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
---
 fs/btrfs/Makefile    |    5 ++++-
 fs/btrfs/ctree.h     |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c   |   29 +++++++++++++++++++++++++++++
 fs/btrfs/extent_io.c |   18 ++++++++++++++++++
 fs/btrfs/inode.c     |   27 +++++++++++++++++++++++++++
 fs/btrfs/super.c     |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..8bc70ba 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o hotdata_map.o \
+	   hotdata_hash.o
+
+btrfs-$(CONFIG_DEBUG_FS)	+= debugfs.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..7284cb5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -31,6 +31,8 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -877,6 +879,7 @@ struct btrfs_fs_info {
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
+
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
@@ -950,6 +953,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers submit_workers;
+
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
@@ -958,6 +962,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers fixup_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+
 	int thread_pool_size;
 
 	struct kobject super_kobj;
@@ -1092,6 +1097,15 @@ struct btrfs_root {
 	/* red-black tree that keeps track of in-memory inodes */
 	struct rb_root inode_tree;
 
+	/* red-black tree that keeps track of fs-wide hot data */
+	struct hot_inode_tree hot_inode_tree;
+
+	/* hash map of inode temperature */
+	struct heat_hashlist_entry heat_inode_hl[HEAT_HASH_SIZE];
+
+	/* hash map of range temperature */
+	struct heat_hashlist_entry heat_range_hl[HEAT_HASH_SIZE];
+
 	/*
 	 * right now this just gets used so that a root has its own devid
 	 * for stat.  It may be used for more later
@@ -1192,6 +1206,8 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+#define BTRFS_MOUNT_HOTDATA_TRACK	(1 << 12)
+#define BTRFS_MOUNT_HOTDATA_MOVE	(1 << 13)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -1211,6 +1227,24 @@ struct btrfs_root {
 #define BTRFS_INODE_NODUMP		(1 << 8)
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
+#define BTRFS_INODE_NO_HOTDATA_TRACK	(1 << 11)
+#define BTRFS_INODE_NO_HOTDATA_MOVE	(1 << 12)
+
+/* Hot data tracking -- guard macros */
+#define BTRFS_TRACKING_HOT_DATA(btrfs_root)				\
+(btrfs_test_opt(btrfs_root, HOTDATA_TRACK))
+
+#define BTRFS_MOVING_HOT_DATA(btrfs_root)				\
+((btrfs_test_opt(btrfs_root, HOTDATA_TRACK)) &&				\
+!(btrfs_root->fs_info->sb->s_flags & MS_RDONLY))
+
+#define BTRFS_TRACK_THIS_INODE(btrfs_inode)				\
+((BTRFS_TRACKING_HOT_DATA(btrfs_inode->root)) &&			\
+!(btrfs_inode->flags & BTRFS_INODE_NO_HOTDATA_TRACK))
+
+#define BTRFS_MOVE_THIS_INODE(btrfs_inode)				\
+((BTRFS_MOVING_HOT_DATA(btrfs_inode->root)) &&				\
+!(btrfs_inode->flags & BTRFS_INODE_NO_HOTDATA_MOVE))
 
 /* some macros to generate set/get funcs for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple
@@ -2457,6 +2491,14 @@ int btrfs_sysfs_add_root(struct btrfs_root *root);
 void btrfs_sysfs_del_root(struct btrfs_root *root);
 void btrfs_sysfs_del_super(struct btrfs_fs_info *root);
 
+#ifdef CONFIG_DEBUG_FS
+/* debugfs.c */
+int btrfs_init_debugfs(void);
+void btrfs_exit_debugfs(void);
+int btrfs_init_debugfs_volume(const char *, struct super_block *);
+void btrfs_exit_debugfs_volume(struct super_block *);
+#endif
+
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..8f9c866 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -39,6 +39,7 @@
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
+#include "hotdata_hash.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -893,11 +894,32 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return 0;
 }
 
+static inline void __setup_hotdata(struct btrfs_root *root)
+{
+	int i;
+
+	hot_inode_tree_init(&root->hot_inode_tree);
+
+	memset(&root->heat_inode_hl, 0, sizeof(root->heat_inode_hl));
+	memset(&root->heat_range_hl, 0, sizeof(root->heat_range_hl));
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		INIT_HLIST_HEAD(&root->heat_inode_hl[i].hashhead);
+		INIT_HLIST_HEAD(&root->heat_range_hl[i].hashhead);
+
+		rwlock_init(&root->heat_inode_hl[i].rwlock);
+		rwlock_init(&root->heat_range_hl[i].rwlock);
+
+		root->heat_inode_hl[i].temperature = i;
+		root->heat_range_hl[i].temperature = i;
+	}
+}
+
 static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 			u32 stripesize, struct btrfs_root *root,
 			struct btrfs_fs_info *fs_info,
 			u64 objectid)
 {
+
 	root->node = NULL;
 	root->commit_root = NULL;
 	root->sectorsize = sectorsize;
@@ -945,6 +967,10 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
 	memset(&root->root_kobj, 0, sizeof(root->root_kobj));
+
+	if (BTRFS_TRACKING_HOT_DATA(root))
+		__setup_hotdata(root);
+
 	root->defrag_trans_start = fs_info->generation;
 	init_completion(&root->kobj_unregister);
 	root->defrag_running = 0;
@@ -2324,6 +2350,9 @@ static void free_fs_root(struct btrfs_root *root)
 		down_write(&root->anon_super.s_umount);
 		kill_anon_super(&root->anon_super);
 	}
+
+	free_heat_hashlists(root);
+	free_hot_inode_tree(root);
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
 	kfree(root->name);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a4080c2..8fa2820 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2468,8 +2468,10 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
+	int nr_written = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t start;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
@@ -2486,6 +2488,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 			range_whole = 1;
 		scanned = 1;
 	}
+	start = index << PAGE_CACHE_SHIFT;
 retry:
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
@@ -2547,6 +2550,7 @@ retry:
 			 * at any time
 			 */
 			nr_to_write_done = wbc->nr_to_write <= 0;
+			nr_written += 1;
 		}
 		pagevec_release(&pvec);
 		cond_resched();
@@ -2560,6 +2564,20 @@ retry:
 		index = 0;
 		goto retry;
 	}
+
+	/*
+	 * i_ino = 1 appears to come from metadata operations, ignore
+	 * those writes
+	 */
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(mapping->host)) &&
+		mapping->host->i_ino > 1) {
+		printk(KERN_INFO "btrfs recorded a write %lu, %lu, %lu\n",
+			mapping->host->i_ino, start, nr_written *
+			PAGE_CACHE_SIZE);
+		btrfs_update_freqs(mapping->host, start,
+			nr_written * PAGE_CACHE_SIZE, 1);
+	}
+
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..010eb29 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
 #include <linux/slab.h>
+#include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -50,6 +51,7 @@
 #include "tree-log.h"
 #include "compression.h"
 #include "locking.h"
+#include "hotdata_map.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -4515,6 +4517,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 		if (btrfs_test_opt(root, NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+		if (!btrfs_test_opt(root, HOTDATA_TRACK))
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NO_HOTDATA_TRACK;
+		if (!btrfs_test_opt(root, HOTDATA_MOVE))
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NO_HOTDATA_MOVE;
 	}
 
 	insert_inode_hash(inode);
@@ -5781,6 +5787,10 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	lockstart = offset;
 	lockend = offset + count - 1;
 
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(inode)) && count > 0)
+		btrfs_update_freqs(inode, lockstart, (u64) count,
+			writing);
+
 	if (writing) {
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
@@ -5860,7 +5870,15 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 int btrfs_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
+	u64 start;
+
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	start = (u64) page->index << PAGE_CACHE_SHIFT;
+
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(page->mapping->host)))
+		btrfs_update_freqs(page->mapping->host, start,
+			PAGE_CACHE_SIZE, 0);
+
 	return extent_read_full_page(tree, page, btrfs_get_extent);
 }
 
@@ -5892,7 +5910,16 @@ btrfs_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	struct extent_io_tree *tree;
+	u64 start, len;
+
 	tree = &BTRFS_I(mapping->host)->io_tree;
+	start = (u64) (list_entry(pages->prev, struct page, lru)->index)
+		<< PAGE_CACHE_SHIFT;
+	len = nr_pages * PAGE_CACHE_SIZE;
+
+	if (len > 0 && BTRFS_TRACK_THIS_INODE(BTRFS_I(mapping->host)))
+		btrfs_update_freqs(mapping->host, start, len, 0);
+
 	return extent_readpages(tree, mapping, pages, nr_pages,
 				btrfs_get_extent);
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 859ddaa..db91b38 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -51,6 +51,8 @@
 #include "version.h"
 #include "export.h"
 #include "compression.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
 
 static const struct super_operations btrfs_super_ops;
 
@@ -59,6 +61,9 @@ static void btrfs_put_super(struct super_block *sb)
 	struct btrfs_root *root = btrfs_sb(sb);
 	int ret;
 
+	if (BTRFS_TRACKING_HOT_DATA(root))
+		btrfs_exit_debugfs_volume(sb);
+
 	ret = close_ctree(root);
 	sb->s_fs_info = NULL;
 }
@@ -68,7 +73,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_hotdatatrack, Opt_hotdatamove, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -92,6 +97,8 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_hotdatatrack, "hotdatatrack"},
+	{Opt_hotdatamove, "hotdatamove"},
 	{Opt_err, NULL},
 };
 
@@ -235,6 +242,18 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_hotdatamove:
+			printk(KERN_INFO "btrfs: turning on hot data "
+				"migration\n");
+			printk(KERN_INFO "       (implies hotdatatrack, "
+				"no ssd_spread)\n");
+			btrfs_set_opt(info->mount_opt, HOTDATA_MOVE);
+			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
+		case Opt_hotdatatrack:
+			printk(KERN_INFO "btrfs: turning on hot data"
+				" tracking\n");
+			btrfs_set_opt(info->mount_opt, HOTDATA_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -457,6 +476,7 @@ static int btrfs_fill_super(struct super_block *sb,
 		printk("btrfs: open_ctree failed\n");
 		return PTR_ERR(tree_root);
 	}
+
 	sb->s_fs_info = tree_root;
 	disk_super = &tree_root->fs_info->super_copy;
 
@@ -659,6 +679,9 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 	mnt->mnt_sb = s;
 	mnt->mnt_root = root;
 
+	if (btrfs_test_opt(btrfs_sb(s), HOTDATA_TRACK))
+		btrfs_init_debugfs_volume(dev_name, s);
+
 	kfree(subvol_name);
 	return 0;
 
@@ -846,18 +869,30 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_sysfs;
 
-	err = extent_io_init();
+	err = btrfs_init_debugfs();
 	if (err)
 		goto free_cachep;
 
+	err = extent_io_init();
+	if (err)
+		goto free_debugfs;
+
 	err = extent_map_init();
 	if (err)
 		goto free_extent_io;
 
-	err = btrfs_interface_init();
+	err = hot_inode_item_init();
 	if (err)
 		goto free_extent_map;
 
+	err = hot_range_item_init();
+	if (err)
+		goto free_hot_inode_item;
+
+	err = btrfs_interface_init();
+	if (err)
+		goto free_hot_range_item;
+
 	err = register_filesystem(&btrfs_fs_type);
 	if (err)
 		goto unregister_ioctl;
@@ -867,10 +902,16 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_hot_range_item:
+	hot_range_item_exit();
+free_hot_inode_item:
+	hot_inode_item_exit();
 free_extent_map:
 	extent_map_exit();
 free_extent_io:
 	extent_io_exit();
+free_debugfs:
+	btrfs_exit_debugfs();
 free_cachep:
 	btrfs_destroy_cachep();
 free_sysfs:
@@ -886,6 +927,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_interface_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
+	btrfs_exit_debugfs();
 	btrfs_cleanup_fs_uuids();
 	btrfs_zlib_exit();
 }
-- 
1.7.1

