From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 4/8] scrub: bugfix: mirror_num off by one
Date: Thu,  7 Jul 2011 17:48:29 +0200
Message-ID: <a841550267e24b620e00d472bb40bb661005f559.1310053204.git.list.btrfs@jan-o-sch.net>
References: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Fix the mirror_num determination in scrub_stripe. The rest of the scrub code
did not use mirror_num for anything important and that error went unnoticed.
The nodatasum fixup patch of this set depends on a correct mirror_num.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 221fd5c..15fed35 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -930,21 +930,21 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 		offset = map->stripe_len * num;
 		increment = map->stripe_len * map->num_stripes;
-		mirror_num = 0;
+		mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 		int factor = map->num_stripes / map->sub_stripes;
 		offset = map->stripe_len * (num / map->sub_stripes);
 		increment = map->stripe_len * factor;
-		mirror_num = num % map->sub_stripes;
+		mirror_num = num % map->sub_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
 		increment = map->stripe_len;
-		mirror_num = num % map->num_stripes;
+		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
 		increment = map->stripe_len;
-		mirror_num = num % map->num_stripes;
+		mirror_num = num % map->num_stripes + 1;
 	} else {
 		increment = map->stripe_len;
-		mirror_num = 0;
+		mirror_num = 1;
 	}
 
 	path = btrfs_alloc_path();
-- 
1.7.3.4

