Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47657 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163805AbdEZHjc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 03:39:32 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3 v2] btrfs: add compression trace points
Date: Fri, 26 May 2017 15:45:00 +0800
Message-Id: <20170526074500.20342-4-anand.jain@oracle.com>
In-Reply-To: <20170526074500.20342-1-anand.jain@oracle.com>
References: <20170526074500.20342-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds compression and decompression trace points for the
purpose of debugging.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: no change
 fs/btrfs/compression.c       | 10 ++++++++++
 include/trace/events/btrfs.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e426a8f427b5..490590e62a2f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -899,6 +899,10 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
+
+	trace_btrfs_encoder(1, 0, mapping->host, type, *total_in,
+						*total_out, start, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -927,6 +931,9 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 
 	ret = btrfs_compress_op[type-1]->decompress_bio(workspace, cb);
 
+	trace_btrfs_encoder(0, 1, cb->inode, type,
+				cb->compressed_len, cb->len, cb->start, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -948,6 +955,9 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
+	trace_btrfs_encoder(0, 0, dest_page->mapping->host,
+				type, srclen, destlen, start_byte, ret);
+
 	free_workspace(type, workspace);
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e37973526153..1ebffcd005a1 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1658,6 +1658,42 @@ TRACE_EVENT(qgroup_meta_reserve,
 		show_root_type(__entry->refroot), __entry->diff)
 );
 
+TRACE_EVENT(btrfs_encoder,
+
+	TP_PROTO(int encode, int bio, struct inode *inode, int type,
+			unsigned long bfr, unsigned long aft,
+			unsigned long start, int ret),
+
+	TP_ARGS(encode, bio, inode, type, bfr, aft, start, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	int,		encode)
+		__field(	int,		bio)
+		__field(	unsigned long,	i_ino)
+		__field(	int,		type)
+		__field(	unsigned long,	bfr)
+		__field(	unsigned long,	aft)
+		__field(	unsigned long,	start)
+		__field(	int,		ret)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->encode		= encode;
+		__entry->bio		= bio;
+		__entry->i_ino		= inode->i_ino;
+		__entry->type		= type;
+		__entry->bfr		= bfr;
+		__entry->aft		= aft;
+		__entry->start		= start;
+		__entry->ret		= ret;
+	),
+
+	TP_printk_btrfs("%s %s ino:%lu tfm:%d bfr:%lu aft:%lu start:%lu ret:%d",
+		__entry->encode ? "encode":"decode",
+		__entry->bio ? "bio":"pge", __entry->i_ino, __entry->type,
+		__entry->bfr, __entry->aft, __entry->start, __entry->ret)
+
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.10.0

