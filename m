Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48724 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdCDCmb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 21:42:31 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: add file item tracepoint
Date: Fri,  3 Mar 2017 18:41:27 -0800
Message-Id: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While debugging truncate problems, I found that these tracepoints could
help us quickly know what went wrong.

Two sets of tracepoints are created to track regular/prealloc file item
and inline file item respectively, I put inline as a separate one since
what inline file items cares about are way less than the regular one.

This adds four tracepoints:
- btrfs_get_extent_show_fi_regular
- btrfs_get_extent_show_fi_inline
- btrfs_truncate_show_fi_regular
- btrfs_truncate_show_fi_inline

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c             |  15 +++++
 include/trace/events/btrfs.h | 133 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5652f5f..8a26712 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4401,9 +4401,17 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
 				item_end +=
 				    btrfs_file_extent_num_bytes(leaf, fi);
+
+				trace_btrfs_truncate_show_fi_regular(
+					BTRFS_I(inode), leaf, fi,
+					found_key.offset);
 			} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 				item_end += btrfs_file_extent_inline_len(leaf,
 							 path->slots[0], fi);
+
+				trace_btrfs_truncate_show_fi_inline(
+					BTRFS_I(inode), leaf, fi, path->slots[0],
+					found_key.offset);
 			}
 			item_end--;
 		}
@@ -6814,11 +6822,18 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
+
+		trace_btrfs_get_extent_show_fi_regular(inode, leaf, item,
+						       extent_start);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
 		extent_end = ALIGN(extent_start + size,
 				   fs_info->sectorsize);
+
+		trace_btrfs_get_extent_show_fi_inline(inode, leaf, item,
+						      path->slots[0],
+						      extent_start);
 	}
 next:
 	if (start >= extent_end) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a3c3cab..6353d0f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -12,6 +12,7 @@ struct btrfs_root;
 struct btrfs_fs_info;
 struct btrfs_inode;
 struct extent_map;
+struct btrfs_file_extent_item;
 struct btrfs_ordered_extent;
 struct btrfs_delayed_ref_node;
 struct btrfs_delayed_tree_ref;
@@ -54,6 +55,12 @@ struct btrfs_qgroup_extent_record;
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
 	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
+#define show_fi_type(type)						\
+	__print_symbolic(type,					\
+		 { BTRFS_FILE_EXTENT_INLINE,	"INLINE" },	\
+		 { BTRFS_FILE_EXTENT_REG,	"REG"	 },	\
+		 { BTRFS_FILE_EXTENT_PREALLOC,	"PREALLOC"})
+
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
 	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
@@ -232,6 +239,132 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		  __entry->refs, __entry->compress_type)
 );
 
