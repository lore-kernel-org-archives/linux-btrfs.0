Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753241AbdKXKlh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:41:37 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lakshmipathi.g@gmail.com>
Subject: [PATCH 2/5] btrfs-progs: Add logic to judge the level between parent and child
Date: Fri, 24 Nov 2017 18:41:29 +0800
Message-ID: <1511520092-37101-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following test failed becasuse the level of child node is not
correct. In repair mode, when update parent's ptr in
btrfs_search_slot->btrfs_cow_block->__btrfs_cow_block,
it use path[level+1] to get the parent, and not judge whether
path[level+1] is NULL.

$sudo TEST=003\* make test-fuzz
failed (ignored, ret=139): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-161821.raw.restored
mayfail: returned code 139 (SEGFAULT), not ignored

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 71b15de4..ac0375e5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2085,6 +2085,7 @@ static void reada_walk_down(struct btrfs_root *root,
  *    in parent.
  * 2. block in parent node should match the child node/leaf.
  * 3. generation of parent node and child's header should be consistent.
+ * 4. level of parent node should not smaller than the child node/leaf.
  *
  * Or the child node/leaf pointed by the key in parent is not valid.
  *
@@ -2125,6 +2126,17 @@ static int check_child_node(struct extent_buffer *parent, int slot,
 			btrfs_header_generation(child),
 			btrfs_node_ptr_generation(parent, slot));
 	}
+	/* If level of child is not correct, it will lead to
+	 * Segmentation fault when repair parent.
+	 * Because when update parent's ptr in
+	 * btrfs_search_slot->btrfs_cow_block->__btrfs_cow_block,
+	 * it use path[level+1] to get the parent
+	 */
+	if (btrfs_header_level(parent) <= btrfs_header_level(child)) {
+		ret = -EFAULT;
+		fprintf(stderr, "Wrong level of child node/leaf, wanted: %d, have: %d\n",
+				btrfs_header_level(parent)-1, btrfs_header_level(child));
+	}
 	return ret;
 }
 
@@ -4067,6 +4079,12 @@ static int check_fs_root(struct btrfs_root *root,
 		wret = walk_down_tree(root, &path, wc, &level, &nrefs);
 		if (wret < 0)
 			ret = wret;
+		/* When return value is -EFAULT, it indicate that level
+		 * in path is incorrect. And it will lead to Segmentation fault
+		 * in repair mod.
+		 */
+		if (wret == -EFAULT && repair)
+			goto out;
 		if (wret != 0)
 			break;
 
@@ -4123,6 +4141,7 @@ skip_walking:
 	if (!ret)
 		ret = err;
 
+out:
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
 	free_orphan_data_extents(&root->orphan_data_extents);
-- 
2.14.3



