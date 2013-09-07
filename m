Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43348 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3IGQQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Sep 2013 12:16:18 -0400
From: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Azat Khuzhin <a3at.mail@gmail.com>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH] Btrfs: cleanup redundant code in __btrfs_close_devices()
Date: Sat,  7 Sep 2013 20:15:11 +0400
Message-Id: <1378570511-20990-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1d1b595..124228e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -644,7 +644,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		/* Safe because we are under uuid_mutex */
 		if (device->name) {
 			name = rcu_string_strdup(device->name->str, GFP_NOFS);
-			BUG_ON(device->name && !name); /* -ENOMEM */
+			BUG_ON(!name); /* -ENOMEM */
 			rcu_assign_pointer(new_device->name, name);
 		}
 		new_device->bdev = NULL;
-- 
1.7.10.4

