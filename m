Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50647 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750868AbeDZB17 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 21:27:59 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: set keep_lock when necessary in btrfs_defrag_leaves
Date: Thu, 26 Apr 2018 09:27:43 +0800
Message-Id: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

path->keep_lock may force to lock tree root and higher nodes, and make
lock contention worse, thus it needs to be avoided as much as
possible.

In btrfs_degrag_leaves, path->keep_lock is set but @path immediatley
gets released, which is not necessary at all.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: update commit log with more details.

 fs/btrfs/tree-defrag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 3c0987ab587d..c12747904d4c 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -65,8 +65,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		memcpy(&key, &root->defrag_progress, sizeof(key));
 	}
 
-	path->keep_locks = 1;
-
 	ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
 	if (ret < 0)
 		goto out;
@@ -81,6 +79,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	 * a deadlock (attempting to write lock an already write locked leaf).
 	 */
 	path->lowest_level = 1;
+	path->keep_locks = 1;
 	wret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 
 	if (wret < 0) {
-- 
1.8.3.1

