Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47046 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982AbaDUMSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 08:18:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3LCI13t032321
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 20:18:01 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: add dev maxs limit for btrfs_alloc_chunk in user space
Date: Mon, 21 Apr 2014 20:13:32 +0800
Message-ID: <1398082412-5805-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1398082412-5805-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1398082412-5805-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For RAID0,5,6,10,
For system chunk, there shouldn't be too many stripes to
make a btrfs_chunk that exceeds BTRFS_SYSTEM_CHUNK_ARRAY_SIZE
For data/meta chunk, there shouldn't be too many stripes to
make a btrfs_chunk that exceeds a leaf.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 volumes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/volumes.c b/volumes.c
index b39f374..a61928c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -754,6 +754,16 @@ error:
 	return ret;
 }
 
+#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r)		\
+			- sizeof(struct btrfs_item)		\
+			- sizeof(struct btrfs_chunk))		\
+			/ sizeof(struct btrfs_stripe) + 1)
+
+#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
+				- 2 * sizeof(struct btrfs_disk_key)	\
+				- 2 * sizeof(struct btrfs_chunk))	\
+				/ sizeof(struct btrfs_stripe) + 1)
+
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
 		      u64 *num_bytes, u64 type)
@@ -776,6 +786,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_avail = 0;
 	u64 percent_max;
 	int num_stripes = 1;
+	int max_stripes = 0;
 	int min_stripes = 1;
 	int sub_stripes = 0;
 	int looped = 0;
@@ -797,14 +808,17 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			calc_size = 8 * 1024 * 1024;
 			max_chunk_size = calc_size * 2;
 			min_stripe_size = 1 * 1024 * 1024;
+			max_stripes = BTRFS_MAX_DEVS_SYS_CHUNK;
 		} else if (type & BTRFS_BLOCK_GROUP_DATA) {
 			calc_size = 1024 * 1024 * 1024;
 			max_chunk_size = 10 * calc_size;
 			min_stripe_size = 64 * 1024 * 1024;
+			max_stripes = BTRFS_MAX_DEVS(chunk_root);
 		} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 			calc_size = 1024 * 1024 * 1024;
 			max_chunk_size = 4 * calc_size;
 			min_stripe_size = 32 * 1024 * 1024;
+			max_stripes = BTRFS_MAX_DEVS(chunk_root);
 		}
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID1) {
@@ -820,10 +834,14 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
 		num_stripes = btrfs_super_num_devices(info->super_copy);
+		if (num_stripes > max_stripes)
+			num_stripes = max_stripes;
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
 		num_stripes = btrfs_super_num_devices(info->super_copy);
+		if (num_stripes > max_stripes)
+			num_stripes = max_stripes;
 		if (num_stripes < 4)
 			return -ENOSPC;
 		num_stripes &= ~(u32)1;
@@ -832,6 +850,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
 		num_stripes = btrfs_super_num_devices(info->super_copy);
+		if (num_stripes > max_stripes)
+			num_stripes = max_stripes;
 		if (num_stripes < 2)
 			return -ENOSPC;
 		min_stripes = 2;
@@ -840,6 +860,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
 		num_stripes = btrfs_super_num_devices(info->super_copy);
+		if (num_stripes > max_stripes)
+			num_stripes = max_stripes;
 		if (num_stripes < 3)
 			return -ENOSPC;
 		min_stripes = 3;
-- 
1.8.1.4

