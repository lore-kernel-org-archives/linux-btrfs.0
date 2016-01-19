Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbcASKoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:44:04 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Colin Ian King <colin.king@canonical.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: remove duplicate const specifier
Date: Tue, 19 Jan 2016 11:43:57 +0100
Message-Id: <fb75d857a31d600cc0c37b8c7d914014f7fa3f9a.1453199864.git.dsterba@suse.com>
In-Reply-To: <cover.1453199864.git.dsterba@suse.com>
References: <cover.1453199864.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

duplicate const is redundant so remove it

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9cb78e31fc76..78f76958b855 100644
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
2.6.3

