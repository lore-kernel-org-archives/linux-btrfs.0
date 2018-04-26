Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752826AbeDZTX4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:23:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6AEF2AE14
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 19:23:55 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] btrfs: qgroup, don't try to insert status item after ENOMEM in rescan worker
Date: Thu, 26 Apr 2018 15:23:51 -0400
Message-Id: <20180426192351.473-3-jeffm@suse.com>
In-Reply-To: <20180426192351.473-1-jeffm@suse.com>
References: <20180426192351.473-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If we fail to allocate memory for a path, don't bother trying to
insert the qgroup status item.  We haven't done anything yet and it'll
fail also.  Just print an error and be done with it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8de423a0c7e3..4c0978bce5b9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2648,7 +2648,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			btrfs_end_transaction(trans);
 	}
 
-out:
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
@@ -2688,6 +2687,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			err > 0 ? " (inconsistency flag cleared)" : "");
 	} else {
+out:
 		btrfs_err(fs_info, "qgroup scan failed with %d", err);
 	}
 
-- 
2.12.3

