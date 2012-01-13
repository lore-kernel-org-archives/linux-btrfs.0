From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: space leak tracepoints
Date: Fri, 13 Jan 2012 14:45:20 -0500
Message-ID: <1326483920-5115-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This in addition to a script in my btrfs-tracing tree will help track down space
leaks when we're getting space left over in block groups on umount.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/delayed-inode.c     |   45 ++++++++++++++++++++++++--------
 fs/btrfs/extent-tree.c       |   58 ++++++++++++++++++++++++++++++++++++------
 fs/btrfs/inode-map.c         |    4 +++
 fs/btrfs/transaction.c       |    2 +
 include/trace/events/btrfs.h |   30 +++++++++++++++++++++
 5 files changed, 119 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 9c1eccc..fe4cd0f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -595,8 +595,12 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-	if (!ret)
+	if (!ret) {
+		trace_btrfs_space_reservation(root->fs_info, "delayed_item",
+					      item->key.objectid,
+					      num_bytes, 1);
 		item->bytes_reserved = num_bytes;
+	}
 
 	return ret;
 }
@@ -610,6 +614,9 @@ static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 		return;
 
 	rsv = &root->fs_info->delayed_block_rsv;
+	trace_btrfs_space_reservation(root->fs_info, "delayed_item",
+				      item->key.objectid, item->bytes_reserved,
+				      0);
 	btrfs_block_rsv_release(root, rsv,
 				item->bytes_reserved);
 }
@@ -624,7 +631,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 	struct btrfs_block_rsv *dst_rsv;
 	u64 num_bytes;
 	int ret;
-	int release = false;
+	bool release = false;
 
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
@@ -651,8 +658,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 		 */
 		if (ret == -EAGAIN)
 			ret = -ENOSPC;
-		if (!ret)
+		if (!ret) {
 			node->bytes_reserved = num_bytes;
+			trace_btrfs_space_reservation(root->fs_info,
+						      "delayed_inode",
+						      btrfs_ino(inode),
+						      num_bytes, 1);
+		}
 		return ret;
 	} else if (src_rsv == &root->fs_info->delalloc_block_rsv) {
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -707,11 +719,17 @@ out:
 	 * reservation here.  I think it may be time for a documentation page on
 	 * how block rsvs. work.
 	 */
-	if (!ret)
+	if (!ret) {
+		trace_btrfs_space_reservation(root->fs_info, "delayed_inode",
+					      btrfs_ino(inode), num_bytes, 1);
 		node->bytes_reserved = num_bytes;
+	}
 
-	if (release)
+	if (release) {
+		trace_btrfs_space_reservation(root->fs_info, "delalloc",
+					      btrfs_ino(inode), num_bytes, 0);
 		btrfs_block_rsv_release(root, src_rsv, num_bytes);
+	}
 
 	return ret;
 }
