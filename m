Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:51323 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3DQJLv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 05:11:51 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.27 OK)
	with ESMTP id 6003dap3GCh0xg for <linux-btrfs@vger.kernel.org>;
	Wed, 17 Apr 2013 11:11:47 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: clear received_uuid field for new writable snapshots
Date: Wed, 17 Apr 2013 11:11:47 +0200
Message-Id: <1366189907-16942-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For created snapshots, the full root_item is copied from the source
root and afterwards selectively modified. The current code forgets
to clear the field received_uuid. The only problem is that it is
confusing when you look at it with 'btrfs subv list', since for
writable snapshots, the contents of the snapshot can be completely
unrelated to the previously received snapshot.
The receiver ignores such snapshots anyway because he also checks
the field stransid in the root_item and that value used to be reset
to zero for all created snapshots.

This commit changes two things:
- clear the received_uuid field for new writable snapshots.
- don't clear the send/receive related information like the stransid
  for read-only snapshots (which makes them useable as a parent for
  the automatic selection of parents in the receive code).

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/transaction.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ffac232..94cbd10 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1170,13 +1170,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
 	memcpy(new_root_item->parent_uuid, root->root_item.uuid,
 			BTRFS_UUID_SIZE);
+	if (!(root_flags & BTRFS_ROOT_SUBVOL_RDONLY)) {
+		memset(new_root_item->received_uuid, 0,
+		       sizeof(new_root_item->received_uuid));
+		memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
+		memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
+		btrfs_set_root_stransid(new_root_item, 0);
+		btrfs_set_root_rtransid(new_root_item, 0);
+	}
 	new_root_item->otime.sec = cpu_to_le64(cur_time.tv_sec);
 	new_root_item->otime.nsec = cpu_to_le32(cur_time.tv_nsec);
 	btrfs_set_root_otransid(new_root_item, trans->transid);
-	memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
-	memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
-	btrfs_set_root_stransid(new_root_item, 0);
-	btrfs_set_root_rtransid(new_root_item, 0);
 
 	old = btrfs_lock_root_node(root);
 	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
-- 
1.8.2.1

