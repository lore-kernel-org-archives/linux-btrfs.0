From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check total number of devices when removing missing
Date: Tue, 26 Jan 2010 21:09:38 -0500
Message-ID: <20100127020938.GC11767@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If you have a disk failure in RAID1 and then add a new disk to the array, and
then try to remove the missing volume, it will fail.  The reason is the sanity
check only looks at the total number of rw devices, which is just 2 because we
have 2 good disks and 1 bad one.  Instead check the total number of devices in
the array to make sure we can actually remove the device.  Tested this with a
failed disk setup and with this test we can now run

btrfs-vol -r missing /mount/point

and it works fine.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 605ea5b..98a48a3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1135,7 +1135,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->avail_metadata_alloc_bits;
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->rw_devices <= 4) {
+	    root->fs_info->fs_devices->num_devices <= 4) {
 		printk(KERN_ERR "btrfs: unable to go below four devices "
 		       "on raid10\n");
 		ret = -EINVAL;
@@ -1143,7 +1143,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->rw_devices <= 2) {
+	    root->fs_info->fs_devices->num_devices <= 2) {
 		printk(KERN_ERR "btrfs: unable to go below two "
 		       "devices on raid1\n");
 		ret = -EINVAL;
-- 
1.5.4.3

