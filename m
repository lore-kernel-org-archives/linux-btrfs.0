Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44527 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbeEBVMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 17:12:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E402ADD5
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 21:12:05 +0000 (UTC)
From: jeffm@suse.com
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] btrfs: qgroup, don't try to insert status item after ENOMEM in rescan worker
Date: Wed,  2 May 2018 17:11:56 -0400
Message-Id: <20180502211156.9460-4-jeffm@suse.com>
In-Reply-To: <20180502211156.9460-1-jeffm@suse.com>
References: <20180502211156.9460-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If we fail to allocate memory for a path, don't bother trying to
insert the qgroup status item.  We haven't done anything yet and it'll
fail also.  Just print an error and be done with it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/qgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3d47700c6a30..44d5e3da835a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2666,7 +2666,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			btrfs_end_transaction(trans);
 	}
 
-out:
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
@@ -2702,13 +2701,13 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 	if (btrfs_fs_closing(fs_info)) {
 		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (err >= 0) {
+		err = 0;
+	} else if (err >= 0)
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			err > 0 ? " (inconsistency flag cleared)" : "");
-	} else {
+out:
+	if (err < 0)
 		btrfs_err(fs_info, "qgroup scan failed with %d", err);
-	}
-
 done:
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	fs_info->qgroup_rescan_running = false;
-- 
2.12.3

