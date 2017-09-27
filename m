Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52677 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751952AbdI0Ksw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 06:48:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C358AAB22
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 10:48:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Remove unnecessary btrfs_abort_transaction on transaction commit failure
Date: Wed, 27 Sep 2017 13:48:45 +0300
Message-Id: <1506509327-18862-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1506509327-18862-1-git-send-email-nborisov@suse.com>
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_transaction_commit fails it will proceed to call cleanup_transaction,
which in turn already does btrfs_abort_transaction. So let's remove the
unnecessary code duplication.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..585111e055e0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5160,11 +5160,6 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
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

