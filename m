Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:39253 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752296AbdEQKes (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 06:34:48 -0400
From: Sahil Kang <sahil.kang@asilaycomputing.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, sahil.kang@asilaycomputing.com
Subject: [PATCH 1/1] Remove unnecessary branching in free-space-tree.c
Date: Wed, 17 May 2017 03:33:45 -0700
Message-Id: <1495017225-8268-2-git-send-email-sahil.kang@asilaycomputing.com>
In-Reply-To: <1495017225-8268-1-git-send-email-sahil.kang@asilaycomputing.com>
References: <1495017225-8268-1-git-send-email-sahil.kang@asilaycomputing.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both btrfs_create_free_space_tree and btrfs_clear_free_space_tree
contain:

  if (ret)
          return ret;

  return 0;

The if statement is only false when ret equals zero, and since we return
zero in such cases, we can safely remove the branching.

Signed-off-by: Sahil Kang <sahil.kang@asilaycomputing.com>
---
 fs/btrfs/free-space-tree.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 53dbeaf..ac7dcaf 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1185,11 +1185,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	fs_info->creating_free_space_tree = 0;
 
-	ret = btrfs_commit_transaction(trans, tree_root);
-	if (ret)
-		return ret;
-
-	return 0;
+	return btrfs_commit_transaction(trans, tree_root);
 
 abort:
 	fs_info->creating_free_space_tree = 0;
@@ -1273,11 +1269,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	free_extent_buffer(free_space_root->commit_root);
 	kfree(free_space_root);
 
-	ret = btrfs_commit_transaction(trans, tree_root);
-	if (ret)
-		return ret;
-
-	return 0;
+	return btrfs_commit_transaction(trans, tree_root);
 
 abort:
 	btrfs_abort_transaction(trans, tree_root, ret);
-- 
2.1.4

