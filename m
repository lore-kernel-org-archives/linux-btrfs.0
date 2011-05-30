From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: false BUG_ON when degraded
Date: Mon, 30 May 2011 10:36:16 +0200
Message-ID: <1306744576-1609-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In degraded mode the struct btrfs_device of missing devs don't have
device->name set. A kstrdup of NULL correctly returns NULL. Don't
BUG in this case.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c48214e..da541df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -504,7 +504,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		BUG_ON(!new_device);
 		memcpy(new_device, device, sizeof(*new_device));
 		new_device->name = kstrdup(device->name, GFP_NOFS);
-		BUG_ON(!new_device->name);
+		BUG_ON(device->name && !new_device->name);
 		new_device->bdev = NULL;
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
-- 
1.7.3.4

