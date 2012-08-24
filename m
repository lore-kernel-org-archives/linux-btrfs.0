Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48757 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2HXSrw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 14:47:52 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id wwoSsNKfeAWfRDQq (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 12:47:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix deadlock with freeze and sync V2
Date: Fri, 24 Aug 2012 14:53:03 -0400
Message-ID: <1345834383-2172-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can deadlock with freeze right now because we unconditionally start a
transaction in our ->sync_fs() call.  To fix this just check and see if we
have a running transaction to commit.  This saves us from the deadlock
because at this point we'll have the umount sem for the sb so we're safe
from freezes coming in after we've done our check.  With this patch the
freeze xfstests no longer deadlocks.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: got a little overzealous and cleaned up the ret thing without actually
removing the now unused ret variable.

 fs/btrfs/super.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7b65fe8..83d6f9f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -838,7 +838,6 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
-	int ret;
 
 	trace_btrfs_sync_fs(wait);
 
@@ -849,11 +848,17 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	trans = btrfs_start_transaction(root, 0);
+	spin_lock(&fs_info->trans_lock);
+	if (!fs_info->running_transaction) {
+		spin_unlock(&fs_info->trans_lock);
+		return 0;
+	}
+	spin_unlock(&fs_info->trans_lock);
+
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	ret = btrfs_commit_transaction(trans, root);
-	return ret;
+	return btrfs_commit_transaction(trans, root);
 }
 
 static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
-- 
1.7.7.6

