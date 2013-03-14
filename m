Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40163 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3CNIal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 04:30:41 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2E8UdYu031914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 08:30:40 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2E8Ude3027514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 08:30:39 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2E8Udhh022423
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:30:39 -0500
Message-ID: <51418AD5.6090207@oracle.com>
Date: Thu, 14 Mar 2013 16:31:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs_scan_one_device return error code
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

  /dev/sdc does not contain btrfs SB at all..

---
  # btrfs dev scan /dev/sdc
  Scanning for Btrfs filesystems in '/dev/sdc'
  ERROR: unable to scan the device '/dev/sdc' - Invalid argument
---

  here appropriate error is something like
  no btrfs found on dev

  However btrfs_scan_one_device (kernel) returns -EINVAL
  for other errors too

  Does the below fix sound reasonable ?

Thanks, Anand

--------------
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6b9cff4..d6deae0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -808,7 +808,7 @@ int btrfs_scan_one_device(const char *path, fmode_t 
flags, void *holder,
         struct block_device *bdev;
         struct page *page;
         void *p;
-       int ret = -EINVAL;
+       int ret = 0;
         u64 devid;
         u64 transid;
         u64 total_devices;
@@ -833,24 +833,32 @@ int btrfs_scan_one_device(const char *path, 
fmode_t flags, void *holder,
         }

         /* make sure our super fits in the device */
-       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
+       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode)) {
+               ret = -ENOSPC;
                 goto error_bdev_put;
+       }

         /* make sure our super fits in the page */
-       if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
+       if (sizeof(*disk_super) > PAGE_CACHE_SIZE) {
+               ret = -ENOMEM;
                 goto error_bdev_put;
+       }

         /* make sure our super doesn't straddle pages on disk */
         index = bytenr >> PAGE_CACHE_SHIFT;
-       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
+       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != 
index) {
+               ret = -ENOMEM;
                 goto error_bdev_put;
+       }

         /* pull in the page with our super */
         page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
                                    index, GFP_NOFS);

-       if (IS_ERR_OR_NULL(page))
+       if (IS_ERR_OR_NULL(page)) {
+               ret = -EIO;
                 goto error_bdev_put;
+       }

         p = kmap(page);

@@ -858,8 +866,10 @@ int btrfs_scan_one_device(const char *path, fmode_t 
flags, void *holder,
         disk_super = p + (bytenr & ~PAGE_CACHE_MASK);

         if (btrfs_super_bytenr(disk_super) != bytenr ||
-           disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
+           disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
+               ret = -EINVAL;
                 goto error_unmap;
+       }

         devid = btrfs_stack_device_id(&disk_super->dev_item);
         transid = btrfs_super_generation(disk_super);
-------------------
