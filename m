Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbeCOOAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 10:00:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD228AFCD
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:00:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Drop fs_info parameter from __btrfs_run_delayed_refs
Date: Thu, 15 Mar 2018 16:00:27 +0200
Message-Id: <1521122427-25062-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1521122427-25062-1-git-send-email-nborisov@suse.com>
References: <1521122427-25062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by trans handle

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71d59ec02f08..89d640cb313e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2650,9 +2650,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
  */
 static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
-					     struct btrfs_fs_info *fs_info,
 					     unsigned long nr)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *locked_ref = NULL;
@@ -3077,7 +3077,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
 #endif
 	trans->can_flush_pending_bgs = false;
-	ret = __btrfs_run_delayed_refs(trans, fs_info, count);
+	ret = __btrfs_run_delayed_refs(trans, count);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
 		return ret;
-- 
2.7.4

