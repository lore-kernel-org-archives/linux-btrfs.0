From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH 2/2] btrfs: handle dev info ioctl on degraded mount
Date: Tue, 21 Feb 2012 00:33:26 +0100
Message-ID: <1329780806-4286-2-git-send-email-kario@wit.edu.pl>
References: <1329780806-4286-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329780806-4286-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 fs/btrfs/ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3dede5c..d536816 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2120,7 +2120,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->bytes_used = dev->bytes_used;
 	di_args->total_bytes = dev->total_bytes;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	if (dev->name)
+		strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	else
+		di_args->path[0] = '\0';
 	di_args->path[BTRFS_DEVICE_PATH_NAME_MAX-1] = '\0';
 
 out:
-- 
1.7.9

