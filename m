Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB95C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17BB320854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfCRQti (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:56076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfCRQth (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 878A9ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C3965DA8A7; Mon, 18 Mar 2019 17:50:51 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 20/22] btrfs: tests: fix comments about tested extent map ranges
Date:   Mon, 18 Mar 2019 17:50:51 +0100
Message-Id: <bb53f433832ce2ca224bdf19c2eae5d66f707f8c.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Comments about ranges did not match the code, the correct calculation is
to use start and start+len as the interval boundaries.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index a09783f19011..87aeabe9d610 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -155,7 +155,7 @@ static int test_case_2(struct btrfs_fs_info *fs_info,
 	}
 	free_extent_map(em);
 
-	/* Add [4K, 4K) following [0, 1K)  */
+	/* Add [4K, 8K) following [0, 1K)  */
 	em = alloc_extent_map();
 	if (!em) {
 		test_std_err(TEST_ALLOC_EXTENT_MAP);
@@ -334,7 +334,7 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	/* Add [8K, 24K) */
+	/* Add [8K, 32K) */
 	em->start = SZ_8K;
 	em->len = 24 * SZ_1K;
 	em->block_start = SZ_16K; /* avoid merging */
-- 
2.21.0

