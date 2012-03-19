From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix btrfs_ioctl_dev_info() crash on missing device
Date: Mon, 19 Mar 2012 16:17:22 +0100
Message-ID: <1332170242-30064-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When a filesystem is mounted with the degraded option, it is
possible that some of the devices are not there.
btrfs_ioctl_dev_info() crashs in this case because the device
name is a NULL pointer. This ioctl was only used for scrub.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6834be4..9b4028b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2188,7 +2188,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->bytes_used = dev->bytes_used;
 	di_args->total_bytes = dev->total_bytes;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	if (dev->name)
+		strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	else
+		di_args->path[0] = '\0';
 
 out:
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
-- 
1.7.3.4

