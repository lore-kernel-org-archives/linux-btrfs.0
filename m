Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37789 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3DXUu4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 958E39A068E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:50:56 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 4ZNwrxRP31E3TW9x (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:50:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check return value of commit when recovering log
Date: Wed, 24 Apr 2013 16:50:54 -0400
Message-ID: <1366836654-2065-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to check the return value of the commit in case something goes wrong,
otherwise we could end up going down the line and doing more stuff (like orphan
cleanup) before we notice we should have errored out.  We need to do this before
we free up the log_tree_root since the caller will handle all of that.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1fdc221..f50137a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4012,16 +4012,17 @@ again:
 
 	btrfs_free_path(path);
 
+	/* step 4: commit the transaction, which also unpins the blocks */
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret)
+		return ret;
+
 	free_extent_buffer(log_root_tree->node);
 	log_root_tree->log_root = NULL;
 	fs_info->log_root_recovering = 0;
-
-	/* step 4: commit the transaction, which also unpins the blocks */
-	btrfs_commit_transaction(trans, fs_info->tree_root);
-
 	kfree(log_root_tree);
-	return 0;
 
+	return 0;
 error:
 	btrfs_free_path(path);
 	return ret;
-- 
1.7.7.6

