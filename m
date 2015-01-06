Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13782 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbbAFJar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jan 2015 04:30:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t069UDBg016362
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Jan 2015 17:30:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Fix a buffer overflow causing segfault in fstests/btrfs/069
Date: Tue, 6 Jan 2015 17:30:44 +0800
Message-ID: <1420536644-12152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The newly introduced search_chunk_tree_for_fs_info() won't count devid 0
in fi_arg->num_devices, which will cause buffer overflow since later
get_device_info() will fill di_args with devid.

This can be trigger by fstests/btrfs/069 and any operations needs to
iterate over all the devices like 'fi show' or 'dev stat' while
replacing.

The fix is do an extra probe specifically for devid 0 after
search_chunk_tree_for_fs_info() and change num_devices if needed.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/utils.c b/utils.c
index af0a8fe..6581568 100644
--- a/utils.c
+++ b/utils.c
@@ -1934,8 +1934,10 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	int ret = 0;
 	int ndevs = 0;
 	int i = 0;
+	int replacing = 0;
 	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct btrfs_ioctl_dev_info_args *di_args;
+	struct btrfs_ioctl_dev_info_args tmp;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	DIR *dirstream = NULL;
 
@@ -2003,6 +2005,19 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		ret = search_chunk_tree_for_fs_info(fd, fi_args);
 		if (ret)
 			goto out;
+
+		/*
+		 * search_chunk_tree_for_fs_info() will lacks the devid 0
+		 * so manual probe for it here.
+		 */
+		ret = get_device_info(fd, 0, &tmp);
+		if (!ret) {
+			fi_args->num_devices++;
+			ndevs++;
+			replacing = 1;
+			if (i == 0)
+				i++;
+		}
 	}
 
 	if (!fi_args->num_devices)
@@ -2014,6 +2029,8 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		goto out;
 	}
 
+	if (replacing)
+		memcpy(di_args, &tmp, sizeof(tmp));
 	for (; i <= fi_args->max_id; ++i) {
 		ret = get_device_info(fd, i, &di_args[ndevs]);
 		if (ret == -ENODEV)
-- 
2.2.1

