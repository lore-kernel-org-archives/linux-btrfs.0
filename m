Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47743 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaBEHfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 02:35:09 -0500
Message-ID: <52F1E98E.2000207@jp.fujitsu.com>
Date: Wed, 05 Feb 2014 16:34:38 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: stable@vger.kernel.org
Subject: [PATCH] Btrfs: skip submitting barrier for missing device
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got an error on v3.13:
 BTRFS error (device sdf1) in write_all_supers:3378: errno=-5 IO failure (errors while submitting device barriers.)

how to reproduce:
  > mkfs.btrfs -f -d raid1 /dev/sdf1 /dev/sdf2
  > wipefs -a /dev/sdf2
  > mount -o degraded /dev/sdf1 /mnt
  > btrfs balance start -f -sconvert=single -mconvert=single -dconvert=single /mnt

The reason of the error is that barrier_all_devices() failed to submit
barrier to the missing device.  However it is clear that we cannot do
anything on missing device, and also it is not necessary to care chunks
on the missing device.

This patch stops sending/waiting barrier if device is missing.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
---
 fs/btrfs/disk-io.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..7eb50f3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3238,6 +3238,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_send++;
 			continue;
@@ -3252,6 +3254,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_wait++;
 			continue;
-- 
1.7.1


