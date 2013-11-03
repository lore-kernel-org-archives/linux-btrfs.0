Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61551 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3KCRHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 12:07:21 -0500
Received: by mail-ee0-f41.google.com with SMTP id e53so681517eek.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 09:07:20 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 3/3] Btrfs: fix __btrfs_start_workers retval
Date: Sun,  3 Nov 2013 19:06:40 +0200
Message-Id: <1383498400-21009-3-git-send-email-idryomov@gmail.com>
In-Reply-To: <1383498400-21009-1-git-send-email-idryomov@gmail.com>
References: <1383498400-21009-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_start_workers returns 0 in case it raced with
btrfs_stop_workers and lost the race.  This is wrong because worker in
this case is not allowed to start and is in fact destroyed.  Return
-EINVAL instead.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/async-thread.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 08cc08f..1d5f3d7 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -495,6 +495,7 @@ static int __btrfs_start_workers(struct btrfs_workers *workers)
 	spin_lock_irq(&workers->lock);
 	if (workers->stopping) {
 		spin_unlock_irq(&workers->lock);
+		ret = -EINVAL;
 		goto fail_kthread;
 	}
 	list_add_tail(&worker->worker_list, &workers->idle_list);
-- 
1.7.10.4

