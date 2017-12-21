Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755224AbdLUXpl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfble082915
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2f0prs01b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjdCD023398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjdLt024107
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/10] Btrfs: extent map selftest: dio write vs dio read
Date: Thu, 21 Dec 2017 15:42:51 -0700
Message-Id: <20171221224256.18196-6-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case simulates the racy situation of dio write vs dio read,
and see if btrfs_get_extent() would return -EEXIST.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tests/extent-map-tests.c | 88 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 2adf55f..66d5523 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -253,6 +253,93 @@ static void test_case_3(struct extent_map_tree *em_tree)
 	__test_case_3(em_tree, (12 * 1024ULL));
 }
 
+static void __test_case_4(struct extent_map_tree *em_tree, u64 start)
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
+	/* Add [0K, 8K) */
+	em->start = 0;
+	em->len = SZ_8K;
+	em->block_start = 0;
+	em->block_len = SZ_8K;
+	ret = add_extent_mapping(em_tree, em, 0);
+	ASSERT(ret == 0);
+	free_extent_map(em);
+
+	em = alloc_extent_map();
+	if (!em)
+		goto out;
+
+	/* Add [8K, 24K) */
+	em->start = SZ_8K;
+	em->len = 24 * 1024ULL;
+	em->block_start = SZ_16K; /* avoid merging */
+	em->block_len = 24 * 1024ULL;
+	ret = add_extent_mapping(em_tree, em, 0);
+	ASSERT(ret == 0);
+	free_extent_map(em);
+
+	em = alloc_extent_map();
+	if (!em)
+		goto out;
+	/* Add [0K, 32K) */
+	em->start = 0;
+	em->len = SZ_32K;
+	em->block_start = 0;
+	em->block_len = SZ_32K;
+	ret = btrfs_add_extent_mapping(em_tree, &em, start, len);
+	if (ret)
+		test_msg("case4 [0x%llx 0x%llx): ret %d\n",
+			 start, len, ret);
+	if (em &&
+	    (start < em->start || start + len > extent_map_end(em)))
+		test_msg("case4 [0x%llx 0x%llx): ret %d, added wrong em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)\n",
+			 start, len, ret, em->start, em->len, em->block_start,
+			 em->block_len);
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
+ * There is a file extent [0, 32K), two jobs are running concurrently
+ * against it, t1 is doing dio write to [8K, 32K) and t2 is doing dio
+ * read from [0, 4K) or [4K, 8K).
+ *
+ * t1 goes ahead of t2 and splits em [0, 32K) to em [0K, 8K) and [8K 32K).
+ *
+ *         t1                                t2
+ *  btrfs_get_blocks_direct()	       btrfs_get_blocks_direct()
+ *   -> btrfs_get_extent()              -> btrfs_get_extent()
+ *       -> lookup_extent_mapping()
+ *       -> add_extent_mapping()            -> lookup_extent_mapping()
+ *          # load [0, 32K)
+ *   -> btrfs_new_extent_direct()
+ *       -> btrfs_drop_extent_cache()
+ *          # split [0, 32K)
+ *       -> add_extent_mapping()
+ *          # add [8K, 32K)
+ *                                          -> add_extent_mapping()
+ *                                             # handle -EEXIST when adding
+ *                                             # [0, 32K)
+ */
+static void test_case_4(struct extent_map_tree *em_tree)
+{
+	__test_case_4(em_tree, 0);
+	__test_case_4(em_tree, SZ_4K);
+}
+
 int btrfs_test_extent_map()
 {
 	struct extent_map_tree *em_tree;
@@ -269,6 +356,7 @@ int btrfs_test_extent_map()
 	test_case_1(em_tree);
 	test_case_2(em_tree);
 	test_case_3(em_tree);
+	test_case_4(em_tree);
 
 	kfree(em_tree);
 	return 0;
-- 
2.9.4

