Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50045 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab3JGOqP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 10:46:15 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 539767C0686
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 08:46:15 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id v53eTAKEeixgpuvD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 08:46:14 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not free the dirty bytes from the trans block rsv on cleanup
Date: Mon, 7 Oct 2013 10:46:12 -0400
Message-ID: <1381157172-5829-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transactions should be cleaning up their reservations on failure, this just
causes us to have warnings on unmount because we go negative by free'ing
reservations that have already been free'ed.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d205bdd..fdc75ab 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4046,8 +4046,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	btrfs_destroy_ordered_operations(cur_trans, root);
 
 	btrfs_destroy_delayed_refs(cur_trans, root);
-	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
-				cur_trans->dirty_pages.dirty_bytes);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&root->fs_info->transaction_blocked_wait);
-- 
1.8.3.1

