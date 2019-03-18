Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A012C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D380220854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfCRQtZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:56030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727454AbfCRQtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06EA3ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 44CD3DA8A7; Mon, 18 Mar 2019 17:50:40 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 15/22] btrfs: tests: return errors from extent map test case 3
Date:   Mon, 18 Mar 2019 17:50:40 +0100
Message-Id: <0d98222b3cca213d21ed25d3df0401a87bf3f37d.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/extent-map-tests.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index d56d03d6b781..17182b14ce9d 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -216,7 +216,10 @@ static int __test_case_3(struct btrfs_fs_info *fs_info,
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
@@ -231,24 +234,26 @@ static int __test_case_3(struct btrfs_fs_info *fs_info,
 	em->block_start = 0;
 	em->block_len = SZ_16K;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
-	if (ret)
+	if (ret) {
 		test_err("case3 [0x%llx 0x%llx): ret %d",
 			 start, start + len, ret);
+		goto out;
+	}
 	/*
 	 * Since bytes within em are contiguous, em->block_start is identical to
 	 * em->start.
 	 */
 	if (em &&
 	    (start < em->start || start + len > extent_map_end(em) ||
-	     em->start != em->block_start || em->len != em->block_len))
+	     em->start != em->block_start || em->len != em->block_len)) {
 		test_err(
 "case3 [0x%llx 0x%llx): ret %d em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)",
 			 start, start + len, ret, em->start, em->len,
 			 em->block_start, em->block_len);
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

