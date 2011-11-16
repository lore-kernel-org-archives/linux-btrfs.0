From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Btrfs: Prefix resize related printks with btrfs:
Date: Wed, 16 Nov 2011 18:47:30 +0100
Message-ID: <1321465650-11680-1-git-send-email-arnd@arndnet.de>
Cc: chris.mason@oracle.com, Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For the user it is confusing to find something like:
[10197.627710] new size for /dev/mapper/vg0-usr_share is 3221225472
in kernel log, because it doesn't point directly to btrfs.

This patch prefixes those messages with "btrfs:" like other btrfs
related printks.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 fs/btrfs/ioctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4a34c47..b6d2a1a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1216,12 +1216,12 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		*devstr = '\0';
 		devstr = vol_args->name;
 		devid = simple_strtoull(devstr, &end, 10);
-		printk(KERN_INFO "resizing devid %llu\n",
+		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
 	device = btrfs_find_device(root, devid, NULL, NULL);
 	if (!device) {
-		printk(KERN_INFO "resizer unable to find device %llu\n",
+		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
 		       (unsigned long long)devid);
 		ret = -EINVAL;
 		goto out_unlock;
@@ -1267,7 +1267,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	do_div(new_size, root->sectorsize);
 	new_size *= root->sectorsize;
 
-	printk(KERN_INFO "new size for %s is %llu\n",
+	printk(KERN_INFO "btrfs: new size for %s is %llu\n",
 		device->name, (unsigned long long)new_size);
 
 	if (new_size > old_size) {
-- 
1.7.5.4

