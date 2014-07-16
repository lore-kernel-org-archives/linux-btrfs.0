Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62523 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbaGPKgg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 06:36:36 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6GAaSS2026172
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 18:36:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: fix wrong missing device counter decrease
Date: Wed, 16 Jul 2014 18:38:01 +0800
Message-ID: <1405507081-8811-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The missing devices are accounted by its own fs device, for example
the missing devices in seed filesystem will be accounted by the fs device
of the seed filesystem, not by the new filesystem which is based on
the seed filesystem, so when we remove the missing device in the
seed filesystem, we should decrease the counter of its own fs device.
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is against:
[PATCH 8/9] Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index daecfa5..4cfbe76 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1723,7 +1723,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	device->fs_devices->total_devices--;
 
 	if (device->missing)
-		root->fs_info->fs_devices->missing_devices--;
+		device->fs_devices->missing_devices--;
 
 	next_device = list_entry(root->fs_info->fs_devices->devices.next,
 				 struct btrfs_device, dev_list);
-- 
1.9.3

