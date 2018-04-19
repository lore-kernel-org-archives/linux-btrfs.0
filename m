Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55373 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754010AbeDSQgQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DCF9AC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 15/16] btrfs: use mutex in btrfs_resume_balance_async
Date: Thu, 19 Apr 2018 18:33:44 +0200
Message-Id: <a17bb1118ad18ab1b823cfd472dbb57bce6e1e88.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While the spinlock does not cause problems, using the mutex is more
correct and consistent with others. The global status of balance is eg.
checked from btrfs_pause_balance or btrfs_cancel_balance with mutex.

Resuming balance happens during mount or ro->rw remount. In the former
case, no other user of the balance_ctl exists, in the latter, balance
cannot run until the ro/rw transition is finished.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1abe0fc5c105..445380c4ac72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3938,12 +3938,12 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 {
 	struct task_struct *tsk;
 
-	spin_lock(&fs_info->balance_lock);
+	mutex_lock(&fs_info->balance_mutex);
 	if (!fs_info->balance_ctl) {
-		spin_unlock(&fs_info->balance_lock);
+		mutex_unlock(&fs_info->balance_mutex);
 		return 0;
 	}
-	spin_unlock(&fs_info->balance_lock);
+	mutex_unlock(&fs_info->balance_mutex);
 
 	if (btrfs_test_opt(fs_info, SKIP_BALANCE)) {
 		btrfs_info(fs_info, "force skipping balance");
-- 
2.16.2

