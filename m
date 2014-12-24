Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34271 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750891AbaLXBzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 20:55:19 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBO1so8O023066
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 09:54:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] btrfs: Enhance btrfs chunk allocation algorithm to reduce ENOSPC caused by unbalanced data/metadata allocation.
Date: Wed, 24 Dec 2014 09:55:14 +0800
Message-ID: <1419386114-21703-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419386114-21703-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419386114-21703-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs allocate a chunk, it will try to alloc up to 1G for data and
256M for metadata, or 10% of all the writeable space if there is enough
space for the stripe on device.

However, when we run out of space, this allocation may cause unbalanced
chunk allocation.
For example, there are only 1G unallocated space, and request for
allocate DATA chunk is sent, and all the space will be allocated as data
chunk, making later metadata chunk alloc request unable to handle, which
will cause ENOSPC.
This is the one of the common complains from end users about why ENOSPC
happens but there is still available space.

This patch will try not to alloc chunk which is more than half of the
unallocated space, making the last space more balanced at a small cost
of more fragmented chunk at the last 1G.

Some easy example:
Preallocate 17.5G on a 20G empty btrfs fs:
[Before]
 # btrfs fi show /mnt/test
Label: none  uuid: da8741b1-5d47-4245-9e94-bfccea34e91e
	Total devices 1 FS bytes used 17.50GiB
	devid    1 size 20.00GiB used 20.00GiB path /dev/sdb
All space is allocated. No space for later metadata allocation.

[After]
 # btrfs fi show /mnt/test
Label: none  uuid: e6935aeb-a232-4140-84f9-80aab1f23d56
	Total devices 1 FS bytes used 17.50GiB
	devid    1 size 20.00GiB used 19.77GiB path /dev/sdb
About 230M is still available for later metadata allocation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   Remove false dead zone judgement since it won't happen
---
 fs/btrfs/volumes.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e74b34..20b3eea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4237,6 +4237,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_stripe_size;
 	u64 max_logical_size;	/* Up limit on chunk's logical size */
 	u64 max_physical_size;	/* Up limit on a chunk's on-disk size */
+	u64 total_physical_avail = 0;
 	u64 stripe_size;
 	u64 num_bytes;
 	u64 raid_stripe_len = BTRFS_STRIPE_LEN;
@@ -4349,6 +4350,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		devices_info[ndevs].max_avail = max_avail;
 		devices_info[ndevs].total_avail = total_avail;
 		devices_info[ndevs].dev = device;
+		total_physical_avail += total_avail;
 		++ndevs;
 	}
 
@@ -4398,6 +4400,23 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		do_div(stripe_size, num_stripes);
 		need_bump = 1;
 	}
+
+	/*
+	 * Don't alloc chunk whose physical size is larger than half
+	 * of the rest physical space.
+	 * This will reduce the possibility of ENOSPC when comes to
+	 * last unallocated space
+	 *
+	 * For the last 16~32M (e.g. 20M), it will first alloc 16M
+	 * (bumped to 16M) and the next time will be the rest size
+	 * (bumped to 16M and reduced to 4M).
+	 * So no dead zone.
+	 */
+	if (stripe_size * num_stripes > total_physical_avail / 2) {
+		stripe_size = total_physical_avail / 2;
+		need_bump = 1;
+
+	}
 	/* restrict logical chunk size  */
 	if (stripe_size * data_stripes > max_logical_size) {
 		stripe_size = max_logical_size;
-- 
2.2.1

