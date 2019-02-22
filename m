Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC411C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48B020823
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfBVKRF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:17:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:44708 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbfBVKRF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:17:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 654BCB15A;
        Fri, 22 Feb 2019 10:17:04 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH 4/5] btrfs: extent_io: Unify the return value of alloc_test_extent_buffer() with alloc_extent_buffer()
Date:   Fri, 22 Feb 2019 18:16:43 +0800
Message-Id: <20190222101645.4403-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222101645.4403-1-wqu@suse.com>
References: <20190222101645.4403-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The function only get called in two locations:
1) free-space-tree-tests.c
2) qgroup-tests.c
   These call sites are stubs.

3) btrfs_find_create_tree_block()
   Since all existing btrfs_find_create_tree_block() callers handles
   the return value correctly, it's also a stub.

So all alloc_test_extent_buffer() callers should be covered by this
patch.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c                   | 21 +++++++++++----------
 fs/btrfs/tests/free-space-tree-tests.c |  3 ++-
 fs/btrfs/tests/qgroup-tests.c          |  3 ++-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f9c9da9b84a3..a19bd8bc3b32 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4863,6 +4863,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 }
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+/* Will either return valid pointer or PTR_ERR(), NEVER NULL pointer. */
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					u64 start)
 {
@@ -4874,12 +4875,14 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
 	if (IS_ERR(eb))
-		return NULL;
+		return eb;
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
@@ -4887,18 +4890,16 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
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
 
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 89346da890cf..025fce63959a 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -462,7 +462,8 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	root->fs_info->tree_root = root;
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 412b910b04cc..536600eb4d9d 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -484,7 +484,8 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	 * *cough*backref walking code*cough*
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
-- 
2.20.1

