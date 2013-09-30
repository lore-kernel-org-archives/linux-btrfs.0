Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47167 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3I3SQh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 14:16:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 19BAF7C0445
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 12:16:37 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id ZIxb3JjGIwcyxizA (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 12:16:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix transid verify errors when recovering log tree
Date: Mon, 30 Sep 2013 14:16:34 -0400
Message-ID: <1380564994-1254-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we crash with a log, remount and recover that log, and then crash before we
can commit another transaction we will get transid verify errors on the next
mount.  This is because we were not zero'ing out the log when we committed the
transaction after recovery.  This is ok as long as we commit another transaction
at some point in the future, but if you abort or something else goes wrong you
can end up in this weird state because the recovery stuff says that the tree log
should have a generation+1 of the super generation, which won't be the case of
the transaction that was started for recovery.  Fix this by removing the check
and _always_ zero out the log portion of the super when we commit a transaction.
This fixes the transid verify issues I was seeing with my force errors tests.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/transaction.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b903192..134039f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1845,11 +1845,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	assert_qgroups_uptodate(trans);
 	update_super_roots(root);
 
-	if (!root->fs_info->log_root_recovering) {
-		btrfs_set_super_log_root(root->fs_info->super_copy, 0);
-		btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
-	}
-
+	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	memcpy(root->fs_info->super_for_commit, root->fs_info->super_copy,
 	       sizeof(*root->fs_info->super_copy));
 
-- 
1.8.3.1

