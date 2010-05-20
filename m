From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 05/10] btrfs: fix oops when adding a device
Date: Thu, 20 May 2010 15:20:52 +0800
Message-ID: <4BF4E2D4.2000302@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After we remove a device from a raid0 filesystem with two devices, if we
add a device into this filesystem, oops occurs.

Steps to reproduce:
 # mkfs.btrfs -m raid0 /dev/sda1 /dev/sda2
 # mount /dev/sda1 /mnt
 # btrfs-vol -r /dev/sda2 /mnt
 # btrfs-vol -a /dev/sda2 /mnt
 (oops happens.)

The following is the oops info.

btrfs allocation failed flags 12, wanted 4096
space_info has 0 free, is not full
space_info total=0, pinned=0, delalloc=0, may_use=0, used=0, root=0, super=0, reserved=0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff8117adaa>] btrfs_print_leaf+0x24/0x7be
[snip]
Call Trace:
 [<ffffffff811775f3>] __btrfs_free_extent+0x2d6/0x703
 [<ffffffff81177ec9>] run_one_delayed_ref+0x4a9/0x4c5
 [<ffffffff8106738f>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811b3c66>] ? btrfs_delayed_ref_lock+0x3a/0x108
 [<ffffffff8117a13b>] run_clustered_refs+0x283/0x303
 [<ffffffff8117a287>] btrfs_run_delayed_refs+0xcc/0x1c4
 [<ffffffff8118417f>] btrfs_commit_transaction+0x7d/0x605
 [<ffffffff81057307>] ? autoremove_wake_function+0x0/0x34
 [<ffffffff811a609f>] btrfs_init_new_device+0x965/0xb9a
 [<ffffffff810b6f60>] ? might_fault+0x40/0x90
 [<ffffffff810b6fa9>] ? might_fault+0x89/0x90
 [<ffffffff810b6f60>] ? might_fault+0x40/0x90
 [<ffffffff811aa308>] btrfs_ioctl+0x676/0x87a
 [<ffffffff8105b112>] ? up_read+0x1e/0x38
 [<ffffffff810ec50d>] vfs_ioctl+0x2d/0xa1
 [<ffffffff810eca95>] do_vfs_ioctl+0x490/0x4d6
 [<ffffffff810ecb1d>] sys_ioctl+0x42/0x65
 [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
Code: 5c 41 5d 41 5e c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 65 4c 8b 24 25 48 b5 00 00 53 49 81 ec d8 1f 00 00 48 89 f3 48 83 ec 58 <48> 8b 46 30 41 ff 44 24 1c 49 bf 00 00 00 00 00 16 00 00 49 be
RIP  [<ffffffff8117adaa>] btrfs_print_leaf+0x24/0x7be
 RSP <ffff88006d01b8e8>
CR2: 0000000000000030
---[ end trace 16a3731f765194e8 ]---

The reason is that the btrfs can't alloc the space with the RAID0|METADATA type.
The filesystem stored the metadata in the RAID0 block group originally.
But after we removed one device, the filesystem had only one device and all
RAID0 block groups were removed. So when we add a new device to the filesystem,
the filesystem wanted to get some space to store the new device info, but it
can't find a RAID0 block group to alloc the space and oops happened.

This patch fixes this problem by checking the number of devices in the
filesystem. If the RAID0 profile is set and the number of devices is less than
or equal 2, we can't remove device.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   50 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b584e9a..e344ba9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1121,6 +1121,38 @@ out:
 	return ret;
 }
 
+static int btrfs_device_can_remove(struct btrfs_fs_info *fs_info)
+{
+	u64 all_avail;
+
+	all_avail = fs_info->avail_data_alloc_bits |
+		    fs_info->avail_system_alloc_bits |
+		    fs_info->avail_metadata_alloc_bits;
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
+	    fs_info->fs_devices->num_devices <= 4) {
+		printk(KERN_ERR "btrfs: unable to go below four devices "
+		       "on raid10\n");
+		return 0;
+	}
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
+	    fs_info->fs_devices->num_devices <= 2) {
+		printk(KERN_ERR "btrfs: unable to go below two "
+		       "devices on raid1\n");
+		return 0;
+	}
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID0) &&
+	    fs_info->fs_devices->num_devices <= 2) {
+		printk(KERN_ERR "btrfs: unable to go below two "
+		       "devices on raid0\n");
+		return 0;
+	}
+
+	return 1;
+}
+
 int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_device *device;
@@ -1128,7 +1160,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
-	u64 all_avail;
 	u64 devid;
 	u64 num_devices;
 	u8 *dev_uuid;
@@ -1137,22 +1168,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&root->fs_info->volume_mutex);
 
-	all_avail = root->fs_info->avail_data_alloc_bits |
-		root->fs_info->avail_system_alloc_bits |
-		root->fs_info->avail_metadata_alloc_bits;
-
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->num_devices <= 4) {
-		printk(KERN_ERR "btrfs: unable to go below four devices "
-		       "on raid10\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->num_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid1\n");
+	if (!btrfs_device_can_remove(root->fs_info)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.6.5.2


