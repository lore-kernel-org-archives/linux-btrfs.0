Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:48159 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3CFI6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 03:58:01 -0500
Received: by mail-la0-f52.google.com with SMTP id fs12so7176424lab.11
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2013 00:57:59 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        idryomov@gmail.com
Subject: [PATCH] Btrfs: fix a mismerge in btrfs_balance()
Date: Wed,  6 Mar 2013 10:57:55 +0200
Message-Id: <1362560275-3223-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid56 merge (merge commit e942f88) had mistakenly removed a call to
__cancel_balance(), which resulted in balance not cleaning up after itself
after a successful finish.  (Cleanup includes switching the state, removing
the balance item and releasing mut_ex_op testnset lock.)  Bring it back.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 35bb2d4..33440da 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3230,6 +3230,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		update_ioctl_balance_args(fs_info, 0, bargs);
 	}
 
+	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
+	    balance_need_close(fs_info)) {
+		__cancel_balance(fs_info);
+	}
+
 	wake_up(&fs_info->balance_wait_q);
 
 	return ret;
-- 
1.7.9.1

