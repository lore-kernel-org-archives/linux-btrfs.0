From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/5] Btrfs: fix btrfs_read_block_groups return value
Date: Fri, 13 Feb 2009 17:17:39 -0500
Message-ID: <1234563463-7585-1-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_read_block_groups returns an ambiguous value. Whether it finds
 a block group or not, it will return -ENOENT. find_first_block_group
 will eventually return -ENOENT when it reaches past the last block
 group, and that is what is returned to the caller.

 Also, if the kzalloc fails, it will return 0.

 None of this matters right now because open_ctree() isn't checking
 the return value, but I have a patch to handle that as well.

 This patch returns 0 if find_first_block_group after it has already
 found at least one block group, and -ENOENT if it has found none. Other
 errors are reported as expected.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0a5d796..777af73 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6125,7 +6125,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
-	int ret;
+	int ret, found = 0;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *space_info;
@@ -6143,12 +6143,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 	while (1) {
 		ret = find_first_block_group(root, path, &key);
-		if (ret > 0) {
+		if (ret > 0 || (found && ret == -ENOENT)) {
 			ret = 0;
-			goto error;
+			break;
 		}
+
 		if (ret != 0)
-			goto error;
+			break;
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
@@ -6187,9 +6188,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
 			set_block_group_readonly(cache);
+		found = 1;
 	}
-	ret = 0;
-error:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.6.0.2

