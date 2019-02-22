Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B03C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9810B20823
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfBVKRC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:17:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:44666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfBVKRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:17:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45F69B15A;
        Fri, 22 Feb 2019 10:17:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH 3/5] btrfs: extent_io: Unify the return value of alloc_dummy_extent_buffer() with alloc_extent_buffer()
Date:   Fri, 22 Feb 2019 18:16:42 +0800
Message-Id: <20190222101645.4403-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222101645.4403-1-wqu@suse.com>
References: <20190222101645.4403-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All direct callers are:
1) tests/inode-tests.c
2) tests/extent-buffer-tests.c
3) tests/extent-io-tests.c
   These call sites are all stubs.

4) tree_mod_log_rewind()
5) get_old_root()
   These two call sites no longer follows the function name pattern
   *_extent_buffer(). So they are also considered as the boundary.

This patch should cover all the call sites of
alloc_dummy_extent_buffer().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c                     |  4 ++--
 fs/btrfs/extent_io.c                 | 13 ++++++++++---
 fs/btrfs/tests/extent-buffer-tests.c |  6 ++++--
 fs/btrfs/tests/extent-io-tests.c     |  4 ++--
 fs/btrfs/tests/inode-tests.c         |  6 ++++--
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5a6c39b44c84..3276b743f40a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1293,7 +1293,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		BUG_ON(tm->slot != 0);
 		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
-		if (!eb_rewin) {
+		if (IS_ERR(eb_rewin)) {
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
 			return NULL;
@@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		free_extent_buffer(eb_root);
 	}
 
-	if (!eb)
+	if (IS_ERR_OR_NULL(eb))
 		return NULL;
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c73da1752041..f9c9da9b84a3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4734,6 +4734,13 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	return new;
 }
 
+/*
+ * Allocate an extent buffer for selftest.
+ *
+ * Return valid pointer if everything goes well.
+ * Return PTR_ERR() for error.
+ * Will NEVER return NULL.
+ */
 struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len)
 {
@@ -4743,7 +4750,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (IS_ERR(eb))
-		return NULL;
+		return eb;
 
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
@@ -4760,7 +4767,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	for (; i > 0; i--)
 		__free_page(eb->pages[i - 1]);
 	__free_extent_buffer(eb);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
@@ -4866,7 +4873,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
-	if (!eb)
+	if (IS_ERR(eb))
 		return NULL;
 	eb->fs_info = fs_info;
 again:
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 7d72eab6d32c..edf2ab6a7d74 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -48,12 +48,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	path->nodes[0] = eb = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!eb) {
+	eb = alloc_dummy_extent_buffer(fs_info, nodesize);
+	if (IS_ERR(eb)) {
+		eb = NULL;
 		test_err("could not allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
 	}
+	path->nodes[0] = eb;
 	path->slots[0] = 0;
 
 	key.objectid = 0;
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 3c46d7f23456..d1f3b727fbf2 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -396,7 +396,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	}
 
 	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
-	if (!eb) {
+	if (IS_ERR(eb)) {
 		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
@@ -409,7 +409,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
 	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
-	if (!eb) {
+	if (IS_ERR(eb)) {
 		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index af0c8e30d9e2..56a112a39211 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -249,7 +249,8 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
@@ -850,7 +851,8 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
-- 
2.20.1

