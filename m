From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH] properly set blocksize when adding new device.
Date: Tue, 02 Sep 2008 02:02:00 +0800
Message-ID: <48BC2E18.9050506@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

blocksize != 4096 causes btrfs super block written to wrong location.

---
diff -r 8fe9e10847fa volumes.c
--- a/volumes.c    Thu Aug 28 06:21:17 2008 -0400
+++ b/volumes.c    Tue Sep 02 01:41:40 2008 +0800
@@ -1078,6 +1078,8 @@
     if (ret)
         goto out_close_bdev;
 
+    set_blocksize(device->bdev, 4096);
+
     total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
     btrfs_set_super_total_bytes(&root->fs_info->super_copy,
                     total_bytes + device->total_bytes);
