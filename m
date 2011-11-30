From: Chris Samuel <chris@csamuel.org>
Subject: [RESEND] [PATCH] Prefix mount messages with btrfs: for clarity
Date: Wed, 30 Nov 2011 22:28:37 +1100
Message-ID: <201111302228.38074.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently when mounting a btrfs filesystem a user searching dmesg
has no obvious string to search for as currently we report something
cryptic like:

[ 5775.216078] device label DR devid 1 transid 15757 /dev/sdh1

It would be much nicer if there was some mention of btrfs to find
(as other filesystems generally provide), so this change prefixes
that message with btrfs: to make it appear as:

[ 5775.216078] btrfs: device label DR devid 1 transid 15757 /dev/sdh1

Signed-off-by: Chris Samuel <chris@csamuel.org>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..bc08087 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -722,9 +722,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	if (disk_super->label[0])
-		printk(KERN_INFO "device label %s ", disk_super->label);
+		printk(KERN_INFO "btrfs: device label %s ", disk_super->label);
 	else
-		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
+		printk(KERN_INFO "btrfs: device fsid %pU ", disk_super->fsid);
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-- 
1.7.4.1

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP
