From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix oops when calling statfs on readonly device
Date: Mon, 28 Nov 2011 16:43:00 +0800
Message-ID: <4ED34994.6020006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

To reproduce this bug:

  # dd if=/dev/zero of=img bs=1M count=256
  # mkfs.btrfs img
  # losetup -r /dev/loop1 img
  # mount /dev/loop1 /mnt
  OOPS!!

It triggered BUG_ON(!nr_devices) in btrfs_calc_avail_data_space().

To fix this, instead of checking write-only devices, we check all open
deivces:

  # df -h /dev/loop1
  Filesystem            Size  Used Avail Use% Mounted on
  /dev/loop1            250M   28K  238M   1% /mnt

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8bd9d6d..1a3ce9e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1083,7 +1083,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	int i = 0, nr_devices;
 	int ret;
 
-	nr_devices = fs_info->fs_devices->rw_devices;
+	nr_devices = fs_info->fs_devices->open_devices;
 	BUG_ON(!nr_devices);
 
 	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
@@ -1105,8 +1105,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	else
 		min_stripe_size = BTRFS_STRIPE_LEN;
 
-	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-		if (!device->in_fs_metadata)
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (!device->in_fs_metadata || !device->bdev)
 			continue;
 
 		avail_space = device->total_bytes - device->bytes_used;
-- 1.7.3.1 
