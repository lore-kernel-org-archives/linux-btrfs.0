Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58644 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751211AbbD3Qsj (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 30 Apr 2015 12:48:39 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix mutex unlock without prior lock on space cache truncation
Date: Thu, 30 Apr 2015 17:47:05 +0100
Message-Id: <1430412425-12876-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the call to btrfs_truncate_inode_items() failed and we don't have a block
group, we were unlocking the cache_write_mutex without having locked it (we
do it only if we have a block group).

Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout
                      outside critical section in commit")

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c1d1e6d..f1ddccf 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -231,6 +231,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 {
 	int ret = 0;
 	struct btrfs_path *path = btrfs_alloc_path();
+	bool locked = false;
 
 	if (!path) {
 		ret = -ENOMEM;
@@ -238,6 +239,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	}
 
 	if (block_group) {
+		locked = true;
 		mutex_lock(&trans->transaction->cache_write_mutex);
 		if (!list_empty(&block_group->io_list)) {
 			list_del_init(&block_group->io_list);
@@ -269,18 +271,14 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	 */
 	ret = btrfs_truncate_inode_items(trans, root, inode,
 					 0, BTRFS_EXTENT_DATA_KEY);
-	if (ret) {
-		mutex_unlock(&trans->transaction->cache_write_mutex);
-		btrfs_abort_transaction(trans, root, ret);
-		return ret;
-	}
+	if (ret)
+		goto fail;
 
 	ret = btrfs_update_inode(trans, root, inode);
 
-	if (block_group)
-		mutex_unlock(&trans->transaction->cache_write_mutex);
-
 fail:
+	if (locked)
+		mutex_unlock(&trans->transaction->cache_write_mutex);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 
-- 
2.1.3

