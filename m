From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/4] Btrfs: map the node block when looking for readahead targets
Date: Wed, 11 May 2011 17:35:52 -0400
Message-ID: <1305149755-4413-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we have particularly full nodes, we could call btrfs_node_blockptr up to 32
times, which is 32 pairs of kmap/kunmap, which _sucks_.  So go ahead and map the
extent buffer while we look for readahead targets.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..009bcf7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1229,6 +1229,7 @@ static void reada_for_search(struct btrfs_root *root,
 	u64 search;
 	u64 target;
 	u64 nread = 0;
+	u64 gen;
 	int direction = path->reada;
 	struct extent_buffer *eb;
 	u32 nr;
@@ -1256,6 +1257,15 @@ static void reada_for_search(struct btrfs_root *root,
 	nritems = btrfs_header_nritems(node);
 	nr = slot;
 	while (1) {
+		if (!node->map_token) {
+			unsigned long offset = btrfs_node_key_ptr_offset(nr);
+			map_private_extent_buffer(node, offset,
+						  sizeof(struct btrfs_key_ptr),
+						  &node->map_token,
+						  &node->kaddr,
+						  &node->map_start,
+						  &node->map_len, KM_USER1);
+		}
 		if (direction < 0) {
 			if (nr == 0)
 				break;
@@ -1273,14 +1283,23 @@ static void reada_for_search(struct btrfs_root *root,
 		search = btrfs_node_blockptr(node, nr);
 		if ((search <= target && target - search <= 65536) ||
 		    (search > target && search - target <= 65536)) {
-			readahead_tree_block(root, search, blocksize,
-				     btrfs_node_ptr_generation(node, nr));
+			gen = btrfs_node_ptr_generation(node, nr);
+			if (node->map_token) {
+				unmap_extent_buffer(node, node->map_token,
+						    KM_USER1);
+				node->map_token = NULL;
+			}
+			readahead_tree_block(root, search, blocksize, gen);
 			nread += blocksize;
 		}
 		nscan++;
 		if ((nread > 65536 || nscan > 32))
 			break;
 	}
+	if (node->map_token) {
+		unmap_extent_buffer(node, node->map_token, KM_USER1);
+		node->map_token = NULL;
+	}
 }
 
 /*
-- 
1.7.2.3

