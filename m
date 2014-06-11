Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53423 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbaFKC7a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 22:59:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5B2xSAa032357
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 10:59:28 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix unfinished readahead thread for raid5/6 degraded mounting
Date: Wed, 11 Jun 2014 10:55:22 +0800
Message-ID: <1402455322-10471-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:

 # mkfs.btrfs -f /dev/sd[b-f] -m raid5 -d raid5
 # mkfs.ext4 /dev/sdc --->corrupt one of btrfs device
 # mount /dev/sdb /mnt -o degraded
 # btrfs scrub start -BRd /mnt

This is because readahead would skip missing device, this is not true
for RAID5/6, because REQ_GET_READ_MIRRORS return 1 for RAID5/6 block
mapping. If expected data locates in missing device, readahead thread
would not call __readahead_hook() which makes event @rc->elems=0
wait forever.

Fix this problem by checking return value of btrfs_map_block(),we
can only skip missing device safely if there are several mirrors.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 30947f9..09230cf 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -428,8 +428,13 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			continue;
 		}
 		if (!dev->bdev) {
-			/* cannot read ahead on missing device */
-			continue;
+			/*
+			 * cannot read ahead on missing device, but for RAID5/6,
+			 * REQ_GET_READ_MIRRORS return 1. So don't skip missing
+			 * device for such case.
+			 */
+			if (nzones > 1)
+				continue;
 		}
 		if (dev_replace_is_ongoing &&
 		    dev == fs_info->dev_replace.tgtdev) {
-- 
1.8.2.1

