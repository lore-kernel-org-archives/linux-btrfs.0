Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755179AbdLUXpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfkLc019969
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2f0ptyg0fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjdnE006314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBLNjddu014902
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/10] Btrfs: extent map selftest: buffered write vs dio read
Date: Thu, 21 Dec 2017 15:42:50 -0700
Message-Id: <20171221224256.18196-5-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case simulates the racy situation of buffered write vs dio
read, and see if btrfs_get_extent() would return -EEXIST.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tests/extent-map-tests.c | 73 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 0407396..2adf55f 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -181,6 +181,78 @@ static void test_case_2(struct extent_map_tree *em_tree)
 	free_extent_map_tree(em_tree);
 }
 
+static void __test_case_3(struct extent_map_tree *em_tree, u64 start)
+{
+	struct extent_map *em;
+	u64 len = SZ_4K;
+	int ret;
+
+	em = alloc_extent_map();
+	if (!em)
+		/* Skip this test on error. */
+		return;
+
+	/* Add [4K, 8K) */
+	em->start = SZ_4K;
+	em->len = SZ_4K;
+	em->block_start = SZ_4K;
+	em->block_len = SZ_4K;
+	ret = add_extent_mapping(em_tree, em, 0);
+	ASSERT(ret == 0);
+	free_extent_map(em);
+
+	em = alloc_extent_map();
+	if (!em)
+		goto out;
+
+	/* Add [0, 16K) */
+	em->start = 0;
+	em->len = SZ_16K;
+	em->block_start = 0;
+	em->block_len = SZ_16K;
+	ret = btrfs_add_extent_mapping(em_tree, &em, start, len);
+	if (ret)
+		test_msg("case3 [0x%llx 0x%llx): ret %d\n",
+			 start, start + len, ret);
+	/*
+	 * Since bytes within em are contiguous, em->block_start is identical to
+	 * em->start.
+	 */
+	if (em &&
+	    (start < em->start || start + len > extent_map_end(em) ||
+	     em->start != em->block_start || em->len != em->block_len))
+		test_msg("case3 [0x%llx 0x%llx): ret %d em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)\n",
+			 start, start + len, ret, em->start, em->len,
+			 em->block_start, em->block_len);
+	free_extent_map(em);
+out:
+	/* free memory */
+	free_extent_map_tree(em_tree);
+}
+
+/*
+ * Test scenario:
+ *
+ * Suppose that no extent map has been loaded into memory yet.
+ * There is a file extent [0, 16K), two jobs are running concurrently
+ * against it, t1 is buffered writing to [4K, 8K) and t2 is doing dio
+ * read from [0, 4K) or [8K, 12K) or [12K, 16K).
+ *
+ * t1 goes ahead of t2 and adds em [4K, 8K) into tree.
+ *
+ *         t1                       t2
+ *  cow_file_range()	     btrfs_get_extent()
+ *                            -> lookup_extent_mapping()
+ *   -> add_extent_mapping()
+ *                            -> add_extent_mapping()
+ */
+static void test_case_3(struct extent_map_tree *em_tree)
+{
+	__test_case_3(em_tree, 0);
+	__test_case_3(em_tree, SZ_8K);
+	__test_case_3(em_tree, (12 * 1024ULL));
+}
+
 int btrfs_test_extent_map()
 {
 	struct extent_map_tree *em_tree;
@@ -196,6 +268,7 @@ int btrfs_test_extent_map()
 
 	test_case_1(em_tree);
 	test_case_2(em_tree);
+	test_case_3(em_tree);
 
 	kfree(em_tree);
 	return 0;
-- 
2.9.4

