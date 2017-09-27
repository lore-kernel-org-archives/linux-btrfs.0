Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751973AbdI0Ksx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 06:48:53 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EE7BABAF
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 10:48:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Handle failure to add to add received uuid to uuid tree in _btrfs_ioctl_set_received_subvol
Date: Wed, 27 Sep 2017 13:48:46 +0300
Message-Id: <1506509327-18862-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1506509327-18862-1-git-send-email-nborisov@suse.com>
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case we failed the btrfs_uuid_tree_add we want to abort and end the transaction,
currently the code only does btrfs_abort_transaction and then bails out without
calling either btrfs_transaction_commit (which handles the aborted case) or
btrfs_end_transaction. Fix it by eliminating the wrong label jump

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 585111e055e0..7cfc68170e65 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5154,10 +5154,8 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		ret = btrfs_uuid_tree_add(trans, fs_info, sa->uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  root->root_key.objectid);
-		if (ret < 0 && ret != -EEXIST) {
+		if (ret < 0 && ret != -EEXIST)
 			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
 	}
 	ret = btrfs_commit_transaction(trans);
 out:
-- 
2.7.4