+/* file extent item */
+DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, u64 start),
+
+	TP_ARGS(bi, l, fi, start),
+	
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	root_obj	)
+		__field(	u64,	ino		)
+		__field(	loff_t,	isize		)
+		__field(	u64,	disk_isize	)
+		__field(	u64,	num_bytes	)
+		__field(	u64,	ram_bytes	)
+		__field(	u64,	disk_bytenr	)
+		__field(	u64,	disk_num_bytes	)
+		__field(	u64,	extent_offset	)
+		__field(	u8,	extent_type	)
+		__field(	u8,	compression	)
+		__field(	u64,	extent_start	)
+		__field(	u64,	extent_end	)
+	),
+
+	TP_fast_assign_btrfs(bi->root->fs_info,
+		__entry->root_obj	= bi->root->objectid;
+		__entry->ino		= btrfs_ino(bi);
+		__entry->isize		= bi->vfs_inode.i_size;
+		__entry->disk_isize	= bi->disk_i_size;
+		__entry->num_bytes	= btrfs_file_extent_num_bytes(l, fi);
+		__entry->ram_bytes	= btrfs_file_extent_ram_bytes(l, fi);
+		__entry->disk_bytenr	= btrfs_file_extent_disk_bytenr(l, fi);
+		__entry->disk_num_bytes	= btrfs_file_extent_disk_num_bytes(l, fi);
+		__entry->extent_offset	= btrfs_file_extent_offset(l, fi);
+		__entry->extent_type	= btrfs_file_extent_type(l, fi);
+		__entry->compression	= btrfs_file_extent_compression(l, fi);
+		__entry->extent_start	= start;
+		__entry->extent_end	= (start + __entry->num_bytes);
+	),
+
+	TP_printk_btrfs(
+		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
+		"file extent range [0x%llx 0x%llx] "
+		"(num_bytes 0x%llx ram_bytes 0x%llx disk_bytenr 0x%llx "
+		"disk_num_bytes 0x%llx extent_offset 0x%llx type (%s) "
+		"compression %u",
+		show_root_type(__entry->root_obj), __entry->ino,
+		__entry->isize,
+		__entry->disk_isize, __entry->extent_start,
+		__entry->extent_end, __entry->num_bytes, __entry->ram_bytes,
+		__entry->disk_bytenr, __entry->disk_num_bytes,
+		__entry->extent_offset, show_fi_type(__entry->extent_type),
+		__entry->compression)
+);
+
+DECLARE_EVENT_CLASS(
+	btrfs__file_extent_item_inline,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, int slot, u64 start),
+
+	TP_ARGS(bi, l, fi, slot,  start),
+	
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	root_obj	)
+		__field(	u64,	ino		)
+		__field(	loff_t,	isize		)
+		__field(	u64,	disk_isize	)
+		__field(	u8,	extent_type	)
+		__field(	u8,	compression	)
+		__field(	u64,	extent_start	)
+		__field(	u64,	extent_end	)
+	),
+
+	TP_fast_assign_btrfs(
+		bi->root->fs_info,
+		__entry->root_obj	= bi->root->objectid;
+		__entry->ino		= btrfs_ino(bi);
+		__entry->isize		= bi->vfs_inode.i_size;
+		__entry->disk_isize	= bi->disk_i_size;
+		__entry->extent_type	= btrfs_file_extent_type(l, fi);
+		__entry->compression	= btrfs_file_extent_compression(l, fi);
+		__entry->extent_start	= start;
+		__entry->extent_end	= (start + btrfs_file_extent_inline_len(l, slot, fi));
+	),
+
+	TP_printk_btrfs(
+		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
+		"file extent range [0x%llx 0x%llx] "
+		"extent_type (%s) compression %u",
+		show_root_type(__entry->root_obj), __entry->ino, __entry->isize,
+		__entry->disk_isize, __entry->extent_start,
+		__entry->extent_end, show_fi_type(__entry->extent_type),
+		__entry->compression)
+);
+
+DEFINE_EVENT(
+	btrfs__file_extent_item_regular, btrfs_get_extent_show_fi_regular,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, u64 start),
+
+	TP_ARGS(bi, l, fi, start)
+);
+
+DEFINE_EVENT(
+	btrfs__file_extent_item_regular, btrfs_truncate_show_fi_regular,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, u64 start),
+
+	TP_ARGS(bi, l, fi, start)
+);
+
+DEFINE_EVENT(
+	btrfs__file_extent_item_inline, btrfs_get_extent_show_fi_inline,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, int slot, u64 start),
+
+	TP_ARGS(bi, l, fi, slot, start)
+);
+
+DEFINE_EVENT(
+	btrfs__file_extent_item_inline, btrfs_truncate_show_fi_inline,
+
+	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, int slot, u64 start),
+
+	TP_ARGS(bi, l, fi, slot, start)
+);
+
 #define show_ordered_flags(flags)					   \
 	__print_flags(flags, "|",					   \
 		{ (1 << BTRFS_ORDERED_IO_DONE), 	"IO_DONE" 	}, \
-- 
2.5.5

