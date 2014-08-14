Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31426 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaHNEeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 00:34:15 -0400
Message-ID: <53EC3D01.1030502@oracle.com>
Date: Thu, 14 Aug 2014 12:37:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: bug adding device to seed device, btrfs fi show fails
References: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com> <53702B42.8040806@oracle.com> <5371E1E5.1030909@cn.fujitsu.com> <91408049-2586-446C-BD11-D3E33A5ECD27@colorremedies.com>
In-Reply-To: <91408049-2586-446C-BD11-D3E33A5ECD27@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Chris,

For the seed replace issues. you have to try this patch set.
Thanks.
  https://patchwork.kernel.org/patch/4716371/

Next, for the failing 'btrfs fi show' issue the following diff
is the latest. The last attempt was ..
  [PATCH] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO 
miss-matched with slots

However as Wang mentioned we would need to show both seed and
sprout together, to make sense to the user.

So I have the following fix. which will soon be sent out
when tests are completed.


kernel:
-------------
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da73ab3..05dd88b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2725,7 +2725,7 @@ static long btrfs_ioctl_fs_info(struct btrfs_root 
*root, void __user *arg)
                 return -ENOMEM;

         mutex_lock(&fs_devices->device_list_mutex);
-       fi_args->num_devices = fs_devices->num_devices;
+       fi_args->num_devices = fs_devices->total_devices;
         memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));

         list_for_each_entry_safe(device, next, &fs_devices->devices, 
dev_list) {
----------------


btrfs-progs:
----------------
diff --git a/utils.c b/utils.c
index 8bdc2a7..fa837b9 100644
--- a/utils.c
+++ b/utils.c
@@ -1929,12 +1929,29 @@ int get_fs_info(char *path, struct 
btrfs_ioctl_fs_info_args *fi_args,
         if (!fi_args->num_devices)
                 goto out;

-       di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+       /*
+        * with kernel patch
+        * btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO 
miss-matched with slots
+        * the kernel now returns total_devices which does not include
+        * replacing device if running. There might be a race condition
+	 * where replace might have been completed before DEVS are
+	 * probed. So we anyway probe the replacing at devid 0
+	 * separately which would return -ENODEV if replace has
+	 * finished.
+        */
+
+       di_args = *di_ret = malloc((fi_args->num_devices + 1) * 
sizeof(*di_args));
         if (!di_args) {
                 ret = -errno;
                 goto out;
         }

+       /* get the replace target device if it is there */
+       ret = get_device_info(fd, i, &di_args[ndevs]);
+       if (!ret) {
+               ndevs++;
+               fi_args->num_devices++;
+       }
+       i++;
+
----------------


Thanks, Anand
