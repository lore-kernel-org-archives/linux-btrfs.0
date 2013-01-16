Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37120 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab3APL1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 06:27:44 -0500
Message-ID: <50F68E95.6070901@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 19:27:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Liu Bo <liub.liubo@gmail.com>
Subject: [PATCH 1/2] Btrfs: fix wrong max device number for single profile
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The max device number of single profile is 1, not 0 (0 means 'as many as
possible'). Fix it.

Cc: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 86279c3..7fa9773 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3496,7 +3496,7 @@ struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	{ 1, 1, 2, 2, 2, 2 /* raid1 */ },
 	{ 1, 2, 1, 1, 1, 2 /* dup */ },
 	{ 1, 1, 0, 2, 1, 1 /* raid0 */ },
-	{ 1, 1, 0, 1, 1, 1 /* single */ },
+	{ 1, 1, 1, 1, 1, 1 /* single */ },
 };
 
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-- 
1.7.11.7
