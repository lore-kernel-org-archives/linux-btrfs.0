From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: add initial tracepoint support for btrfs
Date: Thu, 24 Mar 2011 19:18:59 +0800
Message-ID: <4D8B28A3.7050105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Tracepoints can provide insight into why btrfs hits bugs and be greatly
helpful for debugging, e.g
              dd-7822  [000]  2121.641088: btrfs_inode_request: root = 5(FS_TREE), gen = 4, ino = 256, blocks = 8, disk_i_size = 0, last_trans = 8, logged_trans = 0
              dd-7822  [000]  2121.641100: btrfs_inode_new: root = 5(FS_TREE), gen = 8, ino = 257, blocks = 0, disk_i_size = 0, last_trans = 0, logged_trans = 0
 btrfs-transacti-7804  [001]  2146.935420: btrfs_cow_block: root = 2(EXTENT_TREE), refs = 2, orig_buf = 29368320 (orig_level = 0), cow_buf = 29388800 (cow_level = 0)
 btrfs-transacti-7804  [001]  2146.935473: btrfs_cow_block: root = 1(ROOT_TREE), refs = 2, orig_buf = 29364224 (orig_level = 0), cow_buf = 29392896 (cow_level = 0)
 btrfs-transacti-7804  [001]  2146.972221: btrfs_transaction_commit: root = 1(ROOT_TREE), gen = 8
   flush-btrfs-2-7821  [001]  2155.824210: btrfs_chunk_alloc: root = 3(CHUNK_TREE), offset = 1103101952, size = 1073741824, num_stripes = 1, sub_stripes = 0, type = DATA
   flush-btrfs-2-7821  [001]  2155.824241: btrfs_cow_block: root = 2(EXTENT_TREE), refs = 2, orig_buf = 29388800 (orig_level = 0), cow_buf = 29396992 (cow_level = 0)
   flush-btrfs-2-7821  [001]  2155.824255: btrfs_cow_block: root = 4(DEV_TREE), refs = 2, orig_buf = 29372416 (orig_level = 0), cow_buf = 29401088 (cow_level = 0)
   flush-btrfs-2-7821  [000]  2155.824329: btrfs_cow_block: root = 3(CHUNK_TREE), refs = 2, orig_buf = 20971520 (orig_level = 0), cow_buf = 20975616 (cow_level = 0)
 btrfs-endio-wri-7800  [001]  2155.898019: btrfs_cow_block: root = 5(FS_TREE), refs = 2, orig_buf = 29384704 (orig_level = 0), cow_buf = 29405184 (cow_level = 0)
 btrfs-endio-wri-7800  [001]  2155.898043: btrfs_cow_block: root = 7(CSUM_TREE), refs = 2, orig_buf = 29376512 (orig_level = 0), cow_buf = 29409280 (cow_level = 0)

Here is what I have added:

1) ordere_extent:
        btrfs_ordered_extent_add
        btrfs_ordered_extent_remove
        btrfs_ordered_extent_start
        btrfs_ordered_extent_put

These provide critical information to understand how ordered_extents are
updated.

2) extent_map:
        btrfs_get_extent

extent_map is used in both read and write cases, and it is useful for tracking
how btrfs specific IO is running.

3) writepage:
        __extent_writepage
        btrfs_writepage_end_io_hook

Pages are cirtical resourses and produce a lot of corner cases during writeback,
so it is valuable to know how page is written to disk.

4) inode:
        btrfs_inode_new
        btrfs_inode_request
        btrfs_inode_evict

These can show where and when a inode is created, when a inode is evicted.

5) sync:
        btrfs_sync_file
        btrfs_sync_fs

These show sync arguments.

6) transaction:
        btrfs_transaction_commit

In transaction based filesystem, it will be useful to know the generation and
who does commit.

7) back reference and cow:
	btrfs_delayed_tree_ref
	btrfs_delayed_data_ref
	btrfs_delayed_ref_head
	btrfs_cow_block

Btrfs natively supports back references, these tracepoints are helpful on
understanding btrfs's COW mechanism.

8) chunk:
	btrfs_chunk_alloc
	btrfs_chunk_free

Chunk is a link between physical offset and logical offset, and stands for space
infomation in btrfs, and these are helpful on tracing space things.