@@ -725,6 +743,8 @@ static void btrfs_delayed_inode_release_metadata(struct btrfs_root *root,
 		return;
 
 	rsv = &root->fs_info->delayed_block_rsv;
+	trace_btrfs_space_reservation(root->fs_info, "delayed_inode",
+				      node->inode_id, node->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, rsv,
 				node->bytes_reserved);
 	node->bytes_reserved = 0;
@@ -1372,13 +1392,6 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	ret = btrfs_delayed_item_reserve_metadata(trans, root, delayed_item);
-	/*
-	 * we have reserved enough space when we start a new transaction,
-	 * so reserving metadata failure is impossible
-	 */
-	BUG_ON(ret);
-
 	delayed_item->key.objectid = btrfs_ino(dir);
 	btrfs_set_key_type(&delayed_item->key, BTRFS_DIR_INDEX_KEY);
 	delayed_item->key.offset = index;
@@ -1391,6 +1404,14 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	dir_item->type = type;
 	memcpy((char *)(dir_item + 1), name, name_len);
 
+	ret = btrfs_delayed_item_reserve_metadata(trans, root, delayed_item);
+	/*
+	 * we have reserved enough space when we start a new transaction,
+	 * so reserving metadata failure is impossible
+	 */
+	BUG_ON(ret);
+
+
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 82dde5b..d6e4b92 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3191,6 +3191,8 @@ commit_trans:
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
+	trace_btrfs_space_reservation(root->fs_info, "space_info",
+				      (u64)data_sinfo, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
 
 	return 0;
@@ -3210,6 +3212,8 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	data_sinfo = BTRFS_I(inode)->space_info;
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
+	trace_btrfs_space_reservation(root->fs_info, "space_info",
+				      (u64)data_sinfo, bytes, 0);
 	spin_unlock(&data_sinfo->lock);
 }
 
@@ -3582,6 +3586,10 @@ again:
 	if (used <= space_info->total_bytes) {
 		if (used + orig_bytes <= space_info->total_bytes) {
 			space_info->bytes_may_use += orig_bytes;
+			trace_btrfs_space_reservation(root->fs_info,
+						      "space_info",
+						      (u64)space_info,
+						      orig_bytes, 1);
 			ret = 0;
 		} else {
 			/*
@@ -3649,6 +3657,10 @@ again:
 
 		if (used + num_bytes < space_info->total_bytes + avail) {
 			space_info->bytes_may_use += orig_bytes;
+			trace_btrfs_space_reservation(root->fs_info,
+						      "space_info",
+						      (u64)space_info,
+						      orig_bytes, 1);
 			ret = 0;
 		} else {
 			wait_ordered = true;
@@ -3755,7 +3767,8 @@ static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_unlock(&block_rsv->lock);
 }
 
-static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
+static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_rsv *block_rsv,
 				    struct btrfs_block_rsv *dest, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
@@ -3791,6 +3804,9 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 		if (num_bytes) {
 			spin_lock(&space_info->lock);
 			space_info->bytes_may_use -= num_bytes;
+			trace_btrfs_space_reservation(fs_info, "space_info",
+						      (u64)space_info,
+						      num_bytes, 0);
 			space_info->reservation_progress++;
 			spin_unlock(&space_info->lock);
 		}
@@ -3947,7 +3963,8 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 	if (global_rsv->full || global_rsv == block_rsv ||
 	    block_rsv->space_info != global_rsv->space_info)
 		global_rsv = NULL;
-	block_rsv_release_bytes(block_rsv, global_rsv, num_bytes);
+	block_rsv_release_bytes(root->fs_info, block_rsv, global_rsv,
+				num_bytes);
 }
 
 /*
@@ -4006,11 +4023,15 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		num_bytes = sinfo->total_bytes - num_bytes;
 		block_rsv->reserved += num_bytes;
 		sinfo->bytes_may_use += num_bytes;
+		trace_btrfs_space_reservation(fs_info, "space_info",
+					      (u64)sinfo, num_bytes, 1);
 	}
 
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
 		sinfo->bytes_may_use -= num_bytes;
+		trace_btrfs_space_reservation(fs_info, "space_info",
+					      (u64)sinfo, num_bytes, 0);
 		sinfo->reservation_progress++;
 		block_rsv->reserved = block_rsv->size;
 		block_rsv->full = 1;
@@ -4045,7 +4066,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 
 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
-	block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);
+	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
+				(u64)-1);
 	WARN_ON(fs_info->delalloc_block_rsv.size > 0);
 	WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
 	WARN_ON(fs_info->trans_block_rsv.size > 0);
@@ -4062,6 +4084,8 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 	if (!trans->bytes_reserved)
 		return;
 
+	trace_btrfs_space_reservation(root->fs_info, "transaction", (u64)trans,
+				      trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
 	trans->bytes_reserved = 0;
 }
@@ -4079,6 +4103,8 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * when we are truly done with the orphan item.
 	 */
 	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	trace_btrfs_space_reservation(root->fs_info, "orphan",
+				      btrfs_ino(inode), num_bytes, 1);
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
@@ -4086,6 +4112,8 @@ void btrfs_orphan_release_metadata(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	trace_btrfs_space_reservation(root->fs_info, "orphan",
+				      btrfs_ino(inode), num_bytes, 0);
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
 }
 
@@ -4266,8 +4294,13 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		if (dropped)
 			to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
-		if (to_free)
+		if (to_free) {
 			btrfs_block_rsv_release(root, block_rsv, to_free);
+			trace_btrfs_space_reservation(root->fs_info,
+						      "delalloc",
+						      btrfs_ino(inode),
+						      to_free, 0);
+		}
 		return ret;
 	}
 
@@ -4279,6 +4312,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	BTRFS_I(inode)->reserved_extents += nr_extents;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
+	if (to_reserve)
+		trace_btrfs_space_reservation(root->fs_info,"delalloc",
+					      btrfs_ino(inode), to_reserve, 1);
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
 	return 0;
@@ -4308,6 +4344,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
+	trace_btrfs_space_reservation(root->fs_info, "delalloc",
+				      btrfs_ino(inode), to_free, 0);
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
 }
@@ -4562,7 +4600,10 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 			cache->reserved += num_bytes;
 			space_info->bytes_reserved += num_bytes;
 			if (reserve == RESERVE_ALLOC) {
-				BUG_ON(space_info->bytes_may_use < num_bytes);
+				trace_btrfs_space_reservation(cache->fs_info,
+							      "space_info",
+							      (u64)space_info,
+							      num_bytes, 0);
 				space_info->bytes_may_use -= num_bytes;
 			}
 		}
