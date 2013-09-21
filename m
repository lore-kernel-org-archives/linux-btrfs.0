Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33113 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3IUC0c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 22:26:32 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 04E829A068A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:26:32 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 9mhsA1ivL1PsUexJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:26:31 -0600 (MDT)
Date: Fri, 20 Sep 2013 22:26:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: reset intwrite on transaction abort
Message-ID: <20130921022629.GC5672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we abort a transaction in the middle of a commit we weren't undoing the
intwrite locking.  This patch fixes that problem.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e7a9535..2fa7017 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1552,6 +1552,8 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 		root->fs_info->running_transaction = NULL;
 	spin_unlock(&root->fs_info->trans_lock);
 
+	if (trans->type & __TRANS_FREEZABLE)
+		sb_end_intwrite(root->fs_info->sb);
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
-- 
1.8.3.1

