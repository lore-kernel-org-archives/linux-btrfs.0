Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbcBVHCP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:15 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/5] btrfs-progs: find-root: Allow btrfs-find-root to search chunk root even chunk root is corrupted
Date: Mon, 22 Feb 2016 14:59:56 +0800
Message-Id: <1456124397-21403-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since now open_ctree_fs_info() can even return a valid fs_info with only
system chunk mapping from super block, use this ability to do chunk root
search for heavily damanged fs.

As an fast alternative for time consuming and buggy chunk-recovery.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 17 +++++++++--------
 find-root.c       | 10 +++++-----
 find-root.h       |  2 +-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index fc3812c..3d268cb 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -69,7 +69,6 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 	case BTRFS_CHUNK_TREE_OBJECTID:
 		level = btrfs_super_chunk_root_level(super);
 		gen = btrfs_super_chunk_root_generation(super);
-		printf("Search for chunk root is not supported yet\n");
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
 		level = btrfs_super_log_root_level(super);
@@ -145,7 +144,7 @@ static void print_find_root_result(struct cache_tree *result,
 
 int main(int argc, char **argv)
 {
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_find_root_filter filter = {0};
 	struct cache_tree result;
 	struct cache_extent *found;
@@ -192,16 +191,18 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	root = open_ctree(argv[optind], 0, OPEN_CTREE_CHUNK_ROOT_ONLY);
-	if (!root) {
-		fprintf(stderr, "Open ctree failed\n");
+	fs_info = open_ctree_fs_info(argv[optind], 0, 0,
+			OPEN_CTREE_CHUNK_ROOT_ONLY |
+			OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
+	if (!fs_info) {
+		error("Open ctree failed\n");
 		exit(1);
 	}
 	cache_tree_init(&result);
 
-	get_root_gen_and_level(filter.objectid, root->fs_info,
+	get_root_gen_and_level(filter.objectid, fs_info,
 			       &filter.match_gen, &filter.match_level);
-	ret = btrfs_find_root_search(root, &filter, &result, &found);
+	ret = btrfs_find_root_search(fs_info, &filter, &result, &found);
 	if (ret < 0) {
 		fprintf(stderr, "Fail to search the tree root: %s\n",
 			strerror(-ret));
@@ -215,7 +216,7 @@ int main(int argc, char **argv)
 	print_find_root_result(&result, &filter);
 out:
 	btrfs_find_root_free(&result);
-	close_ctree(root);
+	close_ctree_fs_info(fs_info);
 	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/find-root.c b/find-root.c
index f0204c8..823db6a 100644
--- a/find-root.c
+++ b/find-root.c
@@ -101,17 +101,16 @@ static int add_eb_to_result(struct extent_buffer *eb,
  * Return 1 if found root with given gen/level and set *match to it.
  * Return <0 if error happens
  */
-int btrfs_find_root_search(struct btrfs_root *chunk_root,
+int btrfs_find_root_search(struct btrfs_fs_info *fs_info,
 			   struct btrfs_find_root_filter *filter,
 			   struct cache_tree *result,
 			   struct cache_extent **match)
 {
-	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
 	struct extent_buffer *eb;
 	u64 chunk_offset = 0;
 	u64 chunk_size = 0;
 	u64 offset = 0;
-	u32 leafsize = chunk_root->leafsize;
+	u32 leafsize = btrfs_super_leafsize(fs_info->super_copy);
 	int suppress_errors = 0;
 	int ret = 0;
 
@@ -133,8 +132,9 @@ int btrfs_find_root_search(struct btrfs_root *chunk_root,
 		}
 		for (offset = chunk_offset;
 		     offset < chunk_offset + chunk_size;
-		     offset += chunk_root->leafsize) {
-			eb = read_tree_block(chunk_root, offset, leafsize, 0);
+		     offset += leafsize) {
+			eb = read_tree_block_fs_info(fs_info, offset, leafsize,
+						     0);
 			if (!eb || IS_ERR(eb))
 				continue;
 			ret = add_eb_to_result(eb, result, leafsize, filter,
diff --git a/find-root.h b/find-root.h
index 1c67ebc..60d1111 100644
--- a/find-root.h
+++ b/find-root.h
@@ -65,7 +65,7 @@ struct btrfs_find_root_filter {
 	 * This *WILL* take *TONS* of extra time.
 	 */
 };
-int btrfs_find_root_search(struct btrfs_root *chunk_root,
+int btrfs_find_root_search(struct btrfs_fs_info *fs_info,
 			   struct btrfs_find_root_filter *filter,
 			   struct cache_tree *result,
 			   struct cache_extent **match);
-- 
2.7.1



