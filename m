Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33100 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbaILKmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 06:42:22 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8CAgUEl017346
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 18:42:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 09/11] Btrfs: Set real mirror number for read operation on RAID0/5/6
Date: Fri, 12 Sep 2014 18:44:02 +0800
Message-ID: <1410518644-31806-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
References: <5405C08B.9020009@fb.com>
 <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need real mirror number for RAID0/5/6 when reading data, or if read error
happens, we would pass 0 as the number of the mirror on which the io error
happens. It is wrong and would cause the filesystem read the data from the
corrupted mirror again.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- None
---
 fs/btrfs/volumes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1aacf5f..4856547 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5073,6 +5073,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_index = do_div(stripe_nr, map->num_stripes);
+		if (!(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)))
+			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
 		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS))
 			num_stripes = map->num_stripes;
@@ -5176,6 +5178,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			/* We distribute the parity blocks across stripes */
 			tmp = stripe_nr + stripe_index;
 			stripe_index = do_div(tmp, map->num_stripes);
+			if (!(rw & (REQ_WRITE | REQ_DISCARD |
+				    REQ_GET_READ_MIRRORS)) && mirror_num <= 1)
+				mirror_num = 1;
 		}
 	} else {
 		/*
-- 
1.9.3

