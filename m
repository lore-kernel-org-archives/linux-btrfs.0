Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34306 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbbIAOLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 10:11:06 -0400
Received: by pabzx8 with SMTP id zx8so178346633pab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 07:11:05 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id bh5sm10669765pbc.5.2015.09.01.07.11.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 01 Sep 2015 07:11:04 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: replace unnecessary list_for_each_entry_safe to list_for_each_entry
Date: Tue,  1 Sep 2015 23:10:57 +0900
Message-Id: <1441116657-57299-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no removing list element while iterating over list.
So, replace list_for_each_entry_safe to list_for_each_entry.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0adf5422fce9..9181e640feab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2699,7 +2699,6 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
-	struct btrfs_device *next;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
 
@@ -2711,7 +2710,7 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	fi_args->num_devices = fs_devices->num_devices;
 	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
-	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->devid > fi_args->max_id)
 			fi_args->max_id = device->devid;
 	}
-- 
2.5.1

