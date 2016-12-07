Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43341 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932791AbcLGVhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] Btrfs: add tracepoint for btrfs_get_blocks_dax_fault
Date: Wed,  7 Dec 2016 13:45:10 -0800
Message-Id: <1481147110-20048-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These TPs can help us monitor iomap content for dax reads and writes.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c             |   9 ++++
 include/trace/events/btrfs.h | 106 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9851422..b5bee38 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8067,6 +8067,8 @@ btrfs_get_blocks_dax_fault(struct inode *inode, u64 start, u64 len,
 	struct extent_map *em;
 	int ret = 0;
 
+	trace_btrfs_get_blocks_dax_entry(inode, start, len, create);
+
 	if (!create && start >= i_size_read(inode)) {
 		return 0;
 	}
@@ -8190,12 +8192,19 @@ btrfs_get_blocks_dax_fault(struct inode *inode, u64 start, u64 len,
 
 map_block:
 	ret = btrfs_em_to_iomap(root->fs_info, start, len, em, create, iomap);
+	if (!ret) {
+		if (create)
+			trace_btrfs_iomap_alloc(inode, start, len, iomap);
+		else
+			trace_btrfs_iomap_found(inode, start, len, iomap);
+	}
 
 out:
 	free_extent_map(em);
 
 	ASSERT(lockstart < lockend);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend, &cached_state, GFP_NOFS);
+	trace_btrfs_get_blocks_dax_exit(inode, start, len, create);
 
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 0e04208..f7eb44f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -7,6 +7,7 @@
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
 #include <trace/events/mmflags.h>
+#include <linux/iomap.h>
 
 struct btrfs_root;
 struct btrfs_fs_info;
@@ -1471,6 +1472,111 @@ TRACE_EVENT(qgroup_update_counters,
 		  __entry->cur_new_count)
 );
 
+DECLARE_EVENT_CLASS(btrfs_iomap_class,
+
+	TP_PROTO(struct inode *inode, u64 offset, u64 len, struct iomap *iomap),
+
+	TP_ARGS(inode, offset, len, iomap),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  ino			)
+		__field(	u64,  isize			)
+		__field(	u64,  disk_isize		)
+		__field(	u64,  root_objectid		)
+		__field(	u64,  offset			)
+		__field(	u64,  len			)
+		__field(	u64,  startoff			)
+		__field(	u64,  blockstart		)
+		__field(	u64,  blocklen			)
+		__field(	int,  type			)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->ino = btrfs_ino(inode);
+		__entry->isize = i_size_read(inode);
+		__entry->disk_isize = BTRFS_I(inode)->disk_i_size;
+		__entry->root_objectid =
+				BTRFS_I(inode)->root->root_key.objectid;
+		__entry->offset = offset;
+		__entry->len = len;
+		__entry->startoff = iomap ? iomap->offset : 0;
+		__entry->blockstart = iomap ? (iomap->blkno << 9) : 0;
+		__entry->blocklen = iomap ? iomap->length : 0;
+		__entry->type = iomap ? iomap->type : 0;
+	),
+
+	TP_printk_btrfs("root 0x%llx(%s) ino 0x%llx size 0x%llx "
+			"disk_isize 0x%llx offset 0x%llx len 0x%llx "
+			"startoff 0x%llx blockstart %llu blocklen 0x%llx "
+			" type %d",
+		  show_root_type(__entry->root_objectid),
+		  __entry->ino,
+		  __entry->isize,
+		  __entry->disk_isize,
+		  __entry->offset,
+		  __entry->len,
+		  __entry->startoff,
+		  __entry->blockstart,
+		  __entry->blocklen,
+		  __entry->type)
+);
+
+#define DEFINE_IOMAP_EVENT(name)	\
+DEFINE_EVENT(btrfs_iomap_class, name,	\
+	TP_PROTO(struct inode *inode, u64 offset, u64 len,	\
+		 struct iomap *iomap),				\
+	TP_ARGS(inode, offset, len, iomap));
+
+DEFINE_IOMAP_EVENT(btrfs_iomap_alloc)
+DEFINE_IOMAP_EVENT(btrfs_iomap_found)
+
+DECLARE_EVENT_CLASS(btrfs_get_blocks_dax,
+
+	TP_PROTO(struct inode *inode, u64 offset, u64 len, int create),
+
+	TP_ARGS(inode, offset, len, create),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  root_objectid		)
+		__field(	u64,  ino			)
+		__field(	u64,  isize			)
+		__field(	u64,  disk_isize		)
+		__field(	u64,  offset			)
+		__field(	u64,  len			)
+		__field(	int,  create			)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->root_objectid	= BTRFS_I(inode)->root->objectid;
+		__entry->ino = btrfs_ino(inode);
+		__entry->isize = i_size_read(inode);
+		__entry->disk_isize = BTRFS_I(inode)->disk_i_size;
+		__entry->offset = offset;
+		__entry->len = len;
+		__entry->create = create;
+	),
+
+	TP_printk_btrfs("root 0x%llx(%s) ino 0x%llx isize 0x%llx "
+			"disk_isize 0x%llx offset 0x%llx len 0x%llx create %d",
+			show_root_type(__entry->root_objectid),
+			__entry->ino,
+			__entry->isize,
+			__entry->disk_isize,
+			__entry->offset,
+			__entry->len,
+			__entry->create
+		  )
+);
+
+#define DEFINE_GETBLOCKS_DAX_EVENT(name)	\
+DEFINE_EVENT(btrfs_get_blocks_dax, name,	\
+	TP_PROTO(struct inode *inode, u64 offset, u64 len,	\
+		 int create),				\
+	TP_ARGS(inode, offset, len, create));
+
+DEFINE_GETBLOCKS_DAX_EVENT(btrfs_get_blocks_dax_entry)
+DEFINE_GETBLOCKS_DAX_EVENT(btrfs_get_blocks_dax_exit)
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.5.5

