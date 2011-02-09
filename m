From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs - use %pU to print fsid
Date: Wed, 9 Feb 2011 16:05:31 +0200
Message-ID: <20110209140531.GA26945@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Get rid of FIXME comment.  Uuids from dmesg are now the same as uuids
given by btrfs-progs.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2636a05..83b789c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -714,12 +714,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	transid = btrfs_super_generation(disk_super);
 	if (disk_super->label[0])
 		printk(KERN_INFO "device label %s ", disk_super->label);
-	else {
-		/* FIXME, make a readl uuid parser */
-		printk(KERN_INFO "device fsid %llx-%llx ",
-		       *(unsigned long long *)disk_super->fsid,
-		       *(unsigned long long *)(disk_super->fsid + 8));
-	}
+	else
+		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-- 
1.7.2.3

