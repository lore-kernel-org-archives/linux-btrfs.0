Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:59384 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab3FAJpl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jun 2013 05:45:41 -0400
Message-ID: <1370079935.29224.18.camel@localhost.localdomain>
Subject: [PATCH] Btrfs: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:45:35 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3296,10 +3296,7 @@ int btrfs_resume_balance_async(struct bt
 	}
 
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
-	if (IS_ERR(tsk))
-		return PTR_ERR(tsk);
-
-	return 0;
+	return PTR_RET(tsk);
 }
 
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info)


