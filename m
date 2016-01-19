Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbcASAFd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 19:05:33 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove duplicate const specifier
Date: Tue, 19 Jan 2016 00:05:28 +0000
Message-Id: <1453161928-7303-1-git-send-email-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

duplicate const is redundant so remove it

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c32abbc..659c613 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -108,7 +108,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	},
 };
 
-const u64 const btrfs_raid_group[BTRFS_NR_RAID_TYPES] = {
+const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = BTRFS_BLOCK_GROUP_RAID10,
 	[BTRFS_RAID_RAID1]  = BTRFS_BLOCK_GROUP_RAID1,
 	[BTRFS_RAID_DUP]    = BTRFS_BLOCK_GROUP_DUP,
-- 
2.7.0.rc3

