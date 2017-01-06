Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755602AbdAFO6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 09:58:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57CDCAAC4
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Jan 2017 14:57:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: make tracepoint format strings more compact
Date: Fri,  6 Jan 2017 15:57:12 +0100
Message-Id: <20170106145712.15972-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've recently added the fsid to trace events, this makes the line quite
long. To reduce the it again, remove extra spaces around = and remove
",".

Signed-off-by: David Sterba <dsterba@suse.com>
---

Applies on top of integration plus two recent tracepoint patches:
* Btrfs: add 'inode' for extent map tracepoint
* Btrfs: add truncated_len for ordered extent tracepoints

 include/trace/events/btrfs.h | 112 +++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 2026a89786b0..88d18a8ceb59 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -130,8 +130,8 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 				BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), gen = %llu, ino = %lu, blocks = %llu, "
-		  "disk_i_size = %llu, last_trans = %llu, logged_trans = %llu",
+	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%lu blocks=%llu "
+		  "disk_i_size=%llu last_trans=%llu logged_trans=%llu",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->generation,
 		  (unsigned long)__entry->ino,
@@ -217,10 +217,10 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		__entry->compress_type	= map->compress_type;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), ino = %llu start = %llu, len = %llu, "
-		  "orig_start = %llu, block_start = %llu(%s), "
-		  "block_len = %llu, flags = %s, refs = %u, "
-		  "compress_type = %u",
+	TP_printk_btrfs("root=%llu(%s) ino=%llu start=%llu len=%llu "
+		  "orig_start=%llu block_start=%llu(%s) "
+		  "block_len=%llu flags=%s refs=%u "
+		  "compress_type=%u",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->ino,
 		  (unsigned long long)__entry->start,
@@ -281,11 +281,11 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		__entry->truncated_len	= ordered->truncated_len;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), ino = %llu, file_offset = %llu, "
-		  "start = %llu, len = %llu, disk_len = %llu, "
-		  "truncated_len = %llu, "
-		  "bytes_left = %llu, flags = %s, compress_type = %d, "
-		  "refs = %d",
+	TP_printk_btrfs("root=%llu(%s) ino=%llu file_offset=%llu "
+		  "start=%llu len=%llu disk_len=%llu "
+		  "truncated_len=%llu "
+		  "bytes_left=%llu flags=%s compress_type=%d "
+		  "refs=%d",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->ino,
 		  (unsigned long long)__entry->file_offset,
@@ -362,10 +362,10 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 				 BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), ino = %lu, page_index = %lu, "
-		  "nr_to_write = %ld, pages_skipped = %ld, range_start = %llu, "
-		  "range_end = %llu, for_kupdate = %d, "
-		  "for_reclaim = %d, range_cyclic = %d, writeback_index = %lu",
+	TP_printk_btrfs("root=%llu(%s) ino=%lu page_index=%lu "
+		  "nr_to_write=%ld pages_skipped=%ld range_start=%llu "
+		  "range_end=%llu for_kupdate=%d "
+		  "for_reclaim=%d range_cyclic=%d writeback_index=%lu",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long)__entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
@@ -408,8 +408,8 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 			 BTRFS_I(page->mapping->host)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), ino = %lu, page_index = %lu, start = %llu, "
-		  "end = %llu, uptodate = %d",
+	TP_printk_btrfs("root=%llu(%s) ino=%lu page_index=%lu start=%llu "
+		  "end=%llu uptodate=%d",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long)__entry->ino, (unsigned long)__entry->index,
 		  (unsigned long long)__entry->start,
@@ -441,7 +441,7 @@ TRACE_EVENT(btrfs_sync_file,
 				 BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), ino = %ld, parent = %ld, datasync = %d",
+	TP_printk_btrfs("root=%llu(%s) ino=%ld parent=%ld datasync=%d",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long)__entry->ino, (unsigned long)__entry->parent,
 		  __entry->datasync)
@@ -492,9 +492,9 @@ TRACE_EVENT(btrfs_add_block_group,
 		__entry->create		= create;
 	),
 
-	TP_printk("%pU: block_group offset = %llu, size = %llu, "
-		  "flags = %llu(%s), bytes_used = %llu, bytes_super = %llu, "
-		  "create = %d", __entry->fsid,
+	TP_printk("%pU: block_group offset=%llu size=%llu "
+		  "flags=%llu(%s) bytes_used=%llu bytes_super=%llu "
+		  "create=%d", __entry->fsid,
 		  (unsigned long long)__entry->offset,
 		  (unsigned long long)__entry->size,
 		  (unsigned long long)__entry->flags,
@@ -543,9 +543,9 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
 		__entry->seq		= ref->seq;
 	),
 
-	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, "
-		  "parent = %llu(%s), ref_root = %llu(%s), level = %d, "
-		  "type = %s, seq = %llu",
+	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s "
+		  "parent=%llu(%s) ref_root=%llu(%s) level=%d "
+		  "type=%s seq=%llu",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
@@ -608,9 +608,9 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
 		__entry->seq		= ref->seq;
 	),
 
