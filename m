Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50843 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcHVDj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Aug 2016 23:39:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bbg5b-0006k6-7L
        for linux-btrfs@vger.kernel.org; Mon, 22 Aug 2016 05:39:55 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Stuck btrfs-cleaner on 4.7 and 4.6
Date: Sun, 21 Aug 2016 17:39:48 -1000
Message-ID: <npds64$nu3$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------6A6DFC6A4A6E31E461C8D3BE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------6A6DFC6A4A6E31E461C8D3BE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi list,

After upgrading my Fedora 23 system from 4.4.12 to 4.7.2, I'm seeing one
btrfs-cleaner process stuck at 100% CPU. The problem disappears when
going back to 4.4 kernel (4.4.17), but is also present with Fedora
kernel 4.6.6-200.fc23.

4.4.12 and 4.4.17 are built from source, with 2 patches (see attached).
4.7.2 is built from source without any patch.

Main Btrfs is RAID1 on 2 disks behind bcache, with 13 sub-volumes, and
less than 300 snapshots (more details below). There are 2 other Btrfs
used for backup, so not mounted when the problem appears.

The btrfs-cleaner jumps at 100% after about ~15 min uptime. I let it run
about ~18 hours, btrfs-cleaner stayed at 100%. Unmounting all the
sub-volumes clears the problem. There is no error in the logs, all the
sub-volumes are mounted ok, I can use the system. I did a scrub and
balance, which finished without any error.

I'm back on 4.4.17 now, but what can I do to debug this problem ?


[jdg@tiare ~]$ sudo btrfs fi sh
Label: none  uuid: c5b8386b-b81d-4473-9340-7b8a74fc3a3c
        Total devices 2 FS bytes used 1.04TiB
        devid    1 size 1.82TiB used 1.08TiB path /dev/bcache0
        devid    2 size 1.82TiB used 1.08TiB path /dev/bcache1

Label: none  uuid: e86cf0f5-ae16-408c-a4f8-19727aa2a3d4
        Total devices 1 FS bytes used 191.20GiB
        devid    1 size 279.46GiB used 240.06GiB path /dev/sdd

Label: none  uuid: d0d09c79-42d7-4958-bccb-480eb27aec38
        Total devices 1 FS bytes used 611.38GiB
        devid    1 size 931.51GiB used 620.07GiB path /dev/sde

[jdg@tiare ~]$ sudo btrfs fi usage /home/jdg/
Overall:
    Device size:                   3.64TiB
    Device allocated:              2.16TiB
    Device unallocated:            1.48TiB
    Device missing:                  0.00B
    Used:                          2.08TiB
    Free (estimated):            798.35GiB      (min: 798.35GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:1.08TiB, Used:1.04TiB
   /dev/bcache0    1.08TiB
   /dev/bcache1    1.08TiB

Metadata,RAID1: Size:4.00GiB, Used:2.74GiB
   /dev/bcache0    4.00GiB
   /dev/bcache1    4.00GiB

System,RAID1: Size:32.00MiB, Used:256.00KiB
   /dev/bcache0   32.00MiB
   /dev/bcache1   32.00MiB

Unallocated:
   /dev/bcache0  757.99GiB
   /dev/bcache1  757.99GiB

[jdg@tiare ~]$ mount -t btrfs
/dev/bcache0 on /var/lib/pgsql type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1131,subvol=/pgsql)
/dev/bcache0 on /home/SysNux type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1062,subvol=/SysNux)
/dev/bcache0 on /home/Vidéos type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1281,subvol=/Vidéos)
/dev/bcache0 on /var/lib/libvirt/images type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1136,subvol=/images-vm)
/dev/bcache0 on /mnt/snapshots type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1292,subvol=/Snapshots)
/dev/bcache0 on /home/Photos type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=676,subvol=/Photos)
/dev/bcache0 on /home/vaiana type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1076,subvol=/vaiana)
/dev/bcache0 on /home/Films type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=258,subvol=/Films)
/dev/bcache0 on /home/Partage type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1059,subvol=/Partage)
/dev/bcache0 on /home/jdg type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1073,subvol=/jdg)
/dev/bcache0 on /home/michael type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1075,subvol=/michael)
/dev/bcache0 on /home/cathy type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=1074,subvol=/cathy)
/dev/bcache0 on /home/Musique type btrfs
(rw,noatime,nodiratime,seclabel,compress=zlib,ssd,space_cache,autodefrag,skip_balance,subvolid=961,subvol=/Musique)



Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


--------------6A6DFC6A4A6E31E461C8D3BE
Content-Type: text/x-patch;
 name="btrfs-4.4.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-4.4.1.patch"

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 977e715..11fd981 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1516,27 +1516,24 @@  static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
 
-		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
-					     BTRFS_INODE_PREALLOC)) {
-			ret = check_can_nocow(inode, pos, &write_bytes);
-			if (ret < 0)
-				break;
-			if (ret > 0) {
-				/*
-				 * For nodata cow case, no need to reserve
-				 * data space.
-				 */
-				only_release_metadata = true;
-				/*
-				 * our prealloc extent may be smaller than
-				 * write_bytes, so scale down.
-				 */
-				num_pages = DIV_ROUND_UP(write_bytes + offset,
-							 PAGE_CACHE_SIZE);
-				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
-				goto reserve_metadata;
-			}
+		if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC)) &&
+		    check_can_nocow(inode, pos, &write_bytes) > 0) {
+			/*
+			 * For nodata cow case, no need to reserve
+			 * data space.
+			 */
+			only_release_metadata = true;
+			/*
+			 * our prealloc extent may be smaller than
+			 * write_bytes, so scale down.
+			 */
+			num_pages = DIV_ROUND_UP(write_bytes + offset,
+						 PAGE_CACHE_SIZE);
+			reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+			goto reserve_metadata;
 		}
+
 		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
 		if (ret < 0)
 			break;

--------------6A6DFC6A4A6E31E461C8D3BE
Content-Type: text/x-patch;
 name="btrfs-alloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-alloc.patch"

diff -Naur linux-4.4.6.ORIG/fs/btrfs/ctree.c linux-4.4.6/fs/btrfs/ctree.c
--- linux-4.4.6.ORIG/fs/btrfs/ctree.c	2016-01-10 13:01:32.000000000 -1000
+++ linux-4.4.6/fs/btrfs/ctree.c	2016-03-30 06:19:16.397973820 -1000
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include "ctree.h"
+#include <linux/vmalloc.h>
 #include "disk-io.h"
 #include "transaction.h"
 #include "print-tree.h"
@@ -5362,10 +5363,13 @@
 		goto out;
 	}
 
-	tmp_buf = kmalloc(left_root->nodesize, GFP_NOFS);
+	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL | __GFP_NOWARN);
 	if (!tmp_buf) {
-		ret = -ENOMEM;
-		goto out;
+      tmp_buf = vmalloc(left_root->nodesize);
+      if (!tmp_buf) {
+		   ret = -ENOMEM;
+   		goto out;
+      }
 	}
 
 	left_path->search_commit_root = 1;
@@ -5566,7 +5570,7 @@
 out:
 	btrfs_free_path(left_path);
 	btrfs_free_path(right_path);
-	kfree(tmp_buf);
+	kvfree(tmp_buf);
 	return ret;
 }
 

--------------6A6DFC6A4A6E31E461C8D3BE--

