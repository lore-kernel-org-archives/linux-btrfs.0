Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758703AbaGXDfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:42 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZcH9017409
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/10] Btrfs: Fix wrong device size when we are resizing the device
Date: Thu, 24 Jul 2014 11:37:13 +0800
Message-ID: <1406173035-29478-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

total_bytes of device is just a in-memory variant which is used to record
the size of the device, and it might be changed before we resize a device,
if the resize operation fails, it will be fallbacked. But some code used it
to update on-disk metadata of the device, it would cause the problem that
on-disk metadata of the devices was not consistent. We should use the other
variant named disk_total_bytes to update the on-disk metadata of device,
because that variant is updated only when the resize operation is successful.
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 fs/btrfs/volumes.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08e65e9..2a9560c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3452,7 +3452,8 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		btrfs_set_stack_device_generation(dev_item, 0);
 		btrfs_set_stack_device_type(dev_item, dev->type);
 		btrfs_set_stack_device_id(dev_item, dev->devid);
-		btrfs_set_stack_device_total_bytes(dev_item, dev->total_bytes);
+		btrfs_set_stack_device_total_bytes(dev_item,
+						   dev->disk_total_bytes);
 		btrfs_set_stack_device_bytes_used(dev_item, dev->bytes_used);
 		btrfs_set_stack_device_io_align(dev_item, dev->io_align);
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0d37746..0140bff 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1489,7 +1489,7 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_io_align(leaf, dev_item, device->io_align);
 	btrfs_set_device_io_width(leaf, dev_item, device->io_width);
 	btrfs_set_device_sector_size(leaf, dev_item, device->sector_size);
-	btrfs_set_device_total_bytes(leaf, dev_item, device->total_bytes);
+	btrfs_set_device_total_bytes(leaf, dev_item, device->disk_total_bytes);
 	btrfs_set_device_bytes_used(leaf, dev_item, device->bytes_used);
 	btrfs_set_device_group(leaf, dev_item, 0);
 	btrfs_set_device_seek_speed(leaf, dev_item, 0);
-- 
1.9.3

