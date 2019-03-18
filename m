Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66121C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4214920854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfCRQta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:56046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727454AbfCRQt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF8C7ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DADA0DA8A7; Mon, 18 Mar 2019 17:50:44 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 17/22] btrfs: tests: return error from all extent map test cases
Date:   Mon, 18 Mar 2019 17:50:44 +0100
Message-Id: <c2c29fbc951329dcca19498192d0fec79b01954e.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The way the extent map tests handle errors does not conform to the rest
of the suite, where the first failure is reported and then it stops.
Do the same now that we have the errors returned from all the functions.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 44 ++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 35cfb65f1016..5e99c7d40ea1 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -275,12 +275,20 @@ static int __test_case_3(struct btrfs_fs_info *fs_info,
  *   -> add_extent_mapping()
  *                            -> add_extent_mapping()
  */
-static void test_case_3(struct btrfs_fs_info *fs_info,
+static int test_case_3(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree)
 {
-	__test_case_3(fs_info, em_tree, 0);
-	__test_case_3(fs_info, em_tree, SZ_8K);
-	__test_case_3(fs_info, em_tree, (12 * 1024ULL));
+	int ret;
+
+	ret = __test_case_3(fs_info, em_tree, 0);
+	if (ret)
+		return ret;
+	ret = __test_case_3(fs_info, em_tree, SZ_8K);
+	if (ret)
+		return ret;
+	ret = __test_case_3(fs_info, em_tree, (12 * 1024ULL));
+
+	return ret;
 }
 
 static int __test_case_4(struct btrfs_fs_info *fs_info,
@@ -379,11 +387,17 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
  *                                             # handle -EEXIST when adding
  *                                             # [0, 32K)
  */
-static void test_case_4(struct btrfs_fs_info *fs_info,
+static int test_case_4(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree)
 {
-	__test_case_4(fs_info, em_tree, 0);
-	__test_case_4(fs_info, em_tree, SZ_4K);
+	int ret;
+
+	ret = __test_case_4(fs_info, em_tree, 0);
+	if (ret)
+		return ret;
+	ret = __test_case_4(fs_info, em_tree, SZ_4K);
+
+	return ret;
 }
 
 int btrfs_test_extent_map(void)
@@ -412,13 +426,19 @@ int btrfs_test_extent_map(void)
 
 	extent_map_tree_init(em_tree);
 
-	test_case_1(fs_info, em_tree);
-	test_case_2(fs_info, em_tree);
-	test_case_3(fs_info, em_tree);
-	test_case_4(fs_info, em_tree);
+	ret = test_case_1(fs_info, em_tree);
+	if (ret)
+		goto out;
+	ret = test_case_2(fs_info, em_tree);
+	if (ret)
+		goto out;
+	ret = test_case_3(fs_info, em_tree);
+	if (ret)
+		goto out;
+	ret = test_case_4(fs_info, em_tree);
 
-	kfree(em_tree);
 out:
+	kfree(em_tree);
 	btrfs_free_dummy_fs_info(fs_info);
 
 	return ret;
-- 
2.21.0

