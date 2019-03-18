Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424B4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FFB120854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfCRQtY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:56016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727454AbfCRQtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A741DADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3C29DA8A7; Mon, 18 Mar 2019 17:50:37 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 14/22] btrfs: tests: return errors from extent map test case 2
Date:   Mon, 18 Mar 2019 17:50:37 +0100
Message-Id: <428d38e3c4a92fc4a26dab65c8aa017b264dbcb5.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/extent-map-tests.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 320c2842347c..d56d03d6b781 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -143,7 +143,10 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	em->block_start = EXTENT_MAP_INLINE;
 	em->block_len = (u64)-1;
 	ret = add_extent_mapping(em_tree, em, 0);
-	ASSERT(ret == 0);
+	if (ret < 0) {
+		test_err("cannot add extent range [0, 1K)");
+		goto out;
+	}
 	free_extent_map(em);
 
 	/* Add [4K, 4K) following [0, 1K)  */
@@ -158,7 +161,10 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	em->block_start = SZ_4K;
 	em->block_len = SZ_4K;
 	ret = add_extent_mapping(em_tree, em, 0);
-	ASSERT(ret == 0);
+	if (ret < 0) {
+		test_err("cannot add extent range [4K, 8K)");
+		goto out;
+	}
 	free_extent_map(em);
 
 	em = alloc_extent_map();
@@ -173,19 +179,21 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	em->block_start = EXTENT_MAP_INLINE;
 	em->block_len = (u64)-1;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, em->start, em->len);
-	if (ret)
+	if (ret) {
 		test_err("case2 [0 1K]: ret %d", ret);
+		goto out;
+	}
 	if (em &&
 	    (em->start != 0 || extent_map_end(em) != SZ_1K ||
-	     em->block_start != EXTENT_MAP_INLINE || em->block_len != (u64)-1))
+	     em->block_start != EXTENT_MAP_INLINE || em->block_len != (u64)-1)) {
 		test_err(
 "case2 [0 1K]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu",
 			 ret, em->start, em->len, em->block_start,
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

