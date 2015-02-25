Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbbBYSYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:52 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A2793AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 06/11] btrfs: cleanup, use correct type in div_u64_rem
Date: Wed, 25 Feb 2015 19:24:51 +0100
Message-Id: <bef81c419cfb7d8951e4e1fc1ad0f7531418313d.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

div_u64_rem expects u32 for divisior and reminder.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/scrub.c   |  6 +++---
 fs/btrfs/volumes.c | 11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4cdf739c7a47..5c3ca68b1fb4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2319,7 +2319,7 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
 				       unsigned long *bitmap,
 				       u64 start, u64 len)
 {
-	int offset;
+	u32 offset;
 	int nsectors;
 	int sectorsize = sparity->sctx->dev_root->sectorsize;
 
@@ -2612,8 +2612,8 @@ static int get_raid56_logic_offset(u64 physical, int num,
 	int j = 0;
 	u64 stripe_nr;
 	u64 last_offset;
-	int stripe_index;
-	int rot;
+	u32 stripe_index;
+	u32 rot;
 
 	last_offset = (physical - map->stripes[num].physical) *
 		      nr_data_stripes(map);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b7755924bc7f..5f3133e5390b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4953,7 +4953,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	u64 stripe_nr_orig;
 	u64 stripe_nr_end;
 	u64 stripe_len;
-	int stripe_index;
+	u32 stripe_index;
 	int i;
 	int ret = 0;
 	int num_stripes;
@@ -5171,7 +5171,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
-		int factor = map->num_stripes / map->sub_stripes;
+		u32 factor = map->num_stripes / map->sub_stripes;
 
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
@@ -5264,7 +5264,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	    need_raid_map && ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
 	    mirror_num > 1)) {
 		u64 tmp;
-		int i, rot;
+		int i;
+		unsigned rot;
 
 		bbio->raid_map = (u64 *)((void *)bbio->stripes +
 				 sizeof(struct btrfs_bio_stripe) *
@@ -5287,8 +5288,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	}
 
 	if (rw & REQ_DISCARD) {
-		int factor = 0;
-		int sub_stripes = 0;
+		u32 factor = 0;
+		u32 sub_stripes = 0;
 		u64 stripes_per_dev = 0;
 		u32 remaining_stripes = 0;
 		u32 last_stripe = 0;
-- 
2.1.3

