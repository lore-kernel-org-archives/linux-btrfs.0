Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13195 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932354AbaICNeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:12 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY7v7006656
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/18] Btrfs: fix unprotected device->bytes_used update
Date: Wed, 3 Sep 2014 21:35:36 +0800
Message-ID: <1409751347-5296-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should update device->bytes_used in the lock context of
chunk_mutex, or we would get wrong data.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1524b3f..45e0b5d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4429,6 +4429,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto error_del_extent;
 
+	for (i = 0; i < map->num_stripes; i++)
+		map->stripes[i].dev->bytes_used += stripe_size;
+
 	free_extent_map(em);
 	check_raid56_incompat_flag(extent_root->fs_info, type);
 
@@ -4500,7 +4503,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		device = map->stripes[i].dev;
 		dev_offset = map->stripes[i].physical;
 
-		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
 		if (ret)
 			goto out;
-- 
1.9.3

