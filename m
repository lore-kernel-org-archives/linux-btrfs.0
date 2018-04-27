Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43971 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758653AbeD0QLC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:11:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB626ADF5
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:11:01 +0000 (UTC)
Subject: [PATCH v2] btrfs: qgroup, don't try to insert status item after
 ENOMEM in rescan worker
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-3-jeffm@suse.com>
 <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
 <20180427154425.GB21272@twin.jikos.cz>
 <b688d761-ff7f-2fe8-484d-f29eac58a0b5@suse.com>
Message-ID: <eec3082b-a8e2-1adb-f1f9-27c20a92dbd3@suse.com>
Date: Fri, 27 Apr 2018 12:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <b688d761-ff7f-2fe8-484d-f29eac58a0b5@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail to allocate memory for a path, don't bother trying to
insert the qgroup status item.  We haven't done anything yet and it'll
fail also.  Just print an error and be done with it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/qgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8de423a0c7e3..b795bad54705 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2648,7 +2648,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			btrfs_end_transaction(trans);
 	}
 
-out:
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
@@ -2684,13 +2683,13 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
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


