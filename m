Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55293 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753948AbeDSQgA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AF12AC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:35:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 08/16] btrfs: add sanity check when resuming balance after mount
Date: Thu, 19 Apr 2018 18:33:28 +0200
Message-Id: <32c7579ceb072a870ec8a2e4f0348cfb37bd61d5.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace a WARN_ON with a proper check and message in case something goes
really wrong and resumed balance cannot set up its exclusive status.
The check is a user friendly assertion, I don't expect to ever happen
under normal circumstances.

Also document that the paused balance starts here and owns the exclusive
op status.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5c83ebc8e199..83fbe9d624f5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4018,7 +4018,19 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	btrfs_balance_sys(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
 
-	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
+	/*
+	 * This should never happen, as the paused balance state is recovered
+	 * during mount without any chance of other exclusive ops to collide.
+	 *
+	 * This gives the exclusive op status to balance and keeps in paused
+	 * state until user intervention (cancel or umount). If the ownership
+	 * cannot be assigned, show a message but do not fail. The balance
+	 * is in a paused state and must have fs_info::balance_ctl properly
+	 * set up.
+	 */
+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
+		btrfs_warn(fs_info,
+	"cannot set exclusive op status to balance, resume manually");
 
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
-- 
2.16.2

