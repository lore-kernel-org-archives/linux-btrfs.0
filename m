Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcD1DGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 23:06:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 2/2] revert: Btrfs: don't consider the missing device when allocating new chunks
Date: Thu, 28 Apr 2016 11:06:20 +0800
Message-Id: <1461812780-538-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch reverts the commit
 95669976bd7d30ae265db938ecb46a6b7f8cb893
 Btrfs: don't consider the missing device when allocating new chunks

Original code was correct as in the deleted comments
/*
 * we add in the count of missing devices because we want
 * to make sure that any RAID levels on a degraded FS
 * continue to be honored.
 */

The following RFC patch will take care of the original bug
  btrfs: create degraded-RAID1 chunks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent-tree.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 53e12977bfd0..bf60da1020b7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3968,12 +3968,19 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
  */
 static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
-	u64 num_devices = root->fs_info->fs_devices->rw_devices;
+	u64 num_devices;
 	u64 target;
 	u64 raid_type;
 	u64 allowed = 0;
 
 	/*
+	 * we add in the count of missing devices because we want
+	 * to make sure that any RAID levels on a degraded FS
+	 * continue to be honored.
+	 */
+	num_devices = root->fs_info->fs_devices->rw_devices +
+			root->fs_info->fs_devices->missing_devices;
+	/*
 	 * see if restripe for this chunk_type is in progress, if so
 	 * try to reduce to the target profile
 	 */
@@ -9146,7 +9153,13 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	if (stripped)
 		return extended_to_chunk(stripped);
 
-	num_devices = root->fs_info->fs_devices->rw_devices;
+	/*
+	 * we add in the count of missing devices because we want
+	 * to make sure that any RAID levels on a degraded FS
+	 * continue to be honored.
+	 */
+	num_devices = root->fs_info->fs_devices->rw_devices +
+			root->fs_info->fs_devices->missing_devices;
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
-- 
2.7.0

