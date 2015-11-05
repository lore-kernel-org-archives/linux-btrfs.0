Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031875AbbKEKih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 05:38:37 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix race waiting for qgroup rescan worker
Date: Thu,  5 Nov 2015 10:38:30 +0000
Message-Id: <1446719910-7636-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were initializing the completion (fs_info->qgroup_rescan_completion)
object after releasing the qgroup rescan lock, which gives a small time
window for a rescan waiter to not actually wait for the rescan worker
to finish. Example:

         CPU 1                                                     CPU 2

 fs_info->qgroup_rescan_completion->done is 0

 btrfs_qgroup_rescan_worker()
   complete_all(&fs_info->qgroup_rescan_completion)
     sets fs_info->qgroup_rescan_completion->done
     to UINT_MAX / 2

 ... do some other stuff ....

 qgroup_rescan_init()
   mutex_lock(&fs_info->qgroup_rescan_lock)
   set flag BTRFS_QGROUP_STATUS_FLAG_RESCAN
     in fs_info->qgroup_flags
   mutex_unlock(&fs_info->qgroup_rescan_lock)

                                                       btrfs_qgroup_wait_for_completion()
                                                         mutex_lock(&fs_info->qgroup_rescan_lock)
                                                         sees flag BTRFS_QGROUP_STATUS_FLAG_RESCAN
                                                           in fs_info->qgroup_flags
                                                         mutex_unlock(&fs_info->qgroup_rescan_lock)

                                                         wait_for_completion_interruptible(
                                                           &fs_info->qgroup_rescan_completion)

                                                           fs_info->qgroup_rescan_completion->done
                                                           is > 0 so it returns immediately

  init_completion(&fs_info->qgroup_rescan_completion)
    sets fs_info->qgroup_rescan_completion->done to 0

So fix this by initializing the completion object while holding the mutex
fs_info->qgroup_rescan_lock.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 75c0249..75bb4af9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2387,12 +2387,11 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 	memset(&fs_info->qgroup_rescan_progress, 0,
 		sizeof(fs_info->qgroup_rescan_progress));
 	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
+	init_completion(&fs_info->qgroup_rescan_completion);
 
 	spin_unlock(&fs_info->qgroup_lock);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	init_completion(&fs_info->qgroup_rescan_completion);
-
 	memset(&fs_info->qgroup_rescan_work, 0,
 	       sizeof(fs_info->qgroup_rescan_work));
 	btrfs_init_work(&fs_info->qgroup_rescan_work,
-- 
2.1.3

