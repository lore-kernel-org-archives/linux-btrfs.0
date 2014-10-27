Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23099 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751562AbaJ0Mk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:40:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9RCeJUH007504
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 20:40:19 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: get the accurate value of used_bytes in btrfs_get_block_group_info().
Date: Mon, 27 Oct 2014 20:38:19 +0800
Message-ID: <1414413499-28826-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reproducer:
	# mkfs.btrfs -f -b 20G /dev/sdb
	# mount /dev/sdb /mnt/test
	# fallocate  -l 17G /mnt/test/largefile
	# btrfs fi df /mnt/test
	Data, single: total=17.49GiB, used=6.00GiB <- only 6G, but actually it should be 17G.
	System, DUP: total=8.00MiB, used=16.00KiB
	System, single: total=4.00MiB, used=0.00B
	Metadata, DUP: total=1.00GiB, used=112.00KiB
	Metadata, single: total=8.00MiB, used=0.00B
	GlobalReserve, single: total=16.00MiB, used=0.00B
	# sync
	# btrfs fi df /mnt/test
	Data, single: total=17.49GiB, used=17.00GiB <- After sync, it is expected.
	System, DUP: total=8.00MiB, used=16.00KiB
	System, single: total=4.00MiB, used=0.00B
	Metadata, DUP: total=1.00GiB, used=112.00KiB
	Metadata, single: total=8.00MiB, used=0.00B
	GlobalReserve, single: total=16.00MiB, used=0.00B

The value of 6.00GiB is actually calculated in btrfs_get_block_group_info()
by adding the @block_group->item->used for each group together. In this way,
it did not consider the bytes in cache.

This patch adds the value of @pinned, @reserved and @bytes_super in
struct btrfs_block_group_cache to make sure we can get the accurate @used_bytes.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 33c80f5..bc2aaeb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3892,6 +3892,10 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 		space->total_bytes += block_group->key.offset;
 		space->used_bytes +=
 			btrfs_block_group_used(&block_group->item);
+		/* Add bytes-info in cache */
+		space->used_bytes += block_group->pinned;
+		space->used_bytes += block_group->reserved;
+		space->used_bytes += block_group->bytes_super;
 	}
 }
 
-- 
1.8.4.2

