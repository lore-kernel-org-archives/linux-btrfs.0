Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaFLFxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 01:53:43 -0400
Message-ID: <53994068.4070708@redhat.com>
Date: Thu, 12 Jun 2014 00:53:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: fix error handling in create_pending_snapshot
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fcebe456 cut and pasted some code to a later point
in create_pending_snapshot(), but didn't switch
to the appropriate error handling for this stage
of the function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I think this is right.  Josef, please double check me :)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9630f10..511839c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1284,11 +1284,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	pending->error = btrfs_qgroup_inherit(trans, fs_info,
-					      root->root_key.objectid,
-					      objectid, pending->inherit);
-	if (pending->error)
-		goto no_free_objectid;
+	ret = btrfs_qgroup_inherit(trans, fs_info,
+				   root->root_key.objectid,
+				   objectid, pending->inherit);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
 
 	/* see comments in should_cow_block() */
 	set_bit(BTRFS_ROOT_FORCE_COW, &root->state);

