Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeCOOAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 10:00:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31FE0AFE8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:00:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Drop fs_info parameter from btrfs_qgroup_account_extents
Date: Thu, 15 Mar 2018 16:00:25 +0200
Message-Id: <1521122427-25062-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521122427-25062-1-git-send-email-nborisov@suse.com>
References: <1521122427-25062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/qgroup.c      | 6 +++---
 fs/btrfs/qgroup.h      | 3 +--
 fs/btrfs/transaction.c | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0fa4f07b80b8..2e1da7a44478 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2014,9 +2014,9 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info)
+int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_qgroup_extent_record *record;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct ulist *new_roots = NULL;
@@ -2945,7 +2945,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d9984e87cddf..ad003483d20c 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -220,8 +220,7 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
 			    u64 bytenr, u64 num_bytes,
 			    struct ulist *old_roots, struct ulist *new_roots);
-int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info);
+int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9913aa9f3a25..0a582a1adaf3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1369,7 +1369,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans);
 	if (ret)
 		goto out;
-	ret = btrfs_qgroup_account_extents(trans, fs_info);
+	ret = btrfs_qgroup_account_extents(trans);
 	if (ret < 0)
 		goto out;
 
@@ -2189,7 +2189,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * Since fs roots are all committed, we can get a quite accurate
 	 * new_roots. So let's do quota accounting.
 	 */
-	ret = btrfs_qgroup_account_extents(trans, fs_info);
+	ret = btrfs_qgroup_account_extents(trans);
 	if (ret < 0) {
 		mutex_unlock(&fs_info->tree_log_mutex);
 		mutex_unlock(&fs_info->reloc_mutex);
-- 
2.7.4

