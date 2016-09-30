Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12746 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S935466AbcI3FFW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 01:05:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/4] btrfs-progs: volumes: Remove BUG_ON in raid56 write routine
Date: Fri, 30 Sep 2016 13:04:55 +0800
Message-Id: <20160930050457.22584-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
References: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove various BUG_ON in raid56 write routine, including:
1) Memory allocation error
2) Write error
3) Validation check

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Split patch
  Remove all BUG_ON() in raid56 write routine.
---
 volumes.c | 84 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 35 deletions(-)

diff --git a/volumes.c b/volumes.c
index da79751..93ce934 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2061,8 +2061,8 @@ static int rmw_eb(struct btrfs_fs_info *info,
 	return 0;
 }
 
-static void split_eb_for_raid56(struct btrfs_fs_info *info,
-				struct extent_buffer *orig_eb,
+static int split_eb_for_raid56(struct btrfs_fs_info *info,
+			       struct extent_buffer *orig_eb,
 			       struct extent_buffer **ebs,
 			       u64 stripe_len, u64 *raid_map,
 			       int num_stripes)
@@ -2071,34 +2071,38 @@ static void split_eb_for_raid56(struct btrfs_fs_info *info,
 	u64 start = orig_eb->start;
 	u64 this_eb_start;
 	int i;
-	int ret;
+	int ret = 0;
 
+	eb = calloc(num_stripes, sizeof(*eb) + stripe_len);
+	if (!eb)
+		return -ENOMEM;
 	for (i = 0; i < num_stripes; i++) {
 		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
 			break;
 
-		eb = calloc(1, sizeof(struct extent_buffer) + stripe_len);
-		if (!eb)
-			BUG();
-
-		eb->start = raid_map[i];
-		eb->len = stripe_len;
-		eb->refs = 1;
-		eb->flags = 0;
-		eb->fd = -1;
-		eb->dev_bytenr = (u64)-1;
+		eb[i].start = raid_map[i];
+		eb[i].len = stripe_len;
+		eb[i].refs = 1;
+		eb[i].flags = 0;
+		eb[i].fd = -1;
+		eb[i].dev_bytenr = (u64)-1;
 
 		this_eb_start = raid_map[i];
 
 		if (start > this_eb_start ||
 		    start + orig_eb->len < this_eb_start + stripe_len) {
 			ret = rmw_eb(info, eb, orig_eb);
-			BUG_ON(ret);
+			if (ret)
+				break;
 		} else {
-			memcpy(eb->data, orig_eb->data + eb->start - start, stripe_len);
+			memcpy(eb->data, orig_eb->data + eb->start - start,
+			       stripe_len);
 		}
-		ebs[i] = eb;
+		ebs[i] = &eb[i];
 	}
+	if (ret)
+		free(eb);
+	return ret;
 }
 
 int write_raid56_with_parity(struct btrfs_fs_info *info,
@@ -2111,15 +2115,20 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 	int j;
 	int ret;
 	int alloc_size = eb->len;
+	void **pointers;
 
-	ebs = kmalloc(sizeof(*ebs) * multi->num_stripes, GFP_NOFS);
-	BUG_ON(!ebs);
+	ebs = malloc(sizeof(*ebs) * multi->num_stripes);
+	pointers = malloc(sizeof(*pointers) * multi->num_stripes);
+	if (!ebs || !pointers)
+		return -ENOMEM;
 
 	if (stripe_len > alloc_size)
 		alloc_size = stripe_len;
 
-	split_eb_for_raid56(info, eb, ebs, stripe_len, raid_map,
-			    multi->num_stripes);
+	ret = split_eb_for_raid56(info, eb, ebs, stripe_len, raid_map,
+				  multi->num_stripes);
+	if (ret)
+		goto out;
 
 	for (i = 0; i < multi->num_stripes; i++) {
 		struct extent_buffer *new_eb;
@@ -2127,11 +2136,17 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			ebs[i]->dev_bytenr = multi->stripes[i].physical;
 			ebs[i]->fd = multi->stripes[i].dev->fd;
 			multi->stripes[i].dev->total_ios++;
-			BUG_ON(ebs[i]->start != raid_map[i]);
+			if (ebs[i]->start != raid_map[i]) {
+				ret = -EINVAL;
+				goto out_free_split;
+			}
 			continue;
 		}
-		new_eb = kmalloc(sizeof(*eb) + alloc_size, GFP_NOFS);
-		BUG_ON(!new_eb);
+		new_eb = malloc(sizeof(*eb) + alloc_size);
+		if (!new_eb) {
+			ret = -ENOMEM;
+			goto out_free_split;
+		}
 		new_eb->dev_bytenr = multi->stripes[i].physical;
 		new_eb->fd = multi->stripes[i].dev->fd;
 		multi->stripes[i].dev->total_ios++;
@@ -2143,12 +2158,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			q_eb = new_eb;
 	}
 	if (q_eb) {
-		void **pointers;
-
-		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes,
-				   GFP_NOFS);
-		BUG_ON(!pointers);
-
 		ebs[multi->num_stripes - 2] = p_eb;
 		ebs[multi->num_stripes - 1] = q_eb;
 
@@ -2156,7 +2165,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			pointers[i] = ebs[i]->data;
 
 		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
-		kfree(pointers);
 	} else {
 		ebs[multi->num_stripes - 1] = p_eb;
 		memcpy(p_eb->data, ebs[0]->data, stripe_len);
@@ -2175,12 +2183,18 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 
 	for (i = 0; i < multi->num_stripes; i++) {
 		ret = write_extent_to_disk(ebs[i]);
-		BUG_ON(ret);
-		if (ebs[i] != eb)
-			kfree(ebs[i]);
+		if (ret < 0)
+			goto out_free_split;
 	}
 
-	kfree(ebs);
+out_free_split:
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (ebs[i] != eb)
+			free(ebs[i]);
+	}
+out:
+	free(ebs);
+	free(pointers);
 
-	return 0;
+	return ret;
 }
-- 
2.10.0



