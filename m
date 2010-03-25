From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 15/18] btrfs: cleanup redundant code in btrfs_search_forward()
Date: Thu, 25 Mar 2010 20:36:42 +0800
Message-ID: <4BAB58DA.90904@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

ret in btrfs_search_forward() has been set to 1, so it is unnecessary to
set it to 1 again when some error happens.

Cleanup these redundant code.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4f258ba..e466add 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3995,10 +3995,9 @@ again:
 	path->nodes[level] = cur;
 	path->locks[level] = 1;
 
-	if (btrfs_header_generation(cur) < min_trans) {
-		ret = 1;
+	if (btrfs_header_generation(cur) < min_trans)
 		goto out;
-	}
+
 	while (1) {
 		nritems = btrfs_header_nritems(cur);
 		level = btrfs_header_level(cur);
@@ -4037,10 +4036,8 @@ again:
 
 			if (max_key) {
 				btrfs_node_key(cur, &disk_key, slot);
-				if (comp_keys(&disk_key, max_key) >= 0) {
-					ret = 1;
+				if (comp_keys(&disk_key, max_key) >= 0)
 					goto out;
-				}
 			}
 
 			tmp = btrfs_find_tree_block(root, blockptr,
@@ -4067,9 +4064,8 @@ find_next_key:
 			if (sret == 0) {
 				btrfs_release_path(root, path);
 				goto again;
-			} else {
+			} else
 				goto out;
-			}
 		}
 		/* save our key for returning back */
 		btrfs_node_key_to_cpu(cur, &found_key, slot);
-- 
1.6.5.2


