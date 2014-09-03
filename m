Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3895 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932745AbaICNeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYHxs006707
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 18/18] Btrfs: modify rw_devices counter under chunk_mutex context
Date: Wed, 3 Sep 2014 21:35:47 +0800
Message-ID: <1409751347-5296-18-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rw_devices counter is often used to tune the profile when doing chunk allocation,
so we should modify it under the chunk_mutex context to avoid getting wrong
chunk profile.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b7f093d..1aacf5f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1649,8 +1649,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->writeable) {
 		lock_chunks(root);
 		list_del_init(&device->dev_alloc_list);
+		device->fs_devices->rw_devices--;
 		unlock_chunks(root);
-		root->fs_info->fs_devices->rw_devices--;
 		clear_super = true;
 	}
 
@@ -1795,8 +1795,8 @@ error_undo:
 		lock_chunks(root);
 		list_add(&device->dev_alloc_list,
 			 &root->fs_info->fs_devices->alloc_list);
+		device->fs_devices->rw_devices++;
 		unlock_chunks(root);
-		root->fs_info->fs_devices->rw_devices++;
 	}
 	goto error_brelse;
 }
-- 
1.9.3

