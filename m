Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290DFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0536E20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfCRQt1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727454AbfCRQt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B2CDADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 89CA0DA8A7; Mon, 18 Mar 2019 17:50:42 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 16/22] btrfs: tests: return errors from extent map test case 4
Date:   Mon, 18 Mar 2019 17:50:42 +0100
Message-Id: <9c16c31a9cabe5f9aeb012bd3ef1237bf32b2262.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace asserts with error messages and return errors.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 17182b14ce9d..35cfb65f1016 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -300,7 +300,10 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 	em->block_start = 0;
 	em->block_len = SZ_8K;
 	ret = add_extent_mapping(em_tree, em, 0);
-	ASSERT(ret == 0);
+	if (ret < 0) {
+		test_err("cannot add extent range [0, 8K)");
+		goto out;
+	}
 	free_extent_map(em);
 
 	em = alloc_extent_map();
@@ -315,7 +318,10 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 	em->block_start = SZ_16K; /* avoid merging */
 	em->block_len = 24 * 1024ULL;
 	ret = add_extent_mapping(em_tree, em, 0);
-	ASSERT(ret == 0);
+	if (ret < 0) {
+		test_err("cannot add extent range [8K, 32K)");
+		goto out;
+	}
 	free_extent_map(em);
 
 	em = alloc_extent_map();
@@ -329,19 +335,20 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 	em->block_start = 0;
 	em->block_len = SZ_32K;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
-	if (ret)
+	if (ret) {
 		test_err("case4 [0x%llx 0x%llx): ret %d",
 			 start, len, ret);
-	if (em &&
-	    (start < em->start || start + len > extent_map_end(em)))
+		goto out;
+	}
+	if (em && (start < em->start || start + len > extent_map_end(em))) {
 		test_err(
 "case4 [0x%llx 0x%llx): ret %d, added wrong em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)",
 			 start, len, ret, em->start, em->len, em->block_start,
 			 em->block_len);
+		ret = -EINVAL;
+	}
 	free_extent_map(em);
-	ret = 0;
 out:
-	/* free memory */
 	free_extent_map_tree(em_tree);
 
 	return ret;
-- 
2.21.0

