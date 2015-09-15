Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28579 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbbIONJu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 09:09:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8FD9WoW016741
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 21:09:32 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: use btrfs_raid_array in btrfs_reduce_alloc_profile
Date: Tue, 15 Sep 2015 21:08:08 +0800
Message-ID: <ba0f699bf154843d8fb3456156457b297197c749.1442322310.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
References: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_raid_array[] holds attributes of all raid types.

Use btrfs_raid_array[].devs_min is best way for request
in btrfs_reduce_alloc_profile(), instead of use complex
condition of each raid types.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5411f0a..0d93cad 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3822,7 +3822,8 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices = root->fs_info->fs_devices->rw_devices;
 	u64 target;
-	u64 tmp;
+	u64 raid_type;
+	u64 allowed = 0;
 
 	/*
 	 * see if restripe for this chunk_type is in progress, if so
@@ -3840,31 +3841,26 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	spin_unlock(&root->fs_info->balance_lock);
 
 	/* First, mask out the RAID levels which aren't possible */
-	if (num_devices == 1)
-		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0 |
-			   BTRFS_BLOCK_GROUP_RAID5);
-	if (num_devices < 3)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID6;
-	if (num_devices < 4)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
-
-	tmp = flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
-		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID5 |
-		       BTRFS_BLOCK_GROUP_RAID6 | BTRFS_BLOCK_GROUP_RAID10);
-	flags &= ~tmp;
-
-	if (tmp & BTRFS_BLOCK_GROUP_RAID6)
-		tmp = BTRFS_BLOCK_GROUP_RAID6;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID5)
-		tmp = BTRFS_BLOCK_GROUP_RAID5;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID10)
-		tmp = BTRFS_BLOCK_GROUP_RAID10;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID1)
-		tmp = BTRFS_BLOCK_GROUP_RAID1;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID0)
-		tmp = BTRFS_BLOCK_GROUP_RAID0;
-
-	return extended_to_chunk(flags | tmp);
+	for (raid_type = 0; raid_type < BTRFS_NR_RAID_TYPES; raid_type++) {
+		if (num_devices >= btrfs_raid_array[raid_type].devs_min)
+			allowed |= btrfs_raid_group[raid_type];
+	}
+	allowed &= flags;
+
+	if (allowed & BTRFS_BLOCK_GROUP_RAID6)
+		allowed = BTRFS_BLOCK_GROUP_RAID6;
+	else if (allowed & BTRFS_BLOCK_GROUP_RAID5)
+		allowed = BTRFS_BLOCK_GROUP_RAID5;
+	else if (allowed & BTRFS_BLOCK_GROUP_RAID10)
+		allowed = BTRFS_BLOCK_GROUP_RAID10;
+	else if (allowed & BTRFS_BLOCK_GROUP_RAID1)
+		allowed = BTRFS_BLOCK_GROUP_RAID1;
+	else if (allowed & BTRFS_BLOCK_GROUP_RAID0)
+		allowed = BTRFS_BLOCK_GROUP_RAID0;
+
+	flags &= ~BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	return extended_to_chunk(flags | allowed);
 }
 
 static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
-- 
1.8.5.1

