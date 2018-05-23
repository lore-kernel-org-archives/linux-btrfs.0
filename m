Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10774 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754208AbeEWIA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 04:00:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 245C24B40405
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 16:00:52 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: delayed-ref: simplify btrfs_add_delayed_tree_ref()
Date: Wed, 23 May 2018 16:06:50 +0800
Message-ID: <20180523080650.28286-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5a5003df98d5 ("btrfs: delayed-ref: double free in
btrfs_add_delayed_tree_ref()") fixed double free problem by creating
an unnessesary label to jump.
The elegant way is just to change "ref" to "head_ref" and keep
btrfs_add_delayed_tree_ref() and btrfs_add_delayed_data_ref() in
similar structure.

This patch reverts commit 5a5003df98d5 ("btrfs: delayed-ref: double
free in btrfs_add_delayed_tree_ref()") and frees the right head_ref.
No functional change.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
This patch is based on for-next to avoid conflicts with patches
already in for-next.

 fs/btrfs/delayed-ref.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 03dec673d12a..38f8d5d549ed 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -741,14 +741,20 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->level = level;
 
 	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
-	if (!head_ref)
-		goto free_ref;
+	if (!head_ref) {
+		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+		return -ENOMEM;
+	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
 	    is_fstree(ref_root)) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
-		if (!record)
-			goto free_head_ref;
+		if (!record) {
+			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+			kmem_cache_free(btrfs_delayed_ref_head_cachep,
+					head_ref);
+			return -ENOMEM;
+		}
 	}
 
 	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
@@ -779,13 +785,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		btrfs_qgroup_trace_extent_post(fs_info, record);
 
 	return 0;
-
-free_head_ref:
-	kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
-free_ref:
-	kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
-
-	return -ENOMEM;
 }
 
 /*
-- 
2.17.0