9) reserved_extent:
	btrfs_reserved_extent_alloc
	btrfs_reserved_extent_free

These can show how btrfs uses its space.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c             |    3 +
 fs/btrfs/ctree.h             |    1 +
 fs/btrfs/delayed-ref.c       |    6 +
 fs/btrfs/extent-tree.c       |    4 +
 fs/btrfs/extent_io.c         |    2 +
 fs/btrfs/file.c              |    1 +
 fs/btrfs/inode.c             |   12 +
 fs/btrfs/ordered-data.c      |    8 +
 fs/btrfs/super.c             |    5 +
 fs/btrfs/transaction.c       |    2 +
 fs/btrfs/volumes.c           |   16 +-
 fs/btrfs/volumes.h           |   11 +
 include/trace/events/btrfs.h |  667 ++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 727 insertions(+), 11 deletions(-)
 create mode 100644 include/trace/events/btrfs.h

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..351515d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -542,6 +542,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	ret = __btrfs_cow_block(trans, root, buf, parent,
 				 parent_slot, cow_ret, search_start, 0);
+
+	trace_btrfs_cow_block(root, buf, *cow_ret);
+
 	return ret;
 }
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 28188a7..cd6906e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -28,6 +28,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/kobject.h>
+#include <trace/events/btrfs.h>
 #include <asm/kmap_types.h>
 #include "extent_io.h"
 #include "extent_map.h"
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e807b14..bce28f6 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -483,6 +483,8 @@ static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&head_ref->cluster);
 	mutex_init(&head_ref->mutex);
 
+	trace_btrfs_delayed_ref_head(ref, head_ref, action);
+
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
 	if (existing) {
@@ -537,6 +539,8 @@ static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 	full_ref->level = level;
 
+	trace_btrfs_delayed_tree_ref(ref, full_ref, action);
+
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
 	if (existing) {
@@ -591,6 +595,8 @@ static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
+	trace_btrfs_delayed_data_ref(ref, full_ref, action);
+
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
 	if (existing) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 100e409..ffa0136 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5387,6 +5387,8 @@ again:
 		dump_space_info(sinfo, num_bytes, 1);
 	}
 
+	trace_btrfs_reserved_extent_alloc(root, ins->objectid, ins->offset);
+
 	return ret;
 }
 
@@ -5408,6 +5410,8 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 	update_reserved_bytes(cache, len, 0, 1);
 	btrfs_put_block_group(cache);
 
+	trace_btrfs_reserved_extent_free(root, start, len);
+
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ff45b80..b7620ee 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2192,6 +2192,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	else
 		write_flags = WRITE;
 
+	trace___extent_writepage(page, inode, wbc);
+
 	WARN_ON(!PageLocked(page));
 	pg_offset = i_size & (PAGE_CACHE_SIZE - 1);
 	if (page->index > end_index ||
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 65338a1..d30ecc8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1166,6 +1166,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	int ret = 0;
 	struct btrfs_trans_handle *trans;
 
+	trace_btrfs_sync_file(file, datasync);
 
 	/* we wait first, since the writeback may change the inode */
 	root->log_batch++;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 44b9266..578f161 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1784,6 +1784,8 @@ out:
 static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
+	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
+
 	ClearPagePrivate2(page);
 	return btrfs_finish_ordered_io(page->mapping->host, start, end);
 }
@@ -3729,6 +3731,8 @@ void btrfs_evict_inode(struct inode *inode)
 	unsigned long nr;
 	int ret;
 
+	trace_btrfs_inode_evict(inode);
+
 	truncate_inode_pages(&inode->i_data, 0);
 	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
 			       root == root->fs_info->tree_root))
