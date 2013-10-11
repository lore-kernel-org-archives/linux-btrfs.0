Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:33965 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab3JKNUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 09:20:44 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Cc: zab@redhat.com
Subject: [PATCH] Btrfs: init device stats for new devices
Date: Fri, 11 Oct 2013 15:20:42 +0200
Message-Id: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device stats are only initialized (read from tree items) on mount.
Trying to read device stats after adding or replacing new devices will
return errors.

btrfs_init_new_device() and btrfs_init_dev_replace_tgtdev() are the two
functions that allocate and initialize new btrfs_device structures after
a filesystem is mounted. They set the device stats to zero by using
kzalloc() which is correct for new devices. The only missing thing was
to declare these stats as being valid (device->dev_stats_valid = 1) and
this patch adds this missing code.

This is the reproducer:

TEST_DEV1=/dev/sdzzzzz1
TEST_DEV2=/dev/sdzzzzz2
TEST_DEV3=/dev/sdzzzzz3
TEST_MNT=/mnt
mkfs.btrfs $TEST_DEV1
mount $TEST_DEV1 $TEST_MNT
btrfs device add $TEST_DEV2 $TEST_MNT
btrfs device stat $TEST_MNT
btrfs replace start -B $TEST_DEV2 $TEST_DEV3 $TEST_MNT
btrfs device stat $TEST_MNT
umount $TEST_MNT

Reported-by: Ondrej Kunc <kunc88@gmail.com>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
The idea to fix this issue, the subject line of the patch and parts
of the commit log are reused from a patch that Zach Brown has sent.

 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 646d10d..9837439 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2041,6 +2041,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 0;
 	device->mode = FMODE_EXCL;
+	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, 4096);
 
 	if (seeding_dev) {
@@ -2208,6 +2209,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 1;
 	device->mode = FMODE_EXCL;
+	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, 4096);
 	device->fs_devices = fs_info->fs_devices;
 	list_add(&device->dev_list, &fs_info->fs_devices->devices);
-- 
1.8.4

