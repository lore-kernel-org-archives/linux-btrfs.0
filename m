Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58070 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645Ab2HXSlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 14:41:20 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id NWBICmKmu5dPF2No (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 12:41:19 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix deadlock with freeze and sync
Date: Fri, 24 Aug 2012 14:46:31 -0400
Message-ID: <1345833991-1601-1-git-send-email-jbacik@fusionio.com>
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
 fs/btrfs/super.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7b65fe8..950accc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -849,11 +849,17 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
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

