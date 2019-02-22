Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C2DC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 00:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C8220661
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 00:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfBVAx4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 19:53:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:59184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbfBVAx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 19:53:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF77BAC32;
        Fri, 22 Feb 2019 00:53:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs selftest
Date:   Fri, 22 Feb 2019 08:53:50 +0800
Message-Id: <20190222005350.7535-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled, btrfs will run
selftest at module load time.

During selftest, we allocate extent buffer using
alloc_test_extent_buffer(), instead of alloc_test_extent_buffer().

The problem is, unlike alloc_extent_buffer(),
alloc_test_extent_buffer() can return NULL pointer instead of error
pointer, and callers all expect error pointer other than NULL pointer.

So this could lead to NULL pointer dereference during selftest.

Fix it by returning error pointer in alloc_test_extent_buffer().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52abe4082680..a7db78f49fdb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4862,12 +4862,14 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
 	if (!eb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	eb->fs_info = fs_info;
 again:
 	ret = radix_tree_preload(GFP_NOFS);
-	if (ret)
-		goto free_eb;
+	if (ret) {
+		btrfs_release_extent_buffer(eb);
+		return ERR_PTR(ret);
+	}
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
 				start >> PAGE_SHIFT, eb);
@@ -4875,18 +4877,16 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
 		exists = find_extent_buffer(fs_info, start);
-		if (exists)
-			goto free_eb;
-		else
-			goto again;
+		if (exists) {
+			btrfs_release_extent_buffer(eb);
+			return exists;
+		}
+		goto again;
 	}
 	check_buffer_tree_ref(eb);
 	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
 
 	return eb;
-free_eb:
-	btrfs_release_extent_buffer(eb);
-	return exists;
 }
 #endif
 
-- 
2.20.1

