From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 02/12] btrfs: remove nested duplicate variable declarations
Date: Fri, 22 Apr 2011 11:41:15 +0200
Message-ID: <d4adf80603fd3705a9af45369c170304e0ec98dd.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c            |    1 -
 fs/btrfs/free-space-cache.c |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..c60197b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3647,7 +3647,6 @@ setup_items_for_insert(struct btrfs_trans_handle *trans,
 
 	ret = 0;
 	if (slot == 0) {
-		struct btrfs_disk_key disk_key;
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
 		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 11d2e9c..eb7c3cd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1907,8 +1907,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 	while(1) {
 		if (entry->bytes < bytes ||
 		    (!entry->bitmap && entry->offset < min_start)) {
-			struct rb_node *node;
-
 			node = rb_next(&entry->offset_index);
 			if (!node)
 				break;
@@ -1922,7 +1920,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 						      cluster, entry, bytes,
 						      min_start);
 			if (ret == 0) {
-				struct rb_node *node;
 				node = rb_next(&entry->offset_index);
 				if (!node)
 					break;
-- 
1.7.5.rc3

