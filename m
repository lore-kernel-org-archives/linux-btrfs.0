Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45380 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdFLI0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 04:26:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: add compression trace points
Date: Mon, 12 Jun 2017 16:32:26 +0800
Message-Id: <1497256346-666-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds compression and decompression trace points for the
purpose of debugging.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2:
 . Use better naming.
   (If transform is not good enough I have run out of ideas, pls suggest).
 . To be applied on top of
   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
   (tested without namelen check patch set).

 fs/btrfs/compression.c       | 11 +++++++++++
 include/trace/events/btrfs.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index fd6508bcff77..53908722d80e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -884,6 +884,10 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
+
+	trace_btrfs_data_transformer(0, 0, mapping->host, type, *total_in,
+						*total_out, start, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -910,6 +914,10 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 
 	workspace = find_workspace(type);
 	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
+
+	trace_btrfs_data_transformer(1, 1, cb->inode, type,
+				cb->compressed_len, cb->len, cb->start, ret);
+
 	free_workspace(type, workspace);
 
 	return ret;
@@ -932,6 +940,9 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
+	trace_btrfs_data_transformer(1, 0, dest_page->mapping->host,
+				type, srclen, destlen, start_byte, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cd99a3658156..7c2442dab6a0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1622,6 +1622,50 @@ TRACE_EVENT(qgroup_meta_reserve,
 		show_root_type(__entry->refroot), __entry->diff)
 );
 
+#define show_transformer_type(type)			\
+	__print_symbolic(type,				\
+		{ BTRFS_COMPRESS_ZLIB, 	"zlib" },	\
+		{ BTRFS_COMPRESS_LZO, 	"lzo" })
+
+TRACE_EVENT(btrfs_data_transformer,
+
+	TP_PROTO(int uncompress, int its_bio, struct inode *inode, int type,
+			unsigned long len_before, unsigned long len_after,
+			unsigned long start, int ret),
+
+	TP_ARGS(uncompress, its_bio, inode, type, len_before,
+						len_after, start, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	int,		uncompress)
+		__field(	int,		its_bio)
+		__field(	ino_t,		i_ino)
+		__field(	int,		type)
+		__field(	unsigned long,	len_before)
+		__field(	unsigned long,	len_after)
+		__field(	unsigned long,	start)
+		__field(	int,		ret)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->uncompress	= uncompress;
+		__entry->its_bio	= its_bio;
+		__entry->i_ino		= inode->i_ino;
+		__entry->type		= type;
+		__entry->len_before	= len_before;
+		__entry->len_after	= len_after;
+		__entry->start		= start;
+		__entry->ret		= ret;
+	),
+
+	TP_printk_btrfs("%s %s ino=%lu type=%s len_before=%lu len_after=%lu "
+		"start=%lu ret=%d",
+		__entry->uncompress ? "untransform":"transform",
+		__entry->its_bio ? "bio":"page", __entry->i_ino,
+		show_transformer_type(__entry->type), __entry->len_before,
+		__entry->len_after, __entry->start, __entry->ret)
+
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.13.0

