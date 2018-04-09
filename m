Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbeDIMBQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 23AC3AD39
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: tracepoints, use correct type for inode number
Date: Mon,  9 Apr 2018 13:58:45 +0200
Message-Id: <ba6c4851a5e50f0fb05f871ae02eac106b76ec7b.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The size of ino_t depends on 32/64bit architecture type. Btrfs stores
the full 64bit inode anyway so we should use it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 965c650a5273..dafd58ad86ec 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -133,7 +133,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 	TP_ARGS(inode),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	ino_t,  ino			)
+		__field(	u64,  ino			)
 		__field(	blkcnt_t,  blocks		)
 		__field(	u64,  disk_i_size		)
 		__field(	u64,  generation		)
@@ -143,7 +143,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 	),
 
 	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
-		__entry->ino	= inode->i_ino;
+		__entry->ino	= btrfs_ino(BTRFS_I(inode));
 		__entry->blocks	= inode->i_blocks;
 		__entry->disk_i_size  = BTRFS_I(inode)->disk_i_size;
 		__entry->generation = BTRFS_I(inode)->generation;
@@ -153,11 +153,11 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 				BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%lu blocks=%llu "
+	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "
 		  "disk_i_size=%llu last_trans=%llu logged_trans=%llu",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->generation,
-		  (unsigned long)__entry->ino,
+		  (unsigned long long)__entry->ino,
 		  (unsigned long long)__entry->blocks,
 		  (unsigned long long)__entry->disk_i_size,
 		  (unsigned long long)__entry->last_trans,
@@ -443,7 +443,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 	TP_ARGS(inode, ordered),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	ino_t,  ino		)
+		__field(	u64,  ino		)
 		__field(	u64,  file_offset	)
 		__field(	u64,  start		)
 		__field(	u64,  len		)
@@ -457,7 +457,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 	),
 
 	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
-		__entry->ino 		= inode->i_ino;
+		__entry->ino 		= btrfs_ino(BTRFS_I(inode));
 		__entry->file_offset	= ordered->file_offset;
 		__entry->start		= ordered->start;
 		__entry->len		= ordered->len;
@@ -528,7 +528,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 	TP_ARGS(page, inode, wbc),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	ino_t,  ino			)
+		__field(	u64,	ino			)
 		__field(	pgoff_t,  index			)
 		__field(	long,   nr_to_write		)
 		__field(	long,   pages_skipped		)
@@ -542,7 +542,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 	),
 
 	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
-		__entry->ino		= inode->i_ino;
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->index		= page->index;
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->pages_skipped	= wbc->pages_skipped;
@@ -556,12 +556,12 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 				 BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) ino=%lu page_index=%lu "
+	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu "
 		  "nr_to_write=%ld pages_skipped=%ld range_start=%llu "
 		  "range_end=%llu for_kupdate=%d "
 		  "for_reclaim=%d range_cyclic=%d writeback_index=%lu",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long)__entry->ino, __entry->index,
+		  (unsigned long long)__entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
 		  __entry->range_start, __entry->range_end,
 		  __entry->for_kupdate,
@@ -584,7 +584,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 	TP_ARGS(page, start, end, uptodate),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	ino_t,	 ino		)
+		__field(	u64,	 ino		)
 		__field(	pgoff_t, index		)
 		__field(	u64,	 start		)
 		__field(	u64,	 end		)
@@ -593,7 +593,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 	),
 
 	TP_fast_assign_btrfs(btrfs_sb(page->mapping->host->i_sb),
-		__entry->ino	= page->mapping->host->i_ino;
+		__entry->ino	= btrfs_ino(BTRFS_I(page->mapping->host));
 		__entry->index	= page->index;
 		__entry->start	= start;
 		__entry->end	= end;
@@ -602,10 +602,10 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 			 BTRFS_I(page->mapping->host)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) ino=%lu page_index=%lu start=%llu "
+	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu start=%llu "
 		  "end=%llu uptodate=%d",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long)__entry->ino, (unsigned long)__entry->index,
+		  (unsigned long long)__entry->ino, (unsigned long)__entry->index,
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->end, __entry->uptodate)
 );
@@ -617,8 +617,8 @@ TRACE_EVENT(btrfs_sync_file,
 	TP_ARGS(file, datasync),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	ino_t,  ino		)
-		__field(	ino_t,  parent		)
+		__field(	u64,	ino		)
+		__field(	u64,	parent		)
 		__field(	int,    datasync	)
 		__field(	u64,    root_objectid	)
 	),
@@ -628,16 +628,17 @@ TRACE_EVENT(btrfs_sync_file,
 		const struct inode *inode = d_inode(dentry);
 
 		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
-		__entry->ino		= inode->i_ino;
-		__entry->parent		= d_inode(dentry->d_parent)->i_ino;
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
+		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	=
 				 BTRFS_I(inode)->root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) ino=%ld parent=%ld datasync=%d",
+	TP_printk_btrfs("root=%llu(%s) ino=%llu parent=%llu datasync=%d",
 		  show_root_type(__entry->root_objectid),
-		  (unsigned long)__entry->ino, (unsigned long)__entry->parent,
+		  (unsigned long long)__entry->ino,
+		  (unsigned long long)__entry->parent,
 		  __entry->datasync)
 );
 
@@ -1476,7 +1477,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,		rootid		)
-		__field(	unsigned long,	ino		)
+		__field(	u64,		ino		)
 		__field(	u64,		start		)
 		__field(	u64,		len		)
 		__field(	u64,		reserved	)
@@ -1485,14 +1486,14 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
 
 	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
 		__entry->rootid		= BTRFS_I(inode)->root->objectid;
-		__entry->ino		= inode->i_ino;
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->start		= start;
 		__entry->len		= len;
 		__entry->reserved	= reserved;
 		__entry->op		= op;
 	),
 
-	TP_printk_btrfs("root=%llu ino=%lu start=%llu len=%llu reserved=%llu op=%s",
+	TP_printk_btrfs("root=%llu ino=%llu start=%llu len=%llu reserved=%llu op=%s",
 		  __entry->rootid, __entry->ino, __entry->start, __entry->len,
 		  __entry->reserved,
 		  __print_flags((unsigned long)__entry->op, "",
-- 
2.16.2

