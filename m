Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45959 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752102AbdI1Ipb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 04:45:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3FDE8AAB9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 08:45:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/2] btrfs: Refactor transaction handling
Date: Thu, 28 Sep 2017 11:45:26 +0300
Message-Id: <1506588327-6616-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1506509327-18862-1-git-send-email-nborisov@suse.com>
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_transaction_commit fails it will proceed to call cleanup_transaction,
which in turn already does btrfs_abort_transaction. So let's remove the
unnecessary code duplication. Also let's be explicit about handling failure
of btrfs_uuid_tree_add by calling btrfs_end_transaction.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

v2:
 * Collapse previous 1/3 and 2/3 into a single patch
 * Add the btrfs_end_transaction() call 

 fs/btrfs/ioctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..21f14f755f86 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5156,15 +5156,12 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 					  root->root_key.objectid);
 		if (ret < 0 && ret != -EEXIST) {
 			btrfs_abort_transaction(trans, ret);
+			btrfs_end_transaction(trans);
 			goto out;
+
 		}
 	}
 	ret = btrfs_commit_transaction(trans);
-	if (ret < 0) {
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
-
 out:
 	up_write(&fs_info->subvol_sem);
 	mnt_drop_write_file(file);
-- 
2.7.4

