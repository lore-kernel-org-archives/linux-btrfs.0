Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:57038 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932520Ab3CDVkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/14] btrfs-progs: don't leak fd in get_fs_info
Date: Mon,  4 Mar 2013 16:39:54 -0600
Message-Id: <1362436804-16766-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we discover that a passed-in fd is not a mountpoint,
we determine whether it is a device, and issue another
open() against the device's mount point if it is mounted.

If we do so, ensure this 2nd fd gets closed before we return
so that it does not leak, by consolidating error returns.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/utils.c b/utils.c
index 1813dda..54d577c 100644
--- a/utils.c
+++ b/utils.c
@@ -1462,6 +1462,7 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret)
 {
 	int ret = 0;
+	int fd2 = -1;
 	int ndevs = 0;
 	int i = 1;
 	struct btrfs_fs_devices *fs_devices_mnt = NULL;
@@ -1484,19 +1485,22 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		i = fs_devices_mnt->latest_devid;
 		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
 		close(fd);
-		fd = open_file_or_dir(mp);
-		if (fd < 0)
+		fd2 = open_file_or_dir(mp);
+		if (fd2 < 0)
 			return -errno;
+		fd = fd2;
 	} else if (ret) {
 		return -errno;
 	}
 
 	if (!fi_args->num_devices)
-		return 0;
+		goto out;
 
 	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
-	if (!di_args)
-		return -errno;
+	if (!di_args) {
+		ret = -errno;
+		goto out;
+	}
 
 	for (; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
@@ -1504,13 +1508,16 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		if (ret == -ENODEV)
 			continue;
 		if (ret)
-			return ret;
+			goto out;
 		ndevs++;
 	}
 
 	BUG_ON(ndevs == 0);
 
-	return 0;
+out:
+	if (fd2 != -1)
+		close(fd2);
+	return ret;
 }
 
 #define isoctal(c)	(((c) & ~7) == '0')
-- 
1.7.1

