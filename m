Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751502AbeDIMBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B07C3AEF9
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/7] btrfs: tracepoints, drop unnecessary ULL casts
Date: Mon,  9 Apr 2018 13:58:50 +0200
Message-Id: <971ba39ccdad095462634ba3b41bbc358ea2e3be.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The (unsigned long long) casts are not necessary since long ago.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 124 +++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 200c45911919..06e8b8bdfb42 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -123,7 +123,7 @@ TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_printk_btrfs("root = %llu(%s), gen = %llu",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->generation)
+		  __entry->generation)
 );
 
 DECLARE_EVENT_CLASS(btrfs__inode,
@@ -156,12 +156,12 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "
 		  "disk_i_size=%llu last_trans=%llu logged_trans=%llu",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->generation,
-		  (unsigned long long)__entry->ino,
+		  __entry->generation,
+		  __entry->ino,
 		  (unsigned long long)__entry->blocks,
-		  (unsigned long long)__entry->disk_i_size,
-		  (unsigned long long)__entry->last_trans,
-		  (unsigned long long)__entry->logged_trans)
+		  __entry->disk_i_size,
+		  __entry->last_trans,
+		  __entry->logged_trans)
 );
 
 DEFINE_EVENT(btrfs__inode, btrfs_inode_new,
@@ -244,12 +244,12 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		  "block_len=%llu flags=%s refs=%u "
 		  "compress_type=%u",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->ino,
-		  (unsigned long long)__entry->start,
-		  (unsigned long long)__entry->len,
-		  (unsigned long long)__entry->orig_start,
+		  __entry->ino,
+		  __entry->start,
+		  __entry->len,
+		  __entry->orig_start,
 		  show_map_type(__entry->block_start),
-		  (unsigned long long)__entry->block_len,
+		  __entry->block_len,
 		  show_map_flags(__entry->flags),
 		  __entry->refs, __entry->compress_type)
 );
@@ -281,12 +281,12 @@ TRACE_EVENT(btrfs_handle_em_exist,
 	TP_printk("start=%llu len=%llu "
 		  "existing(start=%llu len=%llu) "
 		  "em(start=%llu len=%llu)",
-		  (unsigned long long)__entry->start,
-		  (unsigned long long)__entry->len,
-		  (unsigned long long)__entry->e_start,
-		  (unsigned long long)__entry->e_len,
-		  (unsigned long long)__entry->map_start,
-		  (unsigned long long)__entry->map_len)
+		  __entry->start,
+		  __entry->len,
+		  __entry->e_start,
+		  __entry->e_len,
+		  __entry->map_start,
+		  __entry->map_len)
 );
 
 /* file extent item */
@@ -477,13 +477,13 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		  "bytes_left=%llu flags=%s compress_type=%d "
 		  "refs=%d",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->ino,
-		  (unsigned long long)__entry->file_offset,
-		  (unsigned long long)__entry->start,
-		  (unsigned long long)__entry->len,
-		  (unsigned long long)__entry->disk_len,
-		  (unsigned long long)__entry->truncated_len,
-		  (unsigned long long)__entry->bytes_left,
+		  __entry->ino,
+		  __entry->file_offset,
+		  __entry->start,
+		  __entry->len,
+		  __entry->disk_len,
+		  __entry->truncated_len,
+		  __entry->bytes_left,
 		  show_ordered_flags(__entry->flags),
 		  __entry->compress_type, __entry->refs)
 );
@@ -561,7 +561,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		  "range_end=%llu for_kupdate=%d "
 		  "for_reclaim=%d range_cyclic=%d writeback_index=%lu",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->ino, __entry->index,
+		  __entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
 		  __entry->range_start, __entry->range_end,
 		  __entry->for_kupdate,
@@ -605,9 +605,9 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu start=%llu "
 		  "end=%llu uptodate=%d",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->ino, (unsigned long)__entry->index,
-		  (unsigned long long)__entry->start,
-		  (unsigned long long)__entry->end, __entry->uptodate)
+		  __entry->ino, (unsigned long)__entry->index,
+		  __entry->start,
+		  __entry->end, __entry->uptodate)
 );
 
 TRACE_EVENT(btrfs_sync_file,
@@ -637,8 +637,8 @@ TRACE_EVENT(btrfs_sync_file,
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu parent=%llu datasync=%d",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->ino,
-		  (unsigned long long)__entry->parent,
+		  __entry->ino,
+		  __entry->parent,
 		  __entry->datasync)
 );
 
@@ -690,13 +690,13 @@ TRACE_EVENT(btrfs_add_block_group,
 	TP_printk("%pU: block_group offset=%llu size=%llu "
 		  "flags=%llu(%s) bytes_used=%llu bytes_super=%llu "
 		  "create=%d", __entry->fsid,
-		  (unsigned long long)__entry->offset,
-		  (unsigned long long)__entry->size,
-		  (unsigned long long)__entry->flags,
+		  __entry->offset,
+		  __entry->size,
+		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS),
-		  (unsigned long long)__entry->bytes_used,
-		  (unsigned long long)__entry->bytes_super, __entry->create)
+		  __entry->bytes_used,
+		  __entry->bytes_super, __entry->create)
 );
 
 #define show_ref_action(action)						\
@@ -741,13 +741,13 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
 	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s "
 		  "parent=%llu(%s) ref_root=%llu(%s) level=%d "
 		  "type=%s seq=%llu",
