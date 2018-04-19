Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753903AbeDSQf6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:35:58 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D99FDAC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:35:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 07/16] btrfs: add proper safety check before resuming dev-replace
Date: Thu, 19 Apr 2018 18:33:25 +0200
Message-Id: <4ebe1fce5a33a3698619e58912418f53b121a131.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The device replace is paused by unmount or read only remount, and
resumed on next mount or write remount.

The exclusive status should be checked properly as it's a global
invariant and we must not allow 2 operations run. In this case, the
balance can be also paused and resumed under same conditions. It's
always checked first so dev-replace could see the EXCL_OP already taken,
BUT, the ioctl would never let start both at the same time.

Replace the WARN_ON with message and return 0, indicating no error as
this is purely theoretical and the user will be informed. Resolving that
manually should be possible by waiting for the other operation to finish
or cancel the paused state.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7a87ffad041e..346bd460f8e7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -908,7 +908,17 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	}
 	btrfs_dev_replace_write_unlock(dev_replace);
 
-	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
+	/*
+	 * This could collide with a paused balance, but the exclusive op logic
+	 * should never allow both to start and pause. We don't want to allow
+	 * dev-replace to start anyway.
+	 */
+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
+		btrfs_info(fs_info,
+		"cannot resume dev-replace, other exclusive operation running");
+		return 0;
+	}
+
 	task = kthread_run(btrfs_dev_replace_kthread, fs_info, "btrfs-devrepl");
 	return PTR_ERR_OR_ZERO(task);
 }
-- 
2.16.2

