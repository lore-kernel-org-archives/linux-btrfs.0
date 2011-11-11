From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add allocator tracepoints
Date: Fri, 11 Nov 2011 15:17:08 -0500
Message-ID: <1321042628-8581-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I used these tracepoints when figuring out what the cluster stuff was doing, so
add them to mainline in case we need to profile this stuff again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c       |    9 ++
 fs/btrfs/free-space-cache.c  |   11 +++-
 include/trace/events/btrfs.h |  173 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0f47b3e..fa4f602 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5073,6 +5073,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
+	trace_find_free_extent(orig_root, num_bytes, empty_size, data);
+
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
 		printk(KERN_ERR "No space info for %llu\n", data);
@@ -5258,6 +5260,8 @@ have_block_group:
 			if (offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
+				trace_btrfs_reserve_extent_cluster(root,
+					block_group, search_start, num_bytes);
 				goto checks;
 			}
 
@@ -5315,6 +5319,9 @@ refill_cluster:
 				if (offset) {
 					/* we found one, proceed */
 					spin_unlock(&last_ptr->refill_lock);
+					trace_btrfs_reserve_extent_cluster(root,
+						block_group, search_start,
+						num_bytes);
 					goto checks;
 				}
 			} else if (!cached && loop > LOOP_CACHING_NOWAIT
@@ -5394,6 +5401,8 @@ checks:
 		ins->objectid = search_start;
 		ins->offset = num_bytes;
 
+		trace_btrfs_reserve_extent(orig_root, block_group,
+					   search_start, num_bytes);
 		if (offset < search_start)
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 181760f..b3008d3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2333,6 +2333,8 @@ again:
 				 &entry->offset_index, 1);
 	BUG_ON(ret);
 
+	trace_btrfs_setup_cluster(block_group, cluster,
+				  total_found * block_group->sectorsize, 1);
 	return 0;
 }
 
@@ -2355,6 +2357,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	u64 window_free;
 	u64 max_extent;
 	u64 max_gap = 128 * 1024;
+	u64 total_size = 0;
 
 	entry = tree_search_offset(ctl, offset, 0, 1);
 	if (!entry)
@@ -2431,11 +2434,12 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		rb_erase(&entry->offset_index, &ctl->free_space_offset);
 		ret = tree_insert_offset(&cluster->root, entry->offset,
 					 &entry->offset_index, 0);
+		total_size += entry->bytes;
 		BUG_ON(ret);
 	} while (node && entry != last);
 
 	cluster->max_size = max_extent;
-
+	trace_btrfs_setup_cluster(block_group, cluster, total_size, 0);
 	return 0;
 }
 
@@ -2560,6 +2564,9 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	trace_btrfs_find_cluster(block_group, offset, bytes, empty_size,
+				 min_bytes);
+
 	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
 				      bytes, min_bytes);
@@ -2576,6 +2583,8 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		list_add_tail(&cluster->block_group_list,
 			      &block_group->cluster_list);
 		cluster->block_group = block_group;
+	} else {
+		trace_btrfs_failed_cluster_setup(block_group);
 	}
 out:
 	spin_unlock(&cluster->lock);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b31702a..1750c0e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -16,6 +16,8 @@ struct btrfs_delayed_ref_node;
 struct btrfs_delayed_tree_ref;
 struct btrfs_delayed_data_ref;
 struct btrfs_delayed_ref_head;
+struct btrfs_block_group_cache;
+struct btrfs_free_cluster;
 struct map_lookup;
 struct extent_buffer;
 
@@ -44,6 +46,15 @@ struct extent_buffer;
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj <= BTRFS_CSUM_TREE_OBJECTID )) ? __show_root_type(obj) : "-"
 
+#define BTRFS_GROUP_FLAGS	\
+	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"}, \
+	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"}, \
+	{ BTRFS_BLOCK_GROUP_METADATA,	"METADATA"}, \
+	{ BTRFS_BLOCK_GROUP_RAID0,	"RAID0"}, \
+	{ BTRFS_BLOCK_GROUP_RAID1,	"RAID1"}, \
+	{ BTRFS_BLOCK_GROUP_DUP,	"DUP"}, \
+	{ BTRFS_BLOCK_GROUP_RAID10,	"RAID10"}
+
 TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_PROTO(struct btrfs_root *root),
@@ -659,6 +670,168 @@ DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 	TP_ARGS(root, start, len)
 );
 
