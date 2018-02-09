Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbeBIJaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 04:30:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6BACACB2
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Feb 2018 09:30:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Move error handling of btrfs_start_dirty_block_groups closer to call site
Date: Fri,  9 Feb 2018 11:30:18 +0200
Message-Id: <1518168618-16708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even though btrfs_start_dirty_block_groups fairly in the beginning of
btrfs_commit_transaction outside of the critical section defined by the
transaction states it can only be run by a single comitter. In other
words it defines its own critical section thanks to the
BTRFS_TRANS_DIRTY_BG run flag and ro_block_group_mutex. However, its
error handling is outside of this critical section which is a bit
counter-intuitive. So move the error handling righ after the function
is executed and let the sole runner of dirty block groups handle the
return value. no functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a57065f022ff..2cdf7be02f41 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2012,12 +2012,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 			run_it = 1;
 		mutex_unlock(&fs_info->ro_block_group_mutex);
 
-		if (run_it)
+		if (run_it) {
 			ret = btrfs_start_dirty_block_groups(trans);
-	}
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
+			if (ret) {
+				btrfs_end_transaction(trans);
+				return ret;
+			}
+		}
 	}
 
 	spin_lock(&fs_info->trans_lock);
-- 
2.7.4

