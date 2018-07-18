Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728491AbeGRHWe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:34 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id A5CC44B5CF57
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 15/19] btrfs: qgroup: Drop root parameter from btrfs_qgroup_trace_subtree
Date: Wed, 18 Jul 2018 14:45:38 +0800
Message-ID: <20180718064542.2730-16-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fs_info can be fetched from the transaction handle directly.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/qgroup.c      | 3 +--
 fs/btrfs/qgroup.h      | 1 -
 fs/btrfs/relocation.c  | 5 ++---
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51da902a0ad7..4f19bdca3214 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8660,7 +8660,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		}
 
 		if (need_account) {
-			ret = btrfs_qgroup_trace_subtree(trans, root, next,
+			ret = btrfs_qgroup_trace_subtree(trans, next,
 							 generation, level - 1);
 			if (ret) {
 				btrfs_err_rl(fs_info,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5cce45c30735..92d757e3a2f5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1715,11 +1715,10 @@ static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
 }
 
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 	int level;
 	struct extent_buffer *eb = root_eb;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 9d434a01d467..b8f15ce6c83d 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -234,7 +234,6 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
  * Return <0 for error(ENOMEM or tree search error)
  */
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level);
 int
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b98d7a594542..d6bcf558789e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1879,13 +1879,12 @@ int replace_path(struct btrfs_trans_handle *trans,
 		 *    and tree block numbers, if current trans doesn't free
 		 *    data reloc tree inode.
 		 */
-		ret = btrfs_qgroup_trace_subtree(trans, src, parent,
+		ret = btrfs_qgroup_trace_subtree(trans, parent,
 				btrfs_header_generation(parent),
 				btrfs_header_level(parent));
 		if (ret < 0)
 			break;
-		ret = btrfs_qgroup_trace_subtree(trans, dest,
-				path->nodes[level],
+		ret = btrfs_qgroup_trace_subtree(trans, path->nodes[level],
 				btrfs_header_generation(path->nodes[level]),
 				btrfs_header_level(path->nodes[level]));
 		if (ret < 0)
-- 
2.18.0