+TRACE_EVENT(find_free_extent,
+
+	TP_PROTO(struct btrfs_root *root, u64 num_bytes, u64 empty_size,
+		 u64 data),
+
+	TP_ARGS(root, num_bytes, empty_size, data),
+
+	TP_STRUCT__entry(
+		__field(	u64,	root_objectid		)
+		__field(	u64,	num_bytes		)
+		__field(	u64,	empty_size		)
+		__field(	u64,	data			)
+	),
+
+	TP_fast_assign(
+		__entry->root_objectid	= root->root_key.objectid;
+		__entry->num_bytes	= num_bytes;
+		__entry->empty_size	= empty_size;
+		__entry->data		= data;
+	),
+
+	TP_printk("root = %Lu(%s), len = %Lu, empty_size = %Lu, "
+		  "flags = %Lu(%s)", show_root_type(__entry->root_objectid),
+		  __entry->num_bytes, __entry->empty_size, __entry->data,
+		  __print_flags((unsigned long)__entry->data, "|",
+				 BTRFS_GROUP_FLAGS))
+);
+
+DECLARE_EVENT_CLASS(btrfs__reserve_extent,
+
+	TP_PROTO(struct btrfs_root *root,
+		 struct btrfs_block_group_cache *block_group, u64 start,
+		 u64 len),
+
+	TP_ARGS(root, block_group, start, len),
+
+	TP_STRUCT__entry(
+		__field(	u64,	root_objectid		)
+		__field(	u64,	bg_objectid		)
+		__field(	u64,	flags			)
+		__field(	u64,	start			)
+		__field(	u64,	len			)
+	),
+
+	TP_fast_assign(
+		__entry->root_objectid	= root->root_key.objectid;
+		__entry->bg_objectid	= block_group->key.objectid;
+		__entry->flags		= block_group->flags;
+		__entry->start		= start;
+		__entry->len		= len;
+	),
+
+	TP_printk("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
+		  "start = %Lu, len = %Lu",
+		  show_root_type(__entry->root_objectid), __entry->bg_objectid,
+		  __entry->flags, __print_flags((unsigned long)__entry->flags,
+						"|", BTRFS_GROUP_FLAGS),
+		  __entry->start, __entry->len)
+);
+
+DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent,
+
+	TP_PROTO(struct btrfs_root *root,
+		 struct btrfs_block_group_cache *block_group, u64 start,
+		 u64 len),
+
+	TP_ARGS(root, block_group, start, len)
+);
+
+DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent_cluster,
+
+	TP_PROTO(struct btrfs_root *root,
+		 struct btrfs_block_group_cache *block_group, u64 start,
+		 u64 len),
+
+	TP_ARGS(root, block_group, start, len)
+);
+
+TRACE_EVENT(btrfs_find_cluster,
+
+	TP_PROTO(struct btrfs_block_group_cache *block_group, u64 start,
+		 u64 bytes, u64 empty_size, u64 min_bytes),
+
+	TP_ARGS(block_group, start, bytes, empty_size, min_bytes),
+
+	TP_STRUCT__entry(
+		__field(	u64,	bg_objectid		)
+		__field(	u64,	flags			)
+		__field(	u64,	start			)
+		__field(	u64,	bytes			)
+		__field(	u64,	empty_size		)
+		__field(	u64,	min_bytes		)
+	),
+
+	TP_fast_assign(
+		__entry->bg_objectid	= block_group->key.objectid;
+		__entry->flags		= block_group->flags;
+		__entry->start		= start;
+		__entry->bytes		= bytes;
+		__entry->empty_size	= empty_size;
+		__entry->min_bytes	= min_bytes;
+	),
+
+	TP_printk("block_group = %Lu, flags = %Lu(%s), start = %Lu, len = %Lu,"
+		  " empty_size = %Lu, min_bytes = %Lu", __entry->bg_objectid,
+		  __entry->flags,
+		  __print_flags((unsigned long)__entry->flags, "|",
+				BTRFS_GROUP_FLAGS), __entry->start,
+		  __entry->bytes, __entry->empty_size,  __entry->min_bytes)
+);
+
+TRACE_EVENT(btrfs_failed_cluster_setup,
+
+	TP_PROTO(struct btrfs_block_group_cache *block_group),
+
+	TP_ARGS(block_group),
+
+	TP_STRUCT__entry(
+		__field(	u64,	bg_objectid		)
+	),
+
+	TP_fast_assign(
+		__entry->bg_objectid	= block_group->key.objectid;
+	),
+
+	TP_printk("block_group = %Lu", __entry->bg_objectid)
+);
+
+TRACE_EVENT(btrfs_setup_cluster,
+
+	TP_PROTO(struct btrfs_block_group_cache *block_group,
+		 struct btrfs_free_cluster *cluster, u64 size, int bitmap),
+
+	TP_ARGS(block_group, cluster, size, bitmap),
+
+	TP_STRUCT__entry(
+		__field(	u64,	bg_objectid		)
+		__field(	u64,	flags			)
+		__field(	u64,	start			)
+		__field(	u64,	max_size		)
+		__field(	u64,	size			)
+		__field(	int,	bitmap			)
+	),
+
+	TP_fast_assign(
+		__entry->bg_objectid	= block_group->key.objectid;
+		__entry->flags		= block_group->flags;
+		__entry->start		= cluster->window_start;
+		__entry->max_size	= cluster->max_size;
+		__entry->size		= size;
+		__entry->bitmap		= bitmap;
+	),
+
+	TP_printk("block_group = %Lu, flags = %Lu(%s), window_start = %Lu, "
+		  "size = %Lu, max_size = %Lu, bitmap = %d",
+		  __entry->bg_objectid,
+		  __entry->flags,
+		  __print_flags((unsigned long)__entry->flags, "|",
+				BTRFS_GROUP_FLAGS), __entry->start,
+		  __entry->size, __entry->max_size, __entry->bitmap)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
1.7.5.2

