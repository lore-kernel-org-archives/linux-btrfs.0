Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbaDUMRf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 08:17:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3LCHX83032312
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 20:17:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: add dev maxs limit for __btrfs_alloc_chunk in kernel space
Date: Mon, 21 Apr 2014 20:13:12 +0800
Message-ID: <1398082392-5755-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1398082392-5755-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1398082392-5755-1-git-send-email-guihc.fnst@cn.fujitsu.com>
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
 fs/btrfs/volumes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 302f956..3d1b74b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3974,6 +3974,16 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 	btrfs_set_fs_incompat(info, RAID56);
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
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *extent_root, u64 start,
 			       u64 type)
@@ -4023,6 +4033,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size = 1024 * 1024 * 1024;
 		max_chunk_size = 10 * max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 		/* for larger filesystems, use larger metadata chunks */
 		if (fs_devices->total_rw_bytes > 50ULL * 1024 * 1024 * 1024)
@@ -4030,9 +4042,13 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		else
 			max_stripe_size = 256 * 1024 * 1024;
 		max_chunk_size = max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		max_stripe_size = 32 * 1024 * 1024;
 		max_chunk_size = 2 * max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS_SYS_CHUNK;
 	} else {
 		btrfs_err(info, "invalid chunk type 0x%llx requested\n",
 		       type);
-- 
1.8.1.4

