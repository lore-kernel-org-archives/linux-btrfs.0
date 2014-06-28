Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbaF1Ldh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:37 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXYqi021036
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/12] Btrfs: Set real mirror number for read operation on RAID0/5/6
Date: Sat, 28 Jun 2014 19:35:00 +0800
Message-ID: <1403955302-22396-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
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
 fs/btrfs/volumes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c83b242..95828b0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4935,6 +4935,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_index = do_div(stripe_nr, map->num_stripes);
+		if (!(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)))
+			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
 		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS))
 			num_stripes = map->num_stripes;
@@ -5038,6 +5040,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
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

