Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbeH1KhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 06:37:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F781AEAF
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 06:46:52 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent-tree: Detect bytes_may_use underflow earlier
Date: Tue, 28 Aug 2018 14:46:47 +0800
Message-Id: <20180828064647.9738-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have space_info::bytes_may_use underflow detection in
btrfs_free_reserved_data_space_noquota(), we have more callers who are
subtracting number from space_info::bytes_may_use.

So instead of doing underflow detection for every caller, introduce a
new wrapper update_bytes_may_use() to replace open coded bytes_may_use
modifiers.

This also introduce a macro to declare more wrappers, but currently
space_info::bytes_may_use is the mostly interesting one.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 44 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..10b58f231350 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -51,6 +51,21 @@ enum {
 	CHUNK_ALLOC_FORCE = 2,
 };
 
+/* Helper function to detect various space info bytes underflow */
+#define DECLARE_SPACE_INFO_UPDATE(name)					\
+static inline void update_##name(struct btrfs_space_info *sinfo, 	\
+				 s64 bytes)				\
+{									\
+	if (bytes < 0 && sinfo->name < -bytes) {			\
+		WARN_ON(1);						\
+		sinfo->name = 0;					\
+		return;							\
+	}								\
+	sinfo->name += bytes;						\
+}
+
+DECLARE_SPACE_INFO_UPDATE(bytes_may_use);
+
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_ref_node *node, u64 parent,
 			       u64 root_objectid, u64 owner_objectid,
@@ -4221,7 +4236,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	data_sinfo->bytes_may_use += bytes;
+	update_bytes_may_use(data_sinfo, bytes);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
@@ -4274,10 +4289,7 @@ void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 
 	data_sinfo = fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
-	if (WARN_ON(data_sinfo->bytes_may_use < len))
-		data_sinfo->bytes_may_use = 0;
-	else
-		data_sinfo->bytes_may_use -= len;
+	update_bytes_may_use(data_sinfo, -len);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      data_sinfo->flags, len, 0);
 	spin_unlock(&data_sinfo->lock);
@@ -5074,7 +5086,7 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 		list_del_init(&ticket->list);
 	if (ticket->bytes && ticket->bytes < orig_bytes) {
 		u64 num_bytes = orig_bytes - ticket->bytes;
-		space_info->bytes_may_use -= num_bytes;
+		update_bytes_may_use(space_info, -num_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, num_bytes, 0);
 	}
@@ -5120,13 +5132,13 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * If not things get more complicated.
 	 */
 	if (used + orig_bytes <= space_info->total_bytes) {
-		space_info->bytes_may_use += orig_bytes;
+		update_bytes_may_use(space_info, orig_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
 		ret = 0;
 	} else if (can_overcommit(fs_info, space_info, orig_bytes, flush,
 				  system_chunk)) {
-		space_info->bytes_may_use += orig_bytes;
+		update_bytes_may_use(space_info, orig_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
 		ret = 0;
@@ -5189,7 +5201,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	if (ticket.bytes) {
 		if (ticket.bytes < orig_bytes) {
 			u64 num_bytes = orig_bytes - ticket.bytes;
-			space_info->bytes_may_use -= num_bytes;
+			update_bytes_may_use(space_info, -num_bytes);
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      space_info->flags,
 						      num_bytes, 0);
@@ -5373,7 +5385,7 @@ static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 		flush = BTRFS_RESERVE_FLUSH_ALL;
 		goto again;
 	}
-	space_info->bytes_may_use -= num_bytes;
+	update_bytes_may_use(space_info, -num_bytes);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      space_info->flags, num_bytes, 0);
 	spin_unlock(&space_info->lock);
@@ -5401,7 +5413,7 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 						      ticket->bytes, 1);
 			list_del_init(&ticket->list);
 			num_bytes -= ticket->bytes;
-			space_info->bytes_may_use += ticket->bytes;
+			update_bytes_may_use(space_info, ticket->bytes);
 			ticket->bytes = 0;
 			space_info->tickets_id++;
 			wake_up(&ticket->wait);
@@ -5409,7 +5421,7 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      space_info->flags,
 						      num_bytes, 1);
-			space_info->bytes_may_use += num_bytes;
+			update_bytes_may_use(space_info, num_bytes);
 			ticket->bytes -= num_bytes;
 			num_bytes = 0;
 		}
@@ -5718,14 +5730,14 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 			num_bytes = min(num_bytes,
 					block_rsv->size - block_rsv->reserved);
 			block_rsv->reserved += num_bytes;
-			sinfo->bytes_may_use += num_bytes;
+			update_bytes_may_use(sinfo, num_bytes);
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      sinfo->flags, num_bytes,
 						      1);
 		}
 	} else if (block_rsv->reserved > block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
-		sinfo->bytes_may_use -= num_bytes;
+		update_bytes_may_use(sinfo, -num_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 				      sinfo->flags, num_bytes, 0);
 		block_rsv->reserved = block_rsv->size;
@@ -6404,7 +6416,7 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
 		trace_btrfs_space_reservation(cache->fs_info,
 				"space_info", space_info->flags,
 				ram_bytes, 0);
-		space_info->bytes_may_use -= ram_bytes;
+		update_bytes_may_use(space_info, -ram_bytes);
 		if (delalloc)
 			cache->delalloc_bytes += num_bytes;
 	}
@@ -6582,7 +6594,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 				to_add = min(len, global_rsv->size -
 					     global_rsv->reserved);
 				global_rsv->reserved += to_add;
-				space_info->bytes_may_use += to_add;
+				update_bytes_may_use(space_info, to_add);
 				if (global_rsv->reserved >= global_rsv->size)
 					global_rsv->full = 1;
 				trace_btrfs_space_reservation(fs_info,
-- 
2.18.0