@@ -6006,10 +6047,11 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	return ERR_PTR(-ENOSPC);
 }
 
-static void unuse_block_rsv(struct btrfs_block_rsv *block_rsv, u32 blocksize)
+static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
+			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
 {
 	block_rsv_add_bytes(block_rsv, blocksize, 0);
-	block_rsv_release_bytes(block_rsv, NULL, 0);
+	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
 }
 
 /*
@@ -6039,7 +6081,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
 				   empty_size, hint, (u64)-1, &ins, 0);
 	if (ret) {
-		unuse_block_rsv(block_rsv, blocksize);
+		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
 		return ERR_PTR(ret);
 	}
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index f8962a9..213ffa8 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -438,6 +438,8 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 					  trans->bytes_reserved);
 	if (ret)
 		goto out;
+	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (u64)trans,
+				      trans->bytes_reserved, 1);
 again:
 	inode = lookup_free_ino_inode(root, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
@@ -498,6 +500,8 @@ again:
 out_put:
 	iput(inode);
 out_release:
+	trace_btrfs_space_reservation(root->fs_info, "ino_cache", (u64)trans,
+				      trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
 out:
 	trans->block_rsv = rsv;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 81376d9..61673f1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -321,6 +321,8 @@ again:
 	}
 
 	if (num_bytes) {
+		trace_btrfs_space_reservation(root->fs_info, "transaction",
+					      (u64)h, num_bytes, 1);
 		h->block_rsv = &root->fs_info->trans_block_rsv;
 		h->bytes_reserved = num_bytes;
 	}
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1750c0e..84f3001 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -55,6 +55,8 @@ struct extent_buffer;
 	{ BTRFS_BLOCK_GROUP_DUP,	"DUP"}, \
 	{ BTRFS_BLOCK_GROUP_RAID10,	"RAID10"}
 
+#define BTRFS_UUID_SIZE 16
+
 TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_PROTO(struct btrfs_root *root),
@@ -632,6 +634,34 @@ TRACE_EVENT(btrfs_cow_block,
 		  __entry->cow_level)
 );
 
+TRACE_EVENT(btrfs_space_reservation,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info, char *type, u64 val,
+		 u64 bytes, int reserve),
+
+	TP_ARGS(fs_info, type, val, bytes, reserve),
+
+	TP_STRUCT__entry(
+		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__string(	type,	type			)
+		__field(	u64,	val			)
+		__field(	u64,	bytes			)
+		__field(	int,	reserve			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
+		__assign_str(type, type);
+		__entry->val		= val;
+		__entry->bytes		= bytes;
+		__entry->reserve	= reserve;
+	),
+
+	TP_printk("%pU: %s: %Lu %s %Lu", __entry->fsid, __get_str(type),
+		  __entry->val, __entry->reserve ? "reserve" : "release",
+		  __entry->bytes)
+);
+
 DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 
 	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
-- 
1.7.5.2

