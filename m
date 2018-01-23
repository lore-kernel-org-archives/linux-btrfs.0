Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbeAWMq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 07:46:56 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9DEBDAD11
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 12:46:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use schedule_timeout_interruptible
Date: Tue, 23 Jan 2018 14:46:53 +0200
Message-Id: <1516711613-18533-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of manually fiddling with the state of the task
(RUNNING->INTERRUPTIBLE->RUNNING) again just use schedule_timeout_interruptible
which adjusts the task state as needed. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ed095202942f..f32d81ca1046 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1807,12 +1807,10 @@ static int transaction_kthread(void *arg)
 		if (unlikely(test_bit(BTRFS_FS_STATE_ERROR,
 				      &fs_info->fs_state)))
 			btrfs_cleanup_transaction(fs_info);
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (!kthread_should_stop() &&
 				(!btrfs_transaction_blocked(fs_info) ||
 				 cannot_commit))
-			schedule_timeout(delay);
-		__set_current_state(TASK_RUNNING);
+			schedule_timeout_interruptible(delay);
 	} while (!kthread_should_stop());
 	return 0;
 }
-- 
2.7.4

