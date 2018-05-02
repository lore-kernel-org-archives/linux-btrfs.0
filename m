Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbeEBVMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 17:12:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E8D5ADDC
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 21:12:05 +0000 (UTC)
From: jeffm@suse.com
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs: qgroups, remove unnecessary memset before btrfs_init_work
Date: Wed,  2 May 2018 17:11:55 -0400
Message-Id: <20180502211156.9460-3-jeffm@suse.com>
In-Reply-To: <20180502211156.9460-1-jeffm@suse.com>
References: <20180502211156.9460-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_init_work clears the work struct except for ->wq, so the memset
before calling btrfs_init_work in qgroup_rescan_init is unnecessary.

We'll also initialize ->wq in btrfs_init_work so that it's obvious.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c | 1 +
 fs/btrfs/qgroup.c       | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d5540749f0e5..c614fb7b9b9d 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -354,6 +354,7 @@ void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t uniq_func,
 	INIT_WORK(&work->normal_work, uniq_func);
 	INIT_LIST_HEAD(&work->ordered_list);
 	work->flags = 0;
+	work->wq = NULL;
 }
 
 static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 466744741873..3d47700c6a30 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2102,9 +2102,6 @@ static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
 	init_completion(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	memset(&fs_info->qgroup_rescan_work, 0,
-	       sizeof(fs_info->qgroup_rescan_work));
-
 	btrfs_init_work(&fs_info->qgroup_rescan_work,
 			btrfs_qgroup_rescan_helper,
 			btrfs_qgroup_rescan_worker, NULL, NULL);
-- 
2.12.3

