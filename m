Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52ED7C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CEF20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfCRQtN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:55918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D348ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9D92DA8A7; Mon, 18 Mar 2019 17:50:28 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 10/22] btrfs: tests: use standard error message after block group allocation failure
Date:   Mon, 18 Mar 2019 17:50:28 +0100
Message-Id: <f2e5328e6268399fe87cd6e684c20517f9875f4f.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/free-space-tests.c      | 2 +-
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 8dcdefab1280..dcbe526e5698 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -847,7 +847,7 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	cache = btrfs_alloc_dummy_block_group(fs_info,
 				      BITS_PER_BITMAP * sectorsize + PAGE_SIZE);
 	if (!cache) {
-		test_err("couldn't run the tests");
+		test_std_err(TEST_ALLOC_BLOCK_GROUP);
 		btrfs_free_dummy_fs_info(fs_info);
 		return 0;
 	}
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 22282c16c022..09c27628e305 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -473,7 +473,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	cache = btrfs_alloc_dummy_block_group(fs_info, 8 * alignment);
 	if (!cache) {
-		test_err("couldn't allocate dummy block group cache");
+		test_std_err(TEST_ALLOC_BLOCK_GROUP);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.21.0

