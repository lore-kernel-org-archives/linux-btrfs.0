From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 07/11] Btrfs: don't pre-allocate btrfs bio
Date: Wed, 11 Jan 2012 13:53:51 +0800
Message-ID: <4F0D23EF.9000103@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We pre-allocate a btrfs bio with fixed size, and then may re-allocate
memory if we find stripes are bigger than the fixed size. But this
pre-allocation is not necessary.

Also we don't have to calcuate the stripe number twice.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   67 ++++++++++++++++-----------------------------------
 1 files changed, 21 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73f673c..540fdd2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2897,26 +2897,13 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	u64 stripe_nr;
 	u64 stripe_nr_orig;
 	u64 stripe_nr_end;
-	int stripes_allocated = 8;
-	int stripes_required = 1;
 	int stripe_index;
 	int i;
+	int ret = 0;
 	int num_stripes;
 	int max_errors = 0;
 	struct btrfs_bio *bbio = NULL;
 
-	if (bbio_ret && !(rw & (REQ_WRITE | REQ_DISCARD)))
-		stripes_allocated = 1;
-again:
-	if (bbio_ret) {
-		bbio = kzalloc(btrfs_bio_size(stripes_allocated),
-				GFP_NOFS);
-		if (!bbio)
-			return -ENOMEM;
-
-		atomic_set(&bbio->error, 0);
-	}
-
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
@@ -2935,32 +2922,6 @@ again:
 	if (mirror_num > map->num_stripes)
 		mirror_num = 0;
 
-	/* if our btrfs_bio struct is too small, back off and try again */
-	if (rw & REQ_WRITE) {
-		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
-				 BTRFS_BLOCK_GROUP_DUP)) {
-			stripes_required = map->num_stripes;
-			max_errors = 1;
-		} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
-			stripes_required = map->sub_stripes;
-			max_errors = 1;
-		}
-	}
-	if (rw & REQ_DISCARD) {
-		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
-				 BTRFS_BLOCK_GROUP_RAID1 |
-				 BTRFS_BLOCK_GROUP_DUP |
-				 BTRFS_BLOCK_GROUP_RAID10)) {
-			stripes_required = map->num_stripes;
-		}
-	}
-	if (bbio_ret && (rw & (REQ_WRITE | REQ_DISCARD)) &&
-	    stripes_allocated < stripes_required) {
-		stripes_allocated = map->num_stripes;
-		free_extent_map(em);
-		kfree(bbio);
-		goto again;
-	}
 	stripe_nr = offset;
 	/*
 	 * stripe_nr counts the total number of stripes we have to stride
@@ -3055,6 +3016,13 @@ again:
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
+	bbio = kzalloc(btrfs_bio_size(num_stripes), GFP_NOFS);
+	if (!bbio) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	atomic_set(&bbio->error, 0);
+
 	if (rw & REQ_DISCARD) {
 		for (i = 0; i < num_stripes; i++) {
 			bbio->stripes[i].physical =
@@ -3151,15 +3119,22 @@ again:
 			stripe_index++;
 		}
 	}
-	if (bbio_ret) {
-		*bbio_ret = bbio;
-		bbio->num_stripes = num_stripes;
-		bbio->max_errors = max_errors;
-		bbio->mirror_num = mirror_num;
+
+	if (rw & REQ_WRITE) {
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				 BTRFS_BLOCK_GROUP_RAID10 |
+				 BTRFS_BLOCK_GROUP_DUP)) {
+			max_errors = 1;
+		}
 	}
+
+	*bbio_ret = bbio;
+	bbio->num_stripes = num_stripes;
+	bbio->max_errors = max_errors;
+	bbio->mirror_num = mirror_num;
 out:
 	free_extent_map(em);
-	return 0;
+	return ret;
 }
 
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-- 
1.7.3.1
