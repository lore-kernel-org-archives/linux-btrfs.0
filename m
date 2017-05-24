Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30561 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758749AbdEXC4C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 22:56:02 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: btrfs_decompress_bio() could accept compressed_bio instead
Date: Wed, 24 May 2017 11:01:51 +0800
Message-Id: <20170524030151.29085-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of sending each argument of struct compressed_bio, send
the compressed_bio itself.

Also by having struct compressed_bio in btrfs_decompress_bio()
it would help tracing.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This patch is preparatory for the up coming patch
 btrfs: add compression trace points

 fs/btrfs/compression.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 10e6b282d09d..ee934e612f15 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -81,9 +81,7 @@ struct compressed_bio {
 	u32 sums;
 };
 
-static int btrfs_decompress_bio(int type, struct page **pages_in,
-				   u64 disk_start, struct bio *orig_bio,
-				   size_t srclen);
+static int btrfs_decompress_bio(struct compressed_bio *cb);
 
 static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
 				      unsigned long disk_size)
@@ -173,11 +171,8 @@ static void end_compressed_bio_read(struct bio *bio)
 	/* ok, we're the last bio for this extent, lets start
 	 * the decompression.
 	 */
-	ret = btrfs_decompress_bio(cb->compress_type,
-				      cb->compressed_pages,
-				      cb->start,
-				      cb->orig_bio,
-				      cb->compressed_len);
+	ret = btrfs_decompress_bio(cb);
+
 csum_failed:
 	if (ret)
 		cb->errors = 1;
@@ -961,18 +956,18 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
  * be contiguous.  They all correspond to the range of bytes covered by
  * the compressed extent.
  */
-static int btrfs_decompress_bio(int type, struct page **pages_in,
-				   u64 disk_start, struct bio *orig_bio,
-				   size_t srclen)
+static int btrfs_decompress_bio(struct compressed_bio *cb)
 {
 	struct list_head *workspace;
 	int ret;
+	int type = cb->compress_type;
 
 	workspace = find_workspace(type);
 
-	ret = btrfs_compress_op[type-1]->decompress_bio(workspace, pages_in,
-							 disk_start, orig_bio,
-							 srclen);
+	ret = btrfs_compress_op[type-1]->decompress_bio(workspace,
+			cb->compressed_pages, cb->start, cb->orig_bio,
+			cb->compressed_len);
+
 	free_workspace(type, workspace);
 	return ret;
 }
-- 
2.10.0

