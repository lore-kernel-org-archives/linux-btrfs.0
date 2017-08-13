Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28678 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbdHMD4I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:56:08 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/4] btrfs: decode compress type for tracing
Date: Sun, 13 Aug 2017 12:02:43 +0800
Message-Id: <20170813040244.18841-4-anand.jain@oracle.com>
In-Reply-To: <20170813040244.18841-1-anand.jain@oracle.com>
References: <20170813040244.18841-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So with this now we see the compression type in string.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/trace/events/btrfs.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index c4e4b9427b81..d412c49f5a6a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -190,6 +190,12 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 		{ (1 << EXTENT_FLAG_FILLING),	 	"FILLING" 	},\
 		{ (1 << EXTENT_FLAG_FS_MAPPING),	"FS_MAPPING"	})
 
+#define show_compress_type(type)		 \
+	__print_symbolic(type,			 \
+		{ BTRFS_COMPRESS_NONE, 	"none" },\
+		{ BTRFS_COMPRESS_ZLIB, 	"zlib" },\
+		{ BTRFS_COMPRESS_LZO, 	"lzo" })
+
 TRACE_EVENT_CONDITION(btrfs_get_extent,
 
 	TP_PROTO(struct btrfs_root *root, struct btrfs_inode *inode,
@@ -228,7 +234,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu start=%llu len=%llu "
 		  "orig_start=%llu block_start=%llu(%s) "
 		  "block_len=%llu flags=%s refs=%u "
-		  "compress_type=%u",
+		  "compress_type=%s",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->ino,
 		  (unsigned long long)__entry->start,
@@ -236,8 +242,8 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		  (unsigned long long)__entry->orig_start,
 		  show_map_type(__entry->block_start),
 		  (unsigned long long)__entry->block_len,
-		  show_map_flags(__entry->flags),
-		  __entry->refs, __entry->compress_type)
+		  show_map_flags(__entry->flags), __entry->refs,
+		  show_compress_type(__entry->compress_type))
 );
 
 /* file extent item */
@@ -285,14 +291,14 @@ DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
 		"file extent range=[%llu %llu] "
 		"(num_bytes=%llu ram_bytes=%llu disk_bytenr=%llu "
 		"disk_num_bytes=%llu extent_offset=%llu type=%s "
-		"compression=%u",
+		"compression=%s",
 		show_root_type(__entry->root_obj), __entry->ino,
 		__entry->isize,
 		__entry->disk_isize, __entry->extent_start,
 		__entry->extent_end, __entry->num_bytes, __entry->ram_bytes,
 		__entry->disk_bytenr, __entry->disk_num_bytes,
 		__entry->extent_offset, show_fi_type(__entry->extent_type),
-		__entry->compression)
+		show_compress_type(__entry->compression))
 );
 
 DECLARE_EVENT_CLASS(
@@ -329,11 +335,11 @@ DECLARE_EVENT_CLASS(
 	TP_printk_btrfs(
 		"root=%llu(%s) inode=%llu size=%llu disk_isize=%llu "
 		"file extent range=[%llu %llu] "
-		"extent_type=%s compression=%u",
+		"extent_type=%s compression=%s",
 		show_root_type(__entry->root_obj), __entry->ino, __entry->isize,
 		__entry->disk_isize, __entry->extent_start,
 		__entry->extent_end, show_fi_type(__entry->extent_type),
-		__entry->compression)
+		show_compress_type(__entry->compression))
 );
 
 DEFINE_EVENT(
@@ -424,7 +430,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu file_offset=%llu "
 		  "start=%llu len=%llu disk_len=%llu "
 		  "truncated_len=%llu "
-		  "bytes_left=%llu flags=%s compress_type=%d "
+		  "bytes_left=%llu flags=%s compress_type=%s "
 		  "refs=%d",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->ino,
@@ -435,7 +441,8 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		  (unsigned long long)__entry->truncated_len,
 		  (unsigned long long)__entry->bytes_left,
 		  show_ordered_flags(__entry->flags),
-		  __entry->compress_type, __entry->refs)
+		  show_compress_type(__entry->compress_type),
+		  __entry->refs)
 );
 
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_add,
-- 
2.13.1