@@ -4518,6 +4522,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		return ERR_PTR(-ENOMEM);
 
 	if (dir) {
+		trace_btrfs_inode_request(dir);
+
 		ret = btrfs_set_inode_index(dir, index);
 		if (ret) {
 			iput(inode);
@@ -4592,6 +4598,9 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	insert_inode_hash(inode);
 	inode_tree_add(inode);
+
+	trace_btrfs_inode_new(inode);
+
 	return inode;
 fail:
 	if (dir)
@@ -5268,6 +5277,9 @@ insert:
 	}
 	write_unlock(&em_tree->lock);
 out:
+
+	trace_btrfs_get_extent(root, em);
+
 	if (path)
 		btrfs_free_path(path);
 	if (trans) {
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 083a554..a1c9404 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -202,6 +202,8 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
 
+	trace_btrfs_ordered_extent_add(inode, entry);
+
 	spin_lock(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
 			   &entry->rb_node);
@@ -387,6 +389,8 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 	struct list_head *cur;
 	struct btrfs_ordered_sum *sum;
 
+	trace_btrfs_ordered_extent_put(entry->inode, entry);
+
 	if (atomic_dec_and_test(&entry->refs)) {
 		while (!list_empty(&entry->list)) {
 			cur = entry->list.next;
@@ -420,6 +424,8 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 
+	trace_btrfs_ordered_extent_remove(inode, entry);
+
 	/*
 	 * we have no more ordered extents for this inode and
 	 * no dirty pages.  We can safely remove it from the
@@ -585,6 +591,8 @@ void btrfs_start_ordered_extent(struct inode *inode,
 	u64 start = entry->file_offset;
 	u64 end = start + entry->len - 1;
 
+	trace_btrfs_ordered_extent_start(inode, entry);
+
 	/*
 	 * pages in the range can be dirty, clean or writeback.  We
 	 * start IO on any dirty ones so the wait doesn't stall waiting
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db0a827..eeb0fd6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -52,6 +52,9 @@
 #include "export.h"
 #include "compression.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/btrfs.h>
+
 static const struct super_operations btrfs_super_ops;
 
 static const char *btrfs_decode_error(struct btrfs_fs_info *fs_info, int errno,
@@ -619,6 +622,8 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	struct btrfs_root *root = btrfs_sb(sb);
 	int ret;
 
+	trace_btrfs_sync_fs(wait);
+
 	if (!wait) {
 		filemap_flush(root->fs_info->btree_inode->i_mapping);
 		return 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d73c8d..5b4bc68 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1389,6 +1389,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
+	trace_btrfs_transaction_commit(root);
+
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	if (current->journal_info == trans)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 94334d9..96a1a88 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -33,17 +33,6 @@
 #include "volumes.h"
 #include "async-thread.h"
 
-struct map_lookup {
-	u64 type;
-	int io_align;
-	int io_width;
-	int stripe_len;
-	int sector_size;
-	int num_stripes;
-	int sub_stripes;
-	struct btrfs_bio_stripe stripes[];
-};
-
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
@@ -1922,6 +1911,8 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 
 	BUG_ON(ret);
 
+	trace_btrfs_chunk_free(root, map, chunk_offset, em->len);
+
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_del_sys_chunk(root, chunk_objectid, chunk_offset);
 		BUG_ON(ret);
@@ -2649,6 +2640,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	*num_bytes = chunk_bytes_by_type(type, calc_size,
 					 map->num_stripes, sub_stripes);
 
+	trace_btrfs_chunk_alloc(info->chunk_root, map, start, *num_bytes);
+
 	em = alloc_extent_map(GFP_NOFS);
 	if (!em) {
 		ret = -ENOMEM;
@@ -2757,6 +2750,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 					     item_size);
 		BUG_ON(ret);
 	}
+
 	kfree(chunk);
 	return 0;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7af6144..63be39b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -146,6 +146,17 @@ struct btrfs_device_info {
 	u64 max_avail;
 };
 
+struct map_lookup {
+	u64 type;
+	int io_align;
+	int io_width;
+	int stripe_len;
+	int sector_size;
+	int num_stripes;
+	int sub_stripes;
+	struct btrfs_bio_stripe stripes[];
+};
+
 /* Used to sort the devices by max_avail(descending sort) */
 int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
new file mode 100644
index 0000000..f445cff
--- /dev/null
+++ b/include/trace/events/btrfs.h
@@ -0,0 +1,667 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM btrfs
+
+#if !defined(_TRACE_BTRFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BTRFS_H
+
+#include <linux/writeback.h>
+#include <linux/tracepoint.h>
+
+struct btrfs_root;
+struct btrfs_fs_info;
+struct btrfs_inode;
+struct extent_map;
+struct btrfs_ordered_extent;
+struct btrfs_delayed_ref_node;
+struct btrfs_delayed_tree_ref;
+struct btrfs_delayed_data_ref;
+struct btrfs_delayed_ref_head;
+struct map_lookup;
+struct extent_buffer;
+
+#define show_ref_type(type)						\
+	__print_symbolic(type,						\
+		{ BTRFS_TREE_BLOCK_REF_KEY, 	"TREE_BLOCK_REF" },	\
+		{ BTRFS_EXTENT_DATA_REF_KEY, 	"EXTENT_DATA_REF" },	\
+		{ BTRFS_EXTENT_REF_V0_KEY, 	"EXTENT_REF_V0" },	\
+		{ BTRFS_SHARED_BLOCK_REF_KEY, 	"SHARED_BLOCK_REF" },	\
+		{ BTRFS_SHARED_DATA_REF_KEY, 	"SHARED_DATA_REF" })
+
+#define __show_root_type(obj)						\
+	__print_symbolic(obj,						\
+		{ BTRFS_ROOT_TREE_OBJECTID, 	"ROOT_TREE"	},	\
+		{ BTRFS_EXTENT_TREE_OBJECTID, 	"EXTENT_TREE"	},	\
+		{ BTRFS_CHUNK_TREE_OBJECTID, 	"CHUNK_TREE"	},	\
+		{ BTRFS_DEV_TREE_OBJECTID, 	"DEV_TREE"	},	\
+		{ BTRFS_FS_TREE_OBJECTID, 	"FS_TREE"	},	\
+		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
+		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
+		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
+		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
+		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
+
+#define show_root_type(obj)						\
+	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
+	      (obj <= BTRFS_CSUM_TREE_OBJECTID )) ? __show_root_type(obj) : "-"
+
+TRACE_EVENT(btrfs_transaction_commit,
+
+	TP_PROTO(struct btrfs_root *root),
+
+	TP_ARGS(root),
+
+	TP_STRUCT__entry(
+		__field(	u64,  generation		)
+		__field(	u64,  root_objectid		)
+	),
+
+	TP_fast_assign(
+		__entry->generation	= root->fs_info->generation;
+		__entry->root_objectid	= root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), gen = %llu",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->generation)
+);
+
+DECLARE_EVENT_CLASS(btrfs__inode,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,  ino			)
+		__field(	blkcnt_t,  blocks		)
+		__field(	u64,  disk_i_size		)
+		__field(	u64,  generation		)
+		__field(	u64,  last_trans		)
+		__field(	u64,  logged_trans		)
+		__field(	u64,  root_objectid		)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= inode->i_ino;
+		__entry->blocks	= inode->i_blocks;
+		__entry->disk_i_size  = BTRFS_I(inode)->disk_i_size;
+		__entry->generation = BTRFS_I(inode)->generation;
+		__entry->last_trans = BTRFS_I(inode)->last_trans;
+		__entry->logged_trans = BTRFS_I(inode)->logged_trans;
+		__entry->root_objectid =
+				BTRFS_I(inode)->root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), gen = %llu, ino = %lu, blocks = %llu, "
+		  "disk_i_size = %llu, last_trans = %llu, logged_trans = %llu",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->generation,
+		  (unsigned long)__entry->ino,
+		  (unsigned long long)__entry->blocks,
+		  (unsigned long long)__entry->disk_i_size,
+		  (unsigned long long)__entry->last_trans,
+		  (unsigned long long)__entry->logged_trans)
+);
+
+DEFINE_EVENT(btrfs__inode, btrfs_inode_new,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(btrfs__inode, btrfs_inode_request,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+#define __show_map_type(type)						\
+	__print_symbolic(type,						\
+		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
+		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
+		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
+		{ EXTENT_MAP_DELALLOC,	"DELALLOC" 	})
+
+#define show_map_type(type)			\
+	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" :  __show_map_type(type)
+
+#define show_map_flags(flag)						\
+	__print_flags(flag, "|",					\
+		{ EXTENT_FLAG_PINNED, 		"PINNED" 	},	\
+		{ EXTENT_FLAG_COMPRESSED, 	"COMPRESSED" 	},	\
+		{ EXTENT_FLAG_VACANCY, 		"VACANCY" 	},	\
+		{ EXTENT_FLAG_PREALLOC, 	"PREALLOC" 	})
+
+TRACE_EVENT(btrfs_get_extent,
+
+	TP_PROTO(struct btrfs_root *root, struct extent_map *map),
+
+	TP_ARGS(root, map),
+
+	TP_STRUCT__entry(
+		__field(	u64,  root_objectid	)
+		__field(	u64,  start		)
+		__field(	u64,  len		)
+		__field(	u64,  orig_start	)
+		__field(	u64,  block_start	)
+		__field(	u64,  block_len		)
+		__field(	unsigned long,  flags	)
+		__field(	int,  refs		)
+		__field(	unsigned int,  compress_type	)
+	),
+
+	TP_fast_assign(
+		__entry->root_objectid	= root->root_key.objectid;
+		__entry->start 		= map->start;
+		__entry->len		= map->len;
+		__entry->orig_start	= map->orig_start;
+		__entry->block_start	= map->block_start;
+		__entry->block_len	= map->block_len;
+		__entry->flags		= map->flags;
+		__entry->refs		= atomic_read(&map->refs);
+		__entry->compress_type	= map->compress_type;
+	),
+
+	TP_printk("root = %llu(%s), start = %llu, len = %llu, "
+		  "orig_start = %llu, block_start = %llu(%s), "
+		  "block_len = %llu, flags = %s, refs = %u, "
+		  "compress_type = %u",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->len,
+		  (unsigned long long)__entry->orig_start,
+		  show_map_type(__entry->block_start),
+		  (unsigned long long)__entry->block_len,
+		  show_map_flags(__entry->flags),
+		  __entry->refs, __entry->compress_type)
+);
+
+#define show_ordered_flags(flags)					\
+	__print_symbolic(flags,					\
+		{ BTRFS_ORDERED_IO_DONE, 	"IO_DONE" 	},	\
+		{ BTRFS_ORDERED_COMPLETE, 	"COMPLETE" 	},	\
+		{ BTRFS_ORDERED_NOCOW, 		"NOCOW" 	},	\
+		{ BTRFS_ORDERED_COMPRESSED, 	"COMPRESSED" 	},	\
+		{ BTRFS_ORDERED_PREALLOC, 	"PREALLOC" 	},	\
+		{ BTRFS_ORDERED_DIRECT, 	"DIRECT" 	})
+
+DECLARE_EVENT_CLASS(btrfs__ordered_extent,
+
+	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
+
+	TP_ARGS(inode, ordered),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,  ino		)
+		__field(	u64,  file_offset	)
+		__field(	u64,  start		)
+		__field(	u64,  len		)
+		__field(	u64,  disk_len		)
+		__field(	u64,  bytes_left	)
+		__field(	unsigned long,  flags	)
+		__field(	int,  compress_type	)
+		__field(	int,  refs		)
+		__field(	u64,  root_objectid	)
+	),
+
+	TP_fast_assign(
+		__entry->ino 		= inode->i_ino;
+		__entry->file_offset	= ordered->file_offset;
+		__entry->start		= ordered->start;
+		__entry->len		= ordered->len;
+		__entry->disk_len	= ordered->disk_len;
+		__entry->bytes_left	= ordered->bytes_left;
+		__entry->flags		= ordered->flags;
+		__entry->compress_type	= ordered->compress_type;
+		__entry->refs		= atomic_read(&ordered->refs);
+		__entry->root_objectid	=
+				BTRFS_I(inode)->root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), ino = %llu, file_offset = %llu, "
+		  "start = %llu, len = %llu, disk_len = %llu, "
+		  "bytes_left = %llu, flags = %s, compress_type = %d, "
+		  "refs = %d",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->ino,
+		  (unsigned long long)__entry->file_offset,
+		  (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->len,
+		  (unsigned long long)__entry->disk_len,
+		  (unsigned long long)__entry->bytes_left,
+		  show_ordered_flags(__entry->flags),
+		  __entry->compress_type, __entry->refs)
+);
+
+DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_add,
+
+	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
+
+	TP_ARGS(inode, ordered)
+);
+
+DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_remove,
+
+	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
+
+	TP_ARGS(inode, ordered)
+);
+
+DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_start,
+
+	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
+
+	TP_ARGS(inode, ordered)
+);
+
+DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_put,
+
+	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
+
+	TP_ARGS(inode, ordered)
+);
+
+DECLARE_EVENT_CLASS(btrfs__writepage,
+
+	TP_PROTO(struct page *page, struct inode *inode,
+		 struct writeback_control *wbc),
+
+	TP_ARGS(page, inode, wbc),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,  ino			)
+		__field(	pgoff_t,  index			)
+		__field(	long,   nr_to_write		)
+		__field(	long,   pages_skipped		)
+		__field(	loff_t, range_start		)
+		__field(	loff_t, range_end		)
+		__field(	char,   nonblocking		)
+		__field(	char,   for_kupdate		)
+		__field(	char,   for_reclaim		)
+		__field(	char,   range_cyclic		)
+		__field(	pgoff_t,  writeback_index	)
+		__field(	u64,    root_objectid		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= inode->i_ino;
+		__entry->index		= page->index;
+		__entry->nr_to_write	= wbc->nr_to_write;
+		__entry->pages_skipped	= wbc->pages_skipped;
+		__entry->range_start	= wbc->range_start;
+		__entry->range_end	= wbc->range_end;
+		__entry->nonblocking	= wbc->nonblocking;
+		__entry->for_kupdate	= wbc->for_kupdate;
+		__entry->for_reclaim	= wbc->for_reclaim;
+		__entry->range_cyclic	= wbc->range_cyclic;
+		__entry->writeback_index = inode->i_mapping->writeback_index;
+		__entry->root_objectid	=
+				 BTRFS_I(inode)->root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), ino = %lu, page_index = %lu, "
+		  "nr_to_write = %ld, pages_skipped = %ld, range_start = %llu, "
+		  "range_end = %llu, nonblocking = %d, for_kupdate = %d, "
+		  "for_reclaim = %d, range_cyclic = %d, writeback_index = %lu",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long)__entry->ino, __entry->index,
+		  __entry->nr_to_write, __entry->pages_skipped,
+		  __entry->range_start, __entry->range_end,
+		  __entry->nonblocking, __entry->for_kupdate,
+		  __entry->for_reclaim, __entry->range_cyclic,
+		  (unsigned long)__entry->writeback_index)
+);
+
+DEFINE_EVENT(btrfs__writepage, __extent_writepage,
+
+	TP_PROTO(struct page *page, struct inode *inode,
+		 struct writeback_control *wbc),
+
+	TP_ARGS(page, inode, wbc)
+);
+
+TRACE_EVENT(btrfs_writepage_end_io_hook,
+
+	TP_PROTO(struct page *page, u64 start, u64 end, int uptodate),
+
+	TP_ARGS(page, start, end, uptodate),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	 ino		)
+		__field(	pgoff_t, index		)
+		__field(	u64,	 start		)
+		__field(	u64,	 end		)
+		__field(	int,	 uptodate	)
+		__field(	u64,    root_objectid	)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->index	= page->index;
+		__entry->start	= start;
+		__entry->end	= end;
+		__entry->uptodate = uptodate;
+		__entry->root_objectid	=
+			 BTRFS_I(page->mapping->host)->root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), ino = %lu, page_index = %lu, start = %llu, "
+		  "end = %llu, uptodate = %d",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long)__entry->ino, (unsigned long)__entry->index,
+		  (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->end, __entry->uptodate)
+);
+
+TRACE_EVENT(btrfs_sync_file,
+
+	TP_PROTO(struct file *file, int datasync),
+
+	TP_ARGS(file, datasync),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,  ino		)
+		__field(	ino_t,  parent		)
+		__field(	int,    datasync	)
+		__field(	u64,    root_objectid	)
+	),
+
+	TP_fast_assign(
+		struct dentry *dentry = file->f_path.dentry;
+		struct inode *inode = dentry->d_inode;
+
+		__entry->ino		= inode->i_ino;
+		__entry->parent		= dentry->d_parent->d_inode->i_ino;
+		__entry->datasync	= datasync;
+		__entry->root_objectid	=
+				 BTRFS_I(inode)->root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), ino = %ld, parent = %ld, datasync = %d",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long)__entry->ino, (unsigned long)__entry->parent,
+		  __entry->datasync)
+);
+
+TRACE_EVENT(btrfs_sync_fs,
+
+	TP_PROTO(int wait),
+
+	TP_ARGS(wait),
+
+	TP_STRUCT__entry(
+		__field(	int,  wait		)
+	),
+
+	TP_fast_assign(
+		__entry->wait	= wait;
+	),
+
+	TP_printk("wait = %d", __entry->wait)
+);
+
+#define show_ref_action(action)						\
+	__print_symbolic(action,					\
+		{ BTRFS_ADD_DELAYED_REF,    "ADD_DELAYED_REF" },	\
+		{ BTRFS_DROP_DELAYED_REF,   "DROP_DELAYED_REF" },	\
+		{ BTRFS_ADD_DELAYED_EXTENT, "ADD_DELAYED_EXTENT" }, 	\
+		{ BTRFS_UPDATE_DELAYED_HEAD, "UPDATE_DELAYED_HEAD" })
+			
+
+TRACE_EVENT(btrfs_delayed_tree_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_tree_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action),
+
+	TP_STRUCT__entry(
+		__field(	u64,  bytenr		)
+		__field(	u64,  num_bytes		)
+		__field(	int,  action		) 
+		__field(	u64,  parent		)
+		__field(	u64,  ref_root		)
+		__field(	int,  level		)
+		__field(	int,  type		)
+	),
+
+	TP_fast_assign(
+		__entry->bytenr		= ref->bytenr;
+		__entry->num_bytes	= ref->num_bytes;
+		__entry->action		= action;
+		__entry->parent		= full_ref->parent;
+		__entry->ref_root	= full_ref->root;
+		__entry->level		= full_ref->level;
+		__entry->type		= ref->type;
+	),
+
+	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
+		  "parent = %llu(%s), ref_root = %llu(%s), level = %d, "
+		  "type = %s",
+		  (unsigned long long)__entry->bytenr,
+		  (unsigned long long)__entry->num_bytes,
+		  show_ref_action(__entry->action),
+		  show_root_type(__entry->parent),
+		  show_root_type(__entry->ref_root),
+		  __entry->level, show_ref_type(__entry->type))
+);
+
+TRACE_EVENT(btrfs_delayed_data_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_data_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action),
+
+	TP_STRUCT__entry(
+		__field(	u64,  bytenr		)
+		__field(	u64,  num_bytes		)
+		__field(	int,  action		) 
+		__field(	u64,  parent		)
+		__field(	u64,  ref_root		)
+		__field(	u64,  owner		)
+		__field(	u64,  offset		)
+		__field(	int,  type		)
+	),
+
+	TP_fast_assign(
+		__entry->bytenr		= ref->bytenr;
+		__entry->num_bytes	= ref->num_bytes;
+		__entry->action		= action;
+		__entry->parent		= full_ref->parent;
+		__entry->ref_root	= full_ref->root;
+		__entry->owner		= full_ref->objectid;
+		__entry->offset		= full_ref->offset;
+		__entry->type		= ref->type;
+	),
+
+	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
+		  "parent = %llu(%s), ref_root = %llu(%s), owner = %llu, "
+		  "offset = %llu, type = %s",
+		  (unsigned long long)__entry->bytenr,
+		  (unsigned long long)__entry->num_bytes,
+		  show_ref_action(__entry->action),
+		  show_root_type(__entry->parent),
+		  show_root_type(__entry->ref_root),
+		  (unsigned long long)__entry->owner,
+		  (unsigned long long)__entry->offset,
+		  show_ref_type(__entry->type))
+);
+
+TRACE_EVENT(btrfs_delayed_ref_head,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_ref_head *head_ref,
+		 int action),
+
+	TP_ARGS(ref, head_ref, action),
+
+	TP_STRUCT__entry(
+		__field(	u64,  bytenr		)
+		__field(	u64,  num_bytes		)
+		__field(	int,  action		) 
+		__field(	int,  is_data		)
+	),
+
+	TP_fast_assign(
+		__entry->bytenr		= ref->bytenr;
+		__entry->num_bytes	= ref->num_bytes;
+		__entry->action		= action;
+		__entry->is_data	= head_ref->is_data;
+	),
+
+	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, is_data = %d",
+		  (unsigned long long)__entry->bytenr,
+		  (unsigned long long)__entry->num_bytes,
+		  show_ref_action(__entry->action),
+		  __entry->is_data)
+);
+
+#define show_chunk_type(type)					\
+	__print_flags(type, "|",				\
+		{ BTRFS_BLOCK_GROUP_DATA, 	"DATA"	},	\
+		{ BTRFS_BLOCK_GROUP_SYSTEM, 	"SYSTEM"},	\
+		{ BTRFS_BLOCK_GROUP_METADATA, 	"METADATA"},	\
+		{ BTRFS_BLOCK_GROUP_RAID0, 	"RAID0" },	\
+		{ BTRFS_BLOCK_GROUP_RAID1, 	"RAID1" },	\
+		{ BTRFS_BLOCK_GROUP_DUP, 	"DUP"	},	\
+		{ BTRFS_BLOCK_GROUP_RAID10, 	"RAID10"})
+
+DECLARE_EVENT_CLASS(btrfs__chunk,
+
+	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+		 u64 offset, u64 size),
+
+	TP_ARGS(root, map, offset, size),
+
+	TP_STRUCT__entry(
+		__field(	int,  num_stripes		)
+		__field(	u64,  type			)
+		__field(	int,  sub_stripes		)
+		__field(	u64,  offset			)
+		__field(	u64,  size			)
+		__field(	u64,  root_objectid		)
+	),
+
+	TP_fast_assign(
+		__entry->num_stripes	= map->num_stripes;
+		__entry->type		= map->type;
+		__entry->sub_stripes	= map->sub_stripes;
+		__entry->offset		= offset;
+		__entry->size		= size;
+		__entry->root_objectid	= root->root_key.objectid;
+	),
+
+	TP_printk("root = %llu(%s), offset = %llu, size = %llu, "
+		  "num_stripes = %d, sub_stripes = %d, type = %s",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->offset,
+		  (unsigned long long)__entry->size,
+		  __entry->num_stripes, __entry->sub_stripes,
+		  show_chunk_type(__entry->type))
+);
+
+DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_alloc,
+
+	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+		 u64 offset, u64 size),
+
+	TP_ARGS(root, map, offset, size)
+);
+
+DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_free,
+
+	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+		 u64 offset, u64 size),
+
+	TP_ARGS(root, map, offset, size)
+);
+
+TRACE_EVENT(btrfs_cow_block,
+
+	TP_PROTO(struct btrfs_root *root, struct extent_buffer *buf,
+		 struct extent_buffer *cow),
+
+	TP_ARGS(root, buf, cow),
+
+	TP_STRUCT__entry(
+		__field(	u64,  root_objectid		)
+		__field(	u64,  buf_start			)
+		__field(	int,  refs			)
+		__field(	u64,  cow_start			)
+		__field(	int,  buf_level			)
+		__field(	int,  cow_level			)
+	),
+
+	TP_fast_assign(
+		__entry->root_objectid	= root->root_key.objectid;
+		__entry->buf_start	= buf->start;
+		__entry->refs		= atomic_read(&buf->refs);
+		__entry->cow_start	= cow->start;
+		__entry->buf_level	= btrfs_header_level(buf);
+		__entry->cow_level	= btrfs_header_level(cow);
+	),
+
+	TP_printk("root = %llu(%s), refs = %d, orig_buf = %llu "
+		  "(orig_level = %d), cow_buf = %llu (cow_level = %d)",
+		  show_root_type(__entry->root_objectid),
+		  __entry->refs,
+		  (unsigned long long)__entry->buf_start,
+		  __entry->buf_level,
+		  (unsigned long long)__entry->cow_start,
+		  __entry->cow_level)
+);
+
+DECLARE_EVENT_CLASS(btrfs__reserved_extent,
+
+	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+
+	TP_ARGS(root, start, len),
+
+	TP_STRUCT__entry(
+		__field(	u64,  root_objectid		)
+		__field(	u64,  start			)
+		__field(	u64,  len			)
+	),
+
+	TP_fast_assign(
+		__entry->root_objectid	= root->root_key.objectid;
+		__entry->start		= start;
+		__entry->len		= len;
+	),
+
+	TP_printk("root = %llu(%s), start = %llu, len = %llu",
+		  show_root_type(__entry->root_objectid),
+		  (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->len)
+);
+
+DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_alloc,
+
+	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+
+	TP_ARGS(root, start, len)
+);
+
+DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
+
+	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+
+	TP_ARGS(root, start, len)
+);
+
+#endif /* _TRACE_BTRFS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.5.2
