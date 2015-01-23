Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754777AbbAWJdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:33:53 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <miaoxie@huawei.com>
Subject: [PATCH RFC v3 4/5] btrfs: Use btrfs_test_trans_opt() to handle SPACE_CACHE if it's under transaction protect.
Date: Fri, 23 Jan 2015 17:31:44 +0800
Message-ID: <1422005505-9472-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert btrfs_test_opt() to btrfs_test_trans_opt() if it's called under
transaction protection.
This will ensure SPACE_CACHE bit is consistent during transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/transaction.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1511658..c968d12 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3260,7 +3260,7 @@ again:
 
 	spin_lock(&block_group->lock);
 	if (block_group->cached != BTRFS_CACHE_FINISHED ||
-	    !btrfs_test_opt(root, SPACE_CACHE) ||
+	    !btrfs_test_trans_opt(trans, SPACE_CACHE) ||
 	    block_group->delalloc_bytes) {
 		/*
 		 * don't bother trying to write stuff out _if_
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 846e1b8..aec5a5a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1507,7 +1507,8 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void update_super_roots(struct btrfs_root *root)
+static void update_super_roots(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
 {
 	struct btrfs_root_item *root_item;
 	struct btrfs_super_block *super;
@@ -1523,7 +1524,7 @@ static void update_super_roots(struct btrfs_root *root)
 	super->root = root_item->bytenr;
 	super->generation = root_item->generation;
 	super->root_level = root_item->level;
-	if (btrfs_test_opt(root, SPACE_CACHE))
+	if (btrfs_test_trans_opt(trans, SPACE_CACHE))
 		super->cache_generation = root_item->generation;
 	if (root->fs_info->update_uuid_tree_gen)
 		super->uuid_tree_generation = root_item->generation;
@@ -1987,7 +1988,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	switch_commit_roots(cur_trans, root->fs_info);
 
 	assert_qgroups_uptodate(trans);
-	update_super_roots(root);
+	update_super_roots(trans, root);
 
 	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
-- 
2.2.2

