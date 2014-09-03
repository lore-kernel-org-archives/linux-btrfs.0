Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10872 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932552AbaICNeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYDLT006681
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 13/18] Btrfs: fix unprotected device list access when cloning fs devices
Date: Wed, 3 Sep 2014 21:35:42 +0800
Message-ID: <1409751347-5296-13-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can build a new filesystem based a seed filesystem, and we need clone
the fs devices when we open the new filesystem. But someone might clear
the seed flag of the seed filesystem, then mount that filesystem and
remove some device. If we mount the new filesystem, we might access
a device list which was being changed when we clone the fs devices.
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 357f911..f0173b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -583,6 +583,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	if (IS_ERR(fs_devices))
 		return fs_devices;
 
+	mutex_lock(&orig->device_list_mutex);
 	fs_devices->total_devices = orig->total_devices;
 
 	/* We have held the volume lock, it is safe to get the devices. */
@@ -611,8 +612,10 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
+	mutex_unlock(&orig->device_list_mutex);
 	return fs_devices;
 error:
+	mutex_unlock(&orig->device_list_mutex);
 	free_fs_devices(fs_devices);
 	return ERR_PTR(-ENOMEM);
 }
-- 
1.9.3

