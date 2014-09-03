Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50391 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755478AbaICNeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:12 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY8he006661
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/18] Btrfs: update free_chunk_space during allocting a new chunk
Date: Wed, 3 Sep 2014 21:35:37 +0800
Message-ID: <1409751347-5296-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should update free_chunk_space in time when we allocate a new chunk,
not when we deal with the pending device update and block group insertion,
because we need the real free_chunk_space data to calculate the reserved
space, if we don't update it in time, we would consider the disk space which
has be allocated as free space, and would use it to do overcommit reservation.
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 45e0b5d..d8e4a3d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4432,6 +4432,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	for (i = 0; i < map->num_stripes; i++)
 		map->stripes[i].dev->bytes_used += stripe_size;
 
+	spin_lock(&extent_root->fs_info->free_chunk_lock);
+	extent_root->fs_info->free_chunk_space -= (stripe_size *
+						   map->num_stripes);
+	spin_unlock(&extent_root->fs_info->free_chunk_lock);
+
 	free_extent_map(em);
 	check_raid56_incompat_flag(extent_root->fs_info, type);
 
@@ -4515,11 +4520,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 			goto out;
 	}
 
-	spin_lock(&extent_root->fs_info->free_chunk_lock);
-	extent_root->fs_info->free_chunk_space -= (stripe_size *
-						   map->num_stripes);
-	spin_unlock(&extent_root->fs_info->free_chunk_lock);
-
 	stripe = &chunk->stripe;
 	for (i = 0; i < map->num_stripes; i++) {
 		device = map->stripes[i].dev;
-- 
1.9.3

