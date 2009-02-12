From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH #2] btrfs: fix btrfs_read_block_groups return value
Date: Wed, 11 Feb 2009 20:57:34 -0500
Message-ID: <4993820E.3080407@suse.com>
References: <4993808C.20000@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4993808C.20000@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_read_block_groups returns an ambiguous value. Whether it finds
 a block group or not, it will return -ENOENT. find_first_block_group
 will eventually return -ENOENT when it reaches past the last block
 group, and that is what is returned to the caller.

 Also, if the kzalloc fails, it will return 0.

 None of this matters right now because open_ctree() isn't checking
 the return value, but I have a patch to handle that as well.

 This patch returns 0 if find_first_block_group after it has already
 found at least one block group, and -ENOENT if it has found none. It
 also returns -ENOMEM if the kzalloc fails.

 Take 2: After I wrote this analysis, I realized the ret = 0 after the
 loop is never going to be reached and then the error label is redundant.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6106,7 +6106,7 @@ int btrfs_free_block_groups(struct btrfs
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
-	int ret;
+	int ret, found = 0;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *space_info;
@@ -6124,12 +6124,13 @@ int btrfs_read_block_groups(struct btrfs
 
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
@@ -6168,9 +6169,8 @@ int btrfs_read_block_groups(struct btrfs
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
