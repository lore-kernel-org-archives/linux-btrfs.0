Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42512 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab3GOP7h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 11:59:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A1DBD7C067F
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 09:59:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <alex.btrfs@zadarastorage.com>,
        <dsterba@suse.cz>
Subject: [PATCH] Btrfs: update drop progress before stopping snapshot dropping
Date: Mon, 15 Jul 2013 11:59:33 -0400
Message-ID: <1373903973-2904-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alex pointed out a problem and fix that exists in the drop one snapshot at a
time patch.  If we decide we need to exit for whatever reason (umount for
example) we will just exit the snapshot dropping without updating the drop
progress.  So the next time we go to resume we will BUG_ON() because we can't
find the extent we left off at because we never updated it.  This patch fixes
the problem.

Cc: stable@vger.kernel.org
Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bc00b24..8c204e1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7584,11 +7584,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
-		if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
-			pr_debug("btrfs: drop snapshot early exit\n");
-			err = -EAGAIN;
-			goto out_end_trans;
-		}
 
 		ret = walk_down_tree(trans, root, path, wc);
 		if (ret < 0) {
@@ -7616,7 +7611,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		}
 
 		BUG_ON(wc->level == 0);
-		if (btrfs_should_end_transaction(trans, tree_root)) {
+		if (btrfs_should_end_transaction(trans, tree_root) ||
+		    (!for_reloc && btrfs_need_cleaner_sleep(root))) {
 			ret = btrfs_update_root(trans, tree_root,
 						&root->root_key,
 						root_item);
@@ -7627,6 +7623,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 			}
 
 			btrfs_end_transaction_throttle(trans, tree_root);
+			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
+				pr_debug("btrfs: drop snapshot early exit\n");
+				err = -EAGAIN;
+				goto out_free;
+			}
+
 			trans = btrfs_start_transaction(tree_root, 0);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
-- 
1.7.7.6

