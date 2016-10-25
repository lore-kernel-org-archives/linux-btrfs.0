Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38021 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1758182AbcJYCLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 22:11:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/4] btrfs-progs: volumes: Remove BUG_ON in raid56 write routine
Date: Tue, 25 Oct 2016 10:11:04 +0800
Message-Id: <20161025021106.30842-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161025021106.30842-1-quwenruo@cn.fujitsu.com>
References: <20161025021106.30842-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove various BUG_ON in raid56 write routine, including:
1) Memory allocation error
   Old codes allocates memory when code needs new memory in a loop, and
   catch the error using BUG_ON().
   New codes allocates memory in a allocation loop first, if any failure
   is caught, freeing already allocated memories then throw -ENOMEM.

2) Write error
   Change BUG_ON() to correct return value.

3) Validation check
   Same as write error.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
changelog:
v2:
  Fix error in calloc usage which leads to double free() on data
  stripes.
  Thanks David for pointing it out.
---
 volumes.c | 89 +++++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 28 deletions(-)

diff --git a/volumes.c b/volumes.c
index b9ca550..70d8940 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2063,25 +2063,39 @@ static int rmw_eb(struct btrfs_fs_info *info,
 	return 0;
 }
 
-static void split_eb_for_raid56(struct btrfs_fs_info *info,
-				struct extent_buffer *orig_eb,
+static int split_eb_for_raid56(struct btrfs_fs_info *info,
+			       struct extent_buffer *orig_eb,
 			       struct extent_buffer **ebs,
 			       u64 stripe_len, u64 *raid_map,
 			       int num_stripes)
 {
-	struct extent_buffer *eb;
+	struct extent_buffer **tmp_ebs;
 	u64 start = orig_eb->start;
 	u64 this_eb_start;
 	int i;
-	int ret;
+	int ret = 0;
+
+	tmp_ebs = calloc(num_stripes, sizeof(*tmp_ebs));
+	if (!tmp_ebs)
+		return -ENOMEM;
 
+	/* Alloc memory in a row for data stripes */
 	for (i = 0; i < num_stripes; i++) {
 		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
 			break;
 
-		eb = calloc(1, sizeof(struct extent_buffer) + stripe_len);
-		if (!eb)
-			BUG();
+		tmp_ebs[i] = calloc(1, sizeof(**tmp_ebs) + stripe_len);
+		if (!tmp_ebs[i]) {
+			ret = -ENOMEM;
+			goto clean_up;
+		}
+	}
+
+	for (i = 0; i < num_stripes; i++) {
+		struct extent_buffer *eb = tmp_ebs[i];
+
+		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
+			break;
 
 		eb->start = raid_map[i];
 		eb->len = stripe_len;
@@ -2095,12 +2109,21 @@ static void split_eb_for_raid56(struct btrfs_fs_info *info,
 		if (start > this_eb_start ||
 		    start + orig_eb->len < this_eb_start + stripe_len) {
 			ret = rmw_eb(info, eb, orig_eb);
-			BUG_ON(ret);
+			if (ret)
+				goto clean_up;
 		} else {
-			memcpy(eb->data, orig_eb->data + eb->start - start, stripe_len);
+			memcpy(eb->data, orig_eb->data + eb->start - start,
+			       stripe_len);
 		}
 		ebs[i] = eb;
 	}
+	free(tmp_ebs);
+	return ret;
+clean_up:
+	for (i = 0; i < num_stripes; i++)
+		free(tmp_ebs[i]);
+	free(tmp_ebs);
+	return ret;
 }
 
 int write_raid56_with_parity(struct btrfs_fs_info *info,
@@ -2113,15 +2136,20 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
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
@@ -2129,11 +2157,17 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
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
@@ -2145,12 +2179,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
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
 
@@ -2158,7 +2186,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			pointers[i] = ebs[i]->data;
 
 		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
-		kfree(pointers);
 	} else {
 		ebs[multi->num_stripes - 1] = p_eb;
 		memcpy(p_eb->data, ebs[0]->data, stripe_len);
@@ -2177,12 +2204,18 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 
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
2.10.1