-		  (unsigned long long)__entry->bytenr,
-		  (unsigned long long)__entry->num_bytes,
+		  __entry->bytenr,
+		  __entry->num_bytes,
 		  show_ref_action(__entry->action),
 		  show_root_type(__entry->parent),
 		  show_root_type(__entry->ref_root),
 		  __entry->level, show_ref_type(__entry->type),
-		  (unsigned long long)__entry->seq)
+		  __entry->seq)
 );
 
 DEFINE_EVENT(btrfs_delayed_tree_ref,  add_delayed_tree_ref,
@@ -806,15 +806,15 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
 	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s "
 		  "parent=%llu(%s) ref_root=%llu(%s) owner=%llu "
 		  "offset=%llu type=%s seq=%llu",
-		  (unsigned long long)__entry->bytenr,
-		  (unsigned long long)__entry->num_bytes,
+		  __entry->bytenr,
+		  __entry->num_bytes,
 		  show_ref_action(__entry->action),
 		  show_root_type(__entry->parent),
 		  show_root_type(__entry->ref_root),
-		  (unsigned long long)__entry->owner,
-		  (unsigned long long)__entry->offset,
+		  __entry->owner,
+		  __entry->offset,
 		  show_ref_type(__entry->type),
-		  (unsigned long long)__entry->seq)
+		  __entry->seq)
 );
 
 DEFINE_EVENT(btrfs_delayed_data_ref,  add_delayed_data_ref,
@@ -860,8 +860,8 @@ DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
 	),
 
 	TP_printk_btrfs("bytenr=%llu num_bytes=%llu action=%s is_data=%d",
-		  (unsigned long long)__entry->bytenr,
-		  (unsigned long long)__entry->num_bytes,
+		  __entry->bytenr,
+		  __entry->num_bytes,
 		  show_ref_action(__entry->action),
 		  __entry->is_data)
 );
@@ -924,8 +924,8 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 	TP_printk_btrfs("root=%llu(%s) offset=%llu size=%llu "
 		  "num_stripes=%d sub_stripes=%d type=%s",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long long)__entry->offset,
-		  (unsigned long long)__entry->size,
+		  __entry->offset,
+		  __entry->size,
 		  __entry->num_stripes, __entry->sub_stripes,
 		  show_chunk_type(__entry->type))
 );
@@ -975,9 +975,9 @@ TRACE_EVENT(btrfs_cow_block,
 		  "(orig_level=%d) cow_buf=%llu (cow_level=%d)",
 		  show_root_type(__entry->root_objectid),
 		  __entry->refs,
-		  (unsigned long long)__entry->buf_start,
+		  __entry->buf_start,
 		  __entry->buf_level,
-		  (unsigned long long)__entry->cow_start,
+		  __entry->cow_start,
 		  __entry->cow_level)
 );
 
@@ -1039,10 +1039,10 @@ TRACE_EVENT(btrfs_trigger_flush,
 	TP_printk("%pU: %s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
 		  __entry->fsid, __get_str(reason), __entry->flush,
 		  show_flush_action(__entry->flush),
-		  (unsigned long long)__entry->flags,
+		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS),
-		  (unsigned long long)__entry->bytes)
+		  __entry->bytes)
 );
 
 #define show_flush_state(state)							\
@@ -1080,10 +1080,10 @@ TRACE_EVENT(btrfs_flush_space,
 	TP_printk("%pU: state=%d(%s) flags=%llu(%s) num_bytes=%llu ret=%d",
 		  __entry->fsid, __entry->state,
 		  show_flush_state(__entry->state),
-		  (unsigned long long)__entry->flags,
+		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS),
-		  (unsigned long long)__entry->num_bytes, __entry->ret)
+		  __entry->num_bytes, __entry->ret)
 );
 
 DECLARE_EVENT_CLASS(btrfs__reserved_extent,
@@ -1104,8 +1104,8 @@ DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 
 	TP_printk_btrfs("root=%llu(%s) start=%llu len=%llu",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
-		  (unsigned long long)__entry->start,
-		  (unsigned long long)__entry->len)
+		  __entry->start,
+		  __entry->len)
 );
 
 DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_alloc,
@@ -1766,14 +1766,14 @@ DECLARE_EVENT_CLASS(btrfs__prelim_ref,
 	),
 
 	TP_printk_btrfs("root_id=%llu key=[%llu,%u,%llu] level=%d count=[%d+%d=%d] parent=%llu wanted_disk_byte=%llu nodes=%llu",
-			(unsigned long long)__entry->root_id,
-			(unsigned long long)__entry->objectid, __entry->type,
-			(unsigned long long)__entry->offset, __entry->level,
+			__entry->root_id,
+			__entry->objectid, __entry->type,
+			__entry->offset, __entry->level,
 			__entry->old_count, __entry->mod_count,
 			__entry->old_count + __entry->mod_count,
-			(unsigned long long)__entry->parent,
-			(unsigned long long)__entry->bytenr,
-			(unsigned long long)__entry->tree_size)
+			__entry->parent,
+			__entry->bytenr,
+			__entry->tree_size)
 );
 
 DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_merge,
@@ -1809,7 +1809,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu mod=%d",
 			show_root_type(__entry->root_objectid),
-			(unsigned long long)__entry->ino, __entry->mod)
+			__entry->ino, __entry->mod)
 );
 #endif /* _TRACE_BTRFS_H */
 
-- 
2.16.2

