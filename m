Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55560 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3H2OAk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 10:00:40 -0400
Received: by mail-wg0-f44.google.com with SMTP id x12so449766wgg.11
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 07:00:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: optimize key searches in btrfs_search_slot
Date: Thu, 29 Aug 2013 14:59:26 +0100
Message-Id: <1377784766-7552-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the binary search returns 0 (exact match), the target key
will necessarily be at slot 0 of all nodes below the current one,
so in this case the binary search is not needed because it will
always return 0, and we waste time doing it, holding node locks
for longer than necessary, etc.

Below follow histograms with the times spent on the current approach of
doing a binary search when the previous binary search returned 0, and
times for the new approach, which directly picks the first item/child
node in the leaf/node.

Current approach:

Count: 5013
Range: 25.000 - 497.000; Mean: 82.767; Median: 64.000; Stddev: 49.972
Percentiles:  90th: 141.000; 95th: 182.000; 99th: 287.000
  25.000 -   33.930:   211 ######
  33.930 -   45.927:   277 ########
  45.927 -   62.045:  1834 #####################################################
  62.045 -   83.699:  1203 ###################################
  83.699 -  112.789:   609 ##################
 112.789 -  151.872:   450 #############
 151.872 -  204.377:   246 #######
 204.377 -  274.917:   124 ####
 274.917 -  369.684:    48 #
 369.684 -  497.000:    11 |

Approach proposed by this patch:

Count: 5013
Range: 10.000 - 8303.000; Mean: 28.505; Median: 18.000; Stddev: 119.147
Percentiles:  90th: 49.000; 95th: 74.000; 99th: 115.000
 10.000 -   20.339:  3160 #####################################################
 20.339 -   40.397:  1131 ###################
 40.397 -   79.308:   507 #########
 79.308 -  154.794:   199 ###
154.794 -  301.232:    14 |
301.232 -  585.313:     1 |
585.313 - 8303.000:     1 |

These samples were captured during a run of the btrfs tests 001, 002 and
004 in the xfstests, with a leaf/node size of 4Kb.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simplified code, removed unnecessary code.
V3: Replaced BUG_ON() with the new ASSERT() from Josef.

 fs/btrfs/ctree.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5fa521b..b69dd46 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2426,6 +2426,42 @@ done:
 	return ret;
 }
 
+static int key_search(struct extent_buffer *b, struct btrfs_key *key,
+		      int level, int *prev_cmp, int *slot)
+{
+	char *kaddr = NULL;
+	unsigned long map_start = 0;
+	unsigned long map_len = 0;
+	unsigned long offset;
+	struct btrfs_disk_key *k = NULL;
+	struct btrfs_disk_key unaligned;
+	int err;
+
+	if (*prev_cmp != 0) {
+		*prev_cmp = bin_search(b, key, level, slot);
+		return *prev_cmp;
+	}
+
+	if (level == 0)
+		offset = offsetof(struct btrfs_leaf, items);
+	else
+		offset = offsetof(struct btrfs_node, ptrs);
+
+	err = map_private_extent_buffer(b, offset, sizeof(struct btrfs_disk_key),
+					&kaddr, &map_start, &map_len);
+	if (!err) {
+		k = (struct btrfs_disk_key *)(kaddr + offset - map_start);
+	} else {
+		read_extent_buffer(b, &unaligned, offset, sizeof(unaligned));
+		k = &unaligned;
+	}
+
+	ASSERT(comp_keys(k, key) == 0);
+	*slot = 0;
+
+	return 0;
+}
+
 /*
  * look for key in the tree.  path is filled in with nodes along the way
  * if key is found, we return zero and you can find the item in the leaf
@@ -2454,6 +2490,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	int write_lock_level = 0;
 	u8 lowest_level = 0;
 	int min_write_lock_level;
+	int prev_cmp;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
@@ -2484,6 +2521,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	min_write_lock_level = write_lock_level;
 
 again:
+	prev_cmp = -1;
 	/*
 	 * we try very hard to do read locks on the root
 	 */
@@ -2584,7 +2622,7 @@ cow_done:
 		if (!cow)
 			btrfs_unlock_up_safe(p, level + 1);
 
-		ret = bin_search(b, key, level, &slot);
+		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
 			int dec = 0;
@@ -2719,6 +2757,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
+	int prev_cmp;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2729,6 +2768,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 again:
+	prev_cmp = -1;
 	b = get_old_root(root, time_seq);
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
@@ -2746,7 +2786,7 @@ again:
 		 */
 		btrfs_unlock_up_safe(p, level + 1);
 
-		ret = bin_search(b, key, level, &slot);
+		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
 			int dec = 0;
-- 
1.7.9.5

