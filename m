Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51883 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbaJ0JS1 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 27 Oct 2014 05:18:27 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix invalid leaf slot access in btrfs_lookup_extent()
Date: Mon, 27 Oct 2014 09:16:55 +0000
Message-Id: <1414401415-27745-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we couldn't find our extent item, we accessed the current slot
(path->slots[0]) to check if it corresponds to an equivalent skinny
metadata item. However this slot could be beyond our last item in the
leaf (i.e. path->slots[0] >= btrfs_header_nritems(leaf)), in which case
we shouldn't process it.

Since btrfs_lookup_extent() is only used to find extent items for data
extents, fix this by removing completely the logic that looks up for an
equivalent skinny metadata item, since it can not exist.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d599ba..9141b2b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -710,7 +710,7 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
-/* simple helper to search for an existing extent at a given offset */
+/* simple helper to search for an existing data extent at a given offset */
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 {
 	int ret;
@@ -726,12 +726,6 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
 				0, 0);
-	if (ret > 0) {
-		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		if (key.objectid == start &&
-		    key.type == BTRFS_METADATA_ITEM_KEY)
-			ret = 0;
-	}
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.9.1

