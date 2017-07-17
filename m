Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33762 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdGQNxH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 09:53:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id 65so3399752wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 06:53:07 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3] Btrfs: add skeleton code for compression heuristic
Date: Mon, 17 Jul 2017 16:52:58 +0300
Message-Id: <20170717135258.15865-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For now that code just return true
Later more complex heuristic code will be added

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 30 ++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 fs/btrfs/inode.c       | 10 +++++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d2ef9ac2a630..27ba11a74eb2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1047,3 +1047,33 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,

 	return 1;
 }
+
+/*
+ * Heuristic skeleton
+ * For now just would be a naive and very optimistic 'return true'.
+ * Heuristic proporsed to fast (in compare to direct compression) detect
+ * data type (compressible/uncompressible) for avoid vaste of cpu time
+ * on compression uncompressible data.
+ * In near time that logic will be added:
+ * 0. Get sample of input data
+ * 1. Detect Mostly Zeroed data
+ * 2. Detect Data with low "byte set" size (Text & etc)
+ * 3. Detect Data with low/high core "byte set"
+ */
+int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
+{
+	u64 index = start >> PAGE_SHIFT;
+	u64 end_index = end >> PAGE_SHIFT;
+	struct page *page;
+	int ret = 1;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		kmap(page);
+		kunmap(page);
+		put_page(page);
+		index++;
+	}
+
+	return ret;
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 87f6d3332163..8508ba6b9aef 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -129,4 +129,6 @@ struct btrfs_compress_op {
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;

+int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
+
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95c212037095..c23b7047fc39 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -392,20 +392,20 @@ static noinline int add_async_extent(struct async_cow *cow,
 	return 0;
 }

-static inline int inode_need_compress(struct inode *inode)
+static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);

 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
-		return 1;
+		return btrfs_compress_heuristic(inode, start, end);
 	/* bad compression ratios */
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
 		return 0;
 	if (btrfs_test_opt(fs_info, COMPRESS) ||
 	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
 	    BTRFS_I(inode)->force_compress)
-		return 1;
+		return btrfs_compress_heuristic(inode, start, end);
 	return 0;
 }

@@ -503,7 +503,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode)) {
+	if (inode_need_compress(inode, start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
@@ -1576,7 +1576,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode)) {
+	} else if (!inode_need_compress(inode, start, end)) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
--
2.13.3
