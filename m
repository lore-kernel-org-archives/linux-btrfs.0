Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61758 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaBTQsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 11:48:17 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so2135403pab.35
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 08:48:16 -0800 (PST)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] btrfs: wake up transaction thread upon remount
Date: Thu, 20 Feb 2014 08:48:07 -0800
Message-Id: <1392914887-5270-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we can adjust the commit interval with a remount, we need
to wake up the transaction thread or else he will continue to sleep
until the previous transaction interval has elapsed before waking
up.  So, if we go from a large commit interval to something smaller,
the transaction thread will not wake up until the large interval has
expired.  This also causes the cleaner thread to stay sleeping, since
it gets woken up by the transaction thread.

Fix it by simply waking up the transaction thread during a remount.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 fs/btrfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d04db81..426b7c6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1479,6 +1479,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		sb->s_flags &= ~MS_RDONLY;
 	}
 out:
+	wake_up_process(fs_info->transaction_kthread);
 	btrfs_remount_cleanup(fs_info, old_opts);
 	return 0;
 
-- 
1.7.9.5

