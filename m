Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:37535 "EHLO
	19.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbcBVKSP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 05:18:15 -0500
Received: from mail690.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id B2833FFBDC3
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 11:18:13 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH 1/3] Btrfs: disk-io: fixed a brace coding style issue
Date: Mon, 22 Feb 2016 11:18:06 +0100
Message-Id: <1456136288-4718-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixed a coding style issue.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/disk-io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4545e2e..84cbf16 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1908,11 +1908,11 @@ static int transaction_kthread(void *arg)
 				cannot_commit = true;
 			goto sleep;
 		}
-		if (transid == trans->transid) {
+		if (transid == trans->transid)
 			btrfs_commit_transaction(trans, root);
-		} else {
+		else
 			btrfs_end_transaction(trans, root);
-		}
+
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
@@ -1978,11 +1978,11 @@ static void find_oldest_super_backup(struct btrfs_fs_info *info,
 
 	newest_index = find_newest_super_backup(info, newest_gen);
 	/* if there was garbage in there, just move along */
-	if (newest_index == -1) {
+	if (newest_index == -1)
 		info->backup_root_index = 0;
-	} else {
+	else
 		info->backup_root_index = (newest_index + 1) % BTRFS_NUM_BACKUP_ROOTS;
-	}
+
 }
 
 /*
-- 
2.7.1

