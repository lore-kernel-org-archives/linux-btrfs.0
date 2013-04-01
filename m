Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48444 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3DAP1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 11:27:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 644697C0425
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 09:27:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id pU5u3pSeA5PxI5Kb (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 09:27:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix infinite loop when we abort on mount
Date: Mon, 1 Apr 2013 11:27:16 -0400
Message-ID: <1364830036-1939-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Testing my enospc log code I managed to abort a transaction during mount, which
put me into an infinite loop.  This is because of two things, first we don't
reset trans_no_join if we abort during transaction commit, which will force
anybody trying to start a transaction to just loop endlessly waiting for it to
be set to 0.  But this is still just a symptom, the second issue is we don't set
the fs state to error during errors on mount.  This is because we don't want to
do the flip read only thing during mount, but we still really want to set the fs
state to an error to keep us from even getting to the trans_no_join check.  So
fix both of these things, make sure to reset trans_no_join if we abort during a
commit, and make sure we set the fs state to error no matter if we're mounting
or not.  This should keep us from getting into this infinite loop again.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c       |    5 ++---
 fs/btrfs/transaction.c |    4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 984816f..d13d6b2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -161,10 +161,9 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	}
 
 	/* Don't go through full error handling during mount */
-	if (sb->s_flags & MS_BORN) {
-		save_error_info(fs_info);
+	save_error_info(fs_info);
+	if (sb->s_flags & MS_BORN)
 		btrfs_handle_error(fs_info);
-	}
 }
 
 static const char * const logtypes[] = {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 37f509f..e660ac0b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1488,6 +1488,10 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 		current->journal_info = NULL;
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+
+	spin_lock(&root->fs_info->trans_lock);
+	root->fs_info->trans_no_join = 0;
+	spin_unlock(&root->fs_info->trans_lock);
 }
 
 static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

