Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75088C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9DD20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfCRQtd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:56056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfCRQtd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2762ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 31B4EDA8A7; Mon, 18 Mar 2019 17:50:47 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 18/22] btrfs: tests: use standard error message after extent map allocation failure
Date:   Mon, 18 Mar 2019 17:50:47 +0100
Message-Id: <b2fa1d434b0e3bf7b0d3159316a83b65ee65dc62.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 5e99c7d40ea1..9bf75f7d2c26 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -56,8 +56,10 @@ static int test_case_1(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		return -ENOMEM;
+	}
 
 	/* Add [0, 16K) */
 	em->start = 0;
@@ -74,6 +76,7 @@ static int test_case_1(struct btrfs_fs_info *fs_info,
 	/* Add [16K, 20K) following [0, 16K)  */
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -91,6 +94,7 @@ static int test_case_1(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -134,8 +138,10 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		return -ENOMEM;
+	}
 
 	/* Add [0, 1K) */
 	em->start = 0;
@@ -152,6 +158,7 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	/* Add [4K, 4K) following [0, 1K)  */
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -169,6 +176,7 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -207,8 +215,10 @@ static int __test_case_3(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		return -ENOMEM;
+	}
 
 	/* Add [4K, 8K) */
 	em->start = SZ_4K;
@@ -224,6 +234,7 @@ static int __test_case_3(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -299,8 +310,10 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		return -ENOMEM;
+	}
 
 	/* Add [0K, 8K) */
 	em->start = 0;
@@ -316,6 +329,7 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -334,6 +348,7 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em) {
+		test_std_err(TEST_ALLOC_EXTENT_MAP);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.21.0

