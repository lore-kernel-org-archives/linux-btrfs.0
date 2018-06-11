Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932317AbeFKTuq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 15:50:46 -0400
Received: from debian3.lan (bl11-80-66.dsl.telepac.pt [85.244.80.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2232086D
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2018 19:50:44 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix return value on rename exchange failure
Date: Mon, 11 Jun 2018 19:24:16 +0100
Message-Id: <20180611182416.18051-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we failed during a rename exchange operation after starting/joining a
transaction, we would end up replacing the return value, stored in the
local 'ret' variable, with the return value from btrfs_end_transaction().
So this could end up returning 0 (success) to user space despite the
operation having failed and aborted the transaction, because if there are
multiple tasks having a reference on the transaction at the time
btrfs_end_transaction() is called by the rename exchange, that function
returns 0 (otherwise it returns -EIO and not the original error value).
So fix this by not overwriting the return value on error after getting
a transaction handle.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 89b208201783..2bb893aa54da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9445,6 +9445,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	u64 new_idx = 0;
 	u64 root_objectid;
 	int ret;
+	int ret2;
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
 
@@ -9641,7 +9642,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 			dest_log_pinned = false;
 		}
 	}
-	ret = btrfs_end_transaction(trans);
+	ret2 = btrfs_end_transaction(trans);
+	ret = ret ? ret : ret2;
 out_notrans:
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
-- 
2.11.0

