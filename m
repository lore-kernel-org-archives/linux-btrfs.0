Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29478 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdHPVRv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 17:17:51 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/4 v4] btrfs: add compression trace points
Date: Thu, 17 Aug 2017 05:24:49 +0800
Message-Id: <20170816212449.10838-1-anand.jain@oracle.com>
In-Reply-To: <20170816143854.GH2866@twin.jikos.cz>
References: <20170816143854.GH2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch adds compression and decompression trace points for the
purpose of debugging.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v4:
 Accepts David's review comments
 . changes from unsigned long to u64.
 . format changes
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
 include/trace/events/btrfs.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

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
index d412c49f5a6a..d0c0bd4fe3c2 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1629,6 +1629,42 @@ TRACE_EVENT(qgroup_meta_reserve,
 		show_root_type(__entry->refroot), __entry->diff)
 );
 
+TRACE_EVENT(btrfs_compress,
+
+	TP_PROTO(int compress, int page, struct inode *inode, unsigned int type,
+			u64 len_before, u64 len_after, u64 start, int ret),
+
+	TP_ARGS(compress, page, inode, type, len_before, len_after, start, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(int,		compress)
+		__field(int,		page)
+		__field(u64,		i_ino)
+		__field(unsigned int,	type)
+		__field(u64,		len_before)
+		__field(u64,		len_after)
+		__field(u64,		start)
+		__field(int,		ret)
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
+	TP_printk_btrfs("%s %s ino=%llu type=%s len_before=%llu len_after=%llu "\
+		"start=%llu ret=%d",
+		__entry->compress ? "compress" : "decompress",
+		__entry->page ? "page" : "bio", __entry->i_ino,
+		show_compress_type(__entry->type), __entry->len_before,
+		__entry->len_after, __entry->start, __entry->ret)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.7.0

