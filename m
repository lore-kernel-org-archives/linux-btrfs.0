From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: fix repair code for RAID10
Date: Wed, 25 Apr 2012 13:42:51 +0200
Message-ID: <1335354171-16608-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: remco@hosman.xs4all.nl
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_map_block sets mirror_num, so that the repair code knows eventually
which device gave us the read error. For RAID10, mirror_num must be 1 or 2.
Before this fix mirror_num was incorrectly related to our stripe index.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3b98417..1411b99 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3807,10 +3807,11 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
 		else {
+			int old_stripe_index = stripe_index;
 			stripe_index = find_live_mirror(map, stripe_index,
 					      map->sub_stripes, stripe_index +
 					      current->pid % map->sub_stripes);
-			mirror_num = stripe_index + 1;
+			mirror_num = stripe_index - old_stripe_index + 1;
 		}
 	} else {
 		/*
-- 
1.7.3.4

