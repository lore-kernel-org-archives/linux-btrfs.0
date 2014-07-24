Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758715AbaGXDfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:42 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZcHB017409
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/10] Btrfs: don't consider the missing device when allocating new chunks
Date: Thu, 24 Jul 2014 11:37:14 +0800
Message-ID: <1406173035-29478-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original code allocated new chunks by the number of the writable devices
and missing devices to make sure that any RAID levels on a degraded FS continue
to be honored, but it introduced a problem that it stopped us to allocating
new chunks, the steps to reproduce is following:

 # mkfs.btrfs -m raid1 -d raid1 -f <dev0> <dev1>
 # mkfs.btrfs -f <dev1>			//Removing <dev1> from the original fs
 # mount -o degraded <dev0> <mnt>
 # dd if=/dev/null of=<mnt>/tmpfile bs=1M

It is because we allocate new chunks only on the writable devices, if we take
the number of missing devices into account, and want to allocate new chunks
with higher RAID level, we will fail becaue we don't have enough writable
device. Fix it by ignoring the number of missing devices when allocating
new chunks.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 813537f..f778035 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3586,13 +3586,7 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
  */
 static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
-	/*
-	 * we add in the count of missing devices because we want
-	 * to make sure that any RAID levels on a degraded FS
-	 * continue to be honored.
-	 */
-	u64 num_devices = root->fs_info->fs_devices->rw_devices +
-		root->fs_info->fs_devices->missing_devices;
+	u64 num_devices = root->fs_info->fs_devices->rw_devices;
 	u64 target;
 	u64 tmp;
 
@@ -8181,13 +8175,7 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	if (stripped)
 		return extended_to_chunk(stripped);
 
-	/*
-	 * we add in the count of missing devices because we want
-	 * to make sure that any RAID levels on a degraded FS
-	 * continue to be honored.
-	 */
-	num_devices = root->fs_info->fs_devices->rw_devices +
-		root->fs_info->fs_devices->missing_devices;
+	num_devices = root->fs_info->fs_devices->rw_devices;
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
-- 
1.9.3