-	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, "
-		  "parent = %llu(%s), ref_root = %llu(%s), owner = %llu, "
-		  "offset = %llu, type = %s, seq = %llu",
+	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s "
+		  "parent=%llu(%s) ref_root=%llu(%s) owner=%llu "
+		  "offset=%llu type=%s seq=%llu",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
@@ -665,7 +665,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
 		__entry->is_data	= head_ref->is_data;
 	),
 
-	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, is_data = %d",
+	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s is_data=%d",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
@@ -729,8 +729,8 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 		__entry->root_objectid	= fs_info->chunk_root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), offset = %llu, size = %llu, "
-		  "num_stripes = %d, sub_stripes = %d, type = %s",
+	TP_printk_btrfs("root=%llu(%s) offset=%llu size=%llu "
+		  "num_stripes=%d sub_stripes=%d type=%s",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->offset,
 		  (unsigned long long)__entry->size,
@@ -779,8 +779,8 @@ TRACE_EVENT(btrfs_cow_block,
 		__entry->cow_level	= btrfs_header_level(cow);
 	),
 
-	TP_printk_btrfs("root = %llu(%s), refs = %d, orig_buf = %llu "
-		  "(orig_level = %d), cow_buf = %llu (cow_level = %d)",
+	TP_printk_btrfs("root=%llu(%s) refs=%d orig_buf=%llu "
+		  "(orig_level=%d) cow_buf=%llu (cow_level=%d)",
 		  show_root_type(__entry->root_objectid),
 		  __entry->refs,
 		  (unsigned long long)__entry->buf_start,
@@ -844,7 +844,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 		__assign_str(reason, reason)
 	),
 
-	TP_printk("%pU: %s: flush = %d(%s), flags = %llu(%s), bytes = %llu",
+	TP_printk("%pU: %s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
 		  __entry->fsid, __get_str(reason), __entry->flush,
 		  show_flush_action(__entry->flush),
 		  (unsigned long long)__entry->flags,
@@ -887,8 +887,8 @@ TRACE_EVENT(btrfs_flush_space,
 		__entry->ret		=	ret;
 	),
 
-	TP_printk("%pU: state = %d(%s), flags = %llu(%s), num_bytes = %llu, "
-		  "orig_bytes = %llu, ret = %d", __entry->fsid, __entry->state,
+	TP_printk("%pU: state=%d(%s) flags=%llu(%s) num_bytes=%llu "
+		  "orig_bytes=%llu ret=%d", __entry->fsid, __entry->state,
 		  show_flush_state(__entry->state),
 		  (unsigned long long)__entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
@@ -913,7 +913,7 @@ DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 		__entry->len		= len;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), start = %llu, len = %llu",
+	TP_printk_btrfs("root=%llu(%s) start=%llu len=%llu",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->len)
@@ -952,7 +952,7 @@ TRACE_EVENT(find_free_extent,
 		__entry->data		= data;
 	),
 
-	TP_printk_btrfs("root = %Lu(%s), len = %Lu, empty_size = %Lu, flags = %Lu(%s)",
+	TP_printk_btrfs("root=%Lu(%s) len=%Lu empty_size=%Lu flags=%Lu(%s)",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  __entry->num_bytes, __entry->empty_size, __entry->data,
 		  __print_flags((unsigned long)__entry->data, "|",
@@ -981,8 +981,8 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 		__entry->len		= len;
 	),
 
-	TP_printk_btrfs("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
-		  "start = %Lu, len = %Lu",
+	TP_printk_btrfs("root=%Lu(%s) block_group=%Lu flags=%Lu(%s) "
+		  "start=%Lu len=%Lu",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  __entry->bg_objectid,
 		  __entry->flags, __print_flags((unsigned long)__entry->flags,
@@ -1033,8 +1033,8 @@ TRACE_EVENT(btrfs_find_cluster,
 		__entry->min_bytes	= min_bytes;
 	),
 
-	TP_printk_btrfs("block_group = %Lu, flags = %Lu(%s), start = %Lu, len = %Lu,"
-		  " empty_size = %Lu, min_bytes = %Lu", __entry->bg_objectid,
+	TP_printk_btrfs("block_group=%Lu flags=%Lu(%s) start=%Lu len=%Lu "
+		  "empty_size=%Lu min_bytes=%Lu", __entry->bg_objectid,
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS), __entry->start,
@@ -1055,7 +1055,7 @@ TRACE_EVENT(btrfs_failed_cluster_setup,
 		__entry->bg_objectid	= block_group->key.objectid;
 	),
 
-	TP_printk_btrfs("block_group = %Lu", __entry->bg_objectid)
+	TP_printk_btrfs("block_group=%Lu", __entry->bg_objectid)
 );
 
 TRACE_EVENT(btrfs_setup_cluster,
@@ -1083,8 +1083,8 @@ TRACE_EVENT(btrfs_setup_cluster,
 		__entry->bitmap		= bitmap;
 	),
 
-	TP_printk_btrfs("block_group = %Lu, flags = %Lu(%s), window_start = %Lu, "
-		  "size = %Lu, max_size = %Lu, bitmap = %d",
+	TP_printk_btrfs("block_group=%Lu flags=%Lu(%s) window_start=%Lu "
+		  "size=%Lu max_size=%Lu bitmap=%d",
 		  __entry->bg_objectid,
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
@@ -1111,7 +1111,7 @@ TRACE_EVENT(alloc_extent_state,
 		__entry->ip	= IP
 	),
 
-	TP_printk("state=%p; mask = %s; caller = %pS", __entry->state,
+	TP_printk("state=%p mask=%s caller=%pS", __entry->state,
 		  show_gfp_flags(__entry->mask), (void *)__entry->ip)
 );
 
@@ -1131,7 +1131,7 @@ TRACE_EVENT(free_extent_state,
 		__entry->ip = IP
 	),
 
-	TP_printk(" state=%p; caller = %pS", __entry->state,
+	TP_printk("state=%p caller=%pS", __entry->state,
 		  (void *)__entry->ip)
 );
 
@@ -1159,8 +1159,8 @@ DECLARE_EVENT_CLASS(btrfs__work,
 		__entry->normal_work	= &work->normal_work;
 	),
 
-	TP_printk_btrfs("work=%p (normal_work=%p), wq=%p, func=%pf, ordered_func=%p,"
-		  " ordered_free=%p",
+	TP_printk_btrfs("work=%p (normal_work=%p) wq=%p func=%pf ordered_func=%p "
+		  "ordered_free=%p",
 		  __entry->work, __entry->normal_work, __entry->wq,
 		   __entry->func, __entry->ordered_func, __entry->ordered_free)
 );
@@ -1233,7 +1233,7 @@ DECLARE_EVENT_CLASS(btrfs__workqueue,
 		__entry->high		= high;
 	),
 
-	TP_printk_btrfs("name=%s%s, wq=%p", __get_str(name),
+	TP_printk_btrfs("name=%s%s wq=%p", __get_str(name),
 		  __print_flags(__entry->high, "",
 				{(WQ_HIGHPRI),	"-high"}),
 		  __entry->wq)
@@ -1288,7 +1288,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
 		__entry->free_reserved	=	free_reserved;
 	),
 
-	TP_printk_btrfs("rootid=%llu, ino=%lu, free_reserved=%llu",
+	TP_printk_btrfs("rootid=%llu ino=%lu free_reserved=%llu",
 		  __entry->rootid, __entry->ino, __entry->free_reserved)
 );
 
@@ -1335,7 +1335,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
 		__entry->op		= op;
 	),
 
-	TP_printk_btrfs("root=%llu, ino=%lu, start=%llu, len=%llu, reserved=%llu, op=%s",
+	TP_printk_btrfs("root=%llu ino=%lu start=%llu len=%llu reserved=%llu op=%s",
 		  __entry->rootid, __entry->ino, __entry->start, __entry->len,
 		  __entry->reserved,
 		  __print_flags((unsigned long)__entry->op, "",
@@ -1373,7 +1373,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_delayed_ref,
 		__entry->reserved	= reserved;
 	),
 
-	TP_printk_btrfs("root=%llu, reserved=%llu, op=free",
+	TP_printk_btrfs("root=%llu reserved=%llu op=free",
 		  __entry->ref_root, __entry->reserved)
 );
 
@@ -1400,7 +1400,7 @@ DECLARE_EVENT_CLASS(btrfs_qgroup_extent,
 		__entry->num_bytes	= rec->num_bytes;
 	),
 
-	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu",
+	TP_printk_btrfs("bytenr=%llu num_bytes=%llu",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes)
 );
@@ -1442,8 +1442,8 @@ TRACE_EVENT(btrfs_qgroup_account_extent,
 		__entry->nr_new_roots	= nr_new_roots;
 	),
 
-	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, nr_old_roots = %llu, "
-		  "nr_new_roots = %llu",
+	TP_printk_btrfs("bytenr=%llu num_bytes=%llu nr_old_roots=%llu "
+		  "nr_new_roots=%llu",
 		  __entry->bytenr,
 		  __entry->num_bytes,
 		  __entry->nr_old_roots,
@@ -1469,7 +1469,7 @@ TRACE_EVENT(qgroup_update_counters,
 		__entry->cur_new_count	= cur_new_count;
 	),
 
-	TP_printk_btrfs("qgid = %llu, cur_old_count = %llu, cur_new_count = %llu",
+	TP_printk_btrfs("qgid=%llu cur_old_count=%llu cur_new_count=%llu",
 		  __entry->qgid,
 		  __entry->cur_old_count,
 		  __entry->cur_new_count)
-- 
2.10.1

