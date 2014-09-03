Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13195 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932291AbaICNeK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY6TM006652
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/18] Btrfs: Fix wrong free_chunk_space assignment during removing a device
Date: Wed, 3 Sep 2014 21:35:35 +0800
Message-ID: <1409751347-5296-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During removing a device, we have modified free_chunk_space when we
shrink the device, so we needn't assign a new value to it after
the device shrink. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f8273bb..1524b3f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1671,11 +1671,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto error_undo;
 
-	spin_lock(&root->fs_info->free_chunk_lock);
-	root->fs_info->free_chunk_space = device->total_bytes -
-		device->bytes_used;
-	spin_unlock(&root->fs_info->free_chunk_lock);
-
 	device->in_fs_metadata = 0;
 	btrfs_scrub_cancel_dev(root->fs_info, device);
 
-- 
1.9.3

