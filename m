From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH 1/2] btrfs: ensure null-termination of string copied from userspace
Date: Tue, 21 Feb 2012 00:33:25 +0100
Message-ID: <1329780806-4286-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 fs/btrfs/ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dae5dfe..3dede5c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2121,6 +2121,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->total_bytes = dev->total_bytes;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
 	strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	di_args->path[BTRFS_DEVICE_PATH_NAME_MAX-1] = '\0';
 
 out:
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
-- 
1.7.9

