Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34730 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945970Ab2JYNbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 09:31:38 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH v2] Btrfs: fix memory leak when cloning root's node
Date: Thu, 25 Oct 2012 21:30:19 +0800
Message-Id: <1351171819-2317-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After cloning root's node, we forgot to dec the src's ref
which can lead to a memory leak.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2: fix a typo.

 fs/btrfs/ctree.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index eba44b0..cdfb4c4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1241,6 +1241,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 {
 	struct tree_mod_elem *tm;
 	struct extent_buffer *eb;
+	struct extent_buffer *old;
 	struct tree_mod_root *old_root = NULL;
 	u64 old_generation = 0;
 	u64 logical;
@@ -1264,13 +1265,14 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_tree_read_unlock(root->node);
 		free_extent_buffer(root->node);
 		blocksize = btrfs_level_size(root, old_root->level);
-		eb = read_tree_block(root, logical, blocksize, 0);
-		if (!eb) {
+		old = read_tree_block(root, logical, blocksize, 0);
+		if (!old) {
 			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
 				logical);
 			WARN_ON(1);
 		} else {
-			eb = btrfs_clone_extent_buffer(eb);
+			eb = btrfs_clone_extent_buffer(old);
+			free_extent_buffer(old);
 		}
 	} else if (old_root) {
 		btrfs_tree_read_unlock(root->node);
-- 
1.7.7.6

