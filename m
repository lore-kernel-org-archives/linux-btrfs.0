Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28696 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdHMD4L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:56:11 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/4 v3] btrfs: add compression trace points
Date: Sun, 13 Aug 2017 12:02:44 +0800
Message-Id: <20170813040244.18841-5-anand.jain@oracle.com>
In-Reply-To: <20170813040244.18841-1-anand.jain@oracle.com>
References: <20170813040244.18841-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch adds compression and decompression trace points for the
purpose of debugging.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v3:
 . Rename to a simple names, without worrying about being
   compatible with the future naming.
 . The type was not working fixed it.
v2:
 . Use better naming.
   (If transform is not good enough I have run out of ideas, pls suggest).
 . To be applied on top of
   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
   (tested without namelen check patch set)
 fs/btrfs/compression.c       | 11 +++++++++++
 include/trace/events/btrfs.h | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d2ef9ac2a630..4a652f67ee87 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -895,6 +895,10 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
+
+	trace_btrfs_compress(1, 1, mapping->host, type, *total_in,
+						*total_out, start, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -921,6 +925,10 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 
 	workspace = find_workspace(type);
 	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
+
+	trace_btrfs_compress(0, 0, cb->inode, type,
+				cb->compressed_len, cb->len, cb->start, ret);
+
 	free_workspace(type, workspace);
 
 	return ret;
@@ -943,6 +951,9 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
+	trace_btrfs_compress(0, 1, dest_page->mapping->host,
+				type, srclen, destlen, start_byte, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d412c49f5a6a..db33d6649d12 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1629,6 +1629,45 @@ TRACE_EVENT(qgroup_meta_reserve,
 		show_root_type(__entry->refroot), __entry->diff)
 );
 
+TRACE_EVENT(btrfs_compress,
+
+	TP_PROTO(int compress, int page, struct inode *inode,
+			unsigned int type,
+			unsigned long len_before, unsigned long len_after,
+			unsigned long start, int ret),
+
+	TP_ARGS(compress, page, inode, type, len_before,
+					len_after, start, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(int,				compress)
+		__field(int,				page)
+		__field(ino_t,				i_ino)
+		__field(unsigned int,			type)
+		__field(unsigned long,			len_before)
+		__field(unsigned long,			len_after)
+		__field(unsigned long,			start)
+		__field(int,				ret)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->compress	= compress;
+		__entry->page		= page;
+		__entry->i_ino		= inode->i_ino;
+		__entry->type		= type;
+		__entry->len_before	= len_before;
+		__entry->len_after	= len_after;
+		__entry->start		= start;
+		__entry->ret		= ret;
+	),
+
+	TP_printk_btrfs("%s %s ino=%lu type=%s len_before=%lu len_after=%lu start=%lu ret=%d",
+		__entry->compress ? "compress":"uncompress",
+		__entry->page ? "page":"bio", __entry->i_ino,
+		show_compress_type(__entry->type),
+		__entry->len_before, __entry->len_after, __entry->start,
+		__entry->ret)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.13.1

