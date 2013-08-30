Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51351 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab3H3Orl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:47:41 -0400
Received: by mail-we0-f171.google.com with SMTP id p57so1672359wes.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 07:47:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fusionio.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v5] Btrfs: optimize key searches in btrfs_search_slot
Date: Fri, 30 Aug 2013 15:46:43 +0100
Message-Id: <1377874003-19188-1-git-send-email-fdmanana@gmail.com>
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

Count: 6682
Range: 35.000 - 8370.000; Mean: 85.837; Median: 75.000; Stddev: 106.429
Percentiles:  90th: 124.000; 95th: 145.000; 99th: 206.000
  35.000 -   61.080:  1235 ################
  61.080 -  106.053:  4207 #####################################################
 106.053 -  183.606:  1122 ##############
 183.606 -  317.341:   111 #
 317.341 -  547.959:     6 |
 547.959 - 8370.000:     1 |

Approach proposed by this patch:

Count: 6682
Range:  6.000 - 135.000; Mean: 16.690; Median: 16.000; Stddev:  7.160
Percentiles:  90th: 23.000; 95th: 27.000; 99th: 40.000
   6.000 -    8.418:    58 #
   8.418 -   11.670:  1149 #########################
  11.670 -   16.046:  2418 #####################################################
  16.046 -   21.934:  2098 ##############################################
  21.934 -   29.854:   744 ################
  29.854 -   40.511:   154 ###
  40.511 -   54.848:    41 #
  54.848 -   74.136:     5 |
  74.136 -  100.087:     9 |
 100.087 -  135.000:     6 |

These samples were captured during a run of the btrfs tests 001, 002 and
004 in the xfstests, with a leaf/node size of 4Kb.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simplified code, removed unnecessary code.
V3: Replaced BUG_ON() with the new ASSERT() from Josef.
V4: Addressed latest comments from Zach Brown and Josef Bacik.
    Surrounded all code that is used for the assertion with a
    #ifdef CONFIG_BTRFS_ASSERT ... #endif block. Also changed
    offset arguments to be more strictly correct.
V5: Updated histograms to reflect latest version of the code.

 fs/btrfs/ctree.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5fa521b..6434672 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2426,6 +2426,40 @@ done:
 	return ret;
 }
 
+static void key_search_validate(struct extent_buffer *b,
+				struct btrfs_key *key,
+				int level)
+{
+#ifdef CONFIG_BTRFS_ASSERT
+	struct btrfs_disk_key disk_key;
+
+	btrfs_cpu_key_to_disk(&disk_key, key);
+
+	if (level == 0)
+		ASSERT(!memcmp_extent_buffer(b, &disk_key,
+		    offsetof(struct btrfs_leaf, items[0].key),
+		    sizeof(disk_key)));
+	else
+		ASSERT(!memcmp_extent_buffer(b, &disk_key,
+		    offsetof(struct btrfs_node, ptrs[0].key),
+		    sizeof(disk_key)));
+#endif
+}
+
+static int key_search(struct extent_buffer *b, struct btrfs_key *key,
+		      int level, int *prev_cmp, int *slot)
+{
+	if (*prev_cmp != 0) {
+		*prev_cmp = bin_search(b, key, level, slot);
+		return *prev_cmp;
+	}
+
+	key_search_validate(b, key, level);
+	*slot = 0;
+
+	return 0;
+}
+
 /*
  * look for key in the tree.  path is filled in with nodes along the way
  * if key is found, we return zero and you can find the item in the leaf
@@ -2454,6 +2488,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	int write_lock_level = 0;
 	u8 lowest_level = 0;
 	int min_write_lock_level;
+	int prev_cmp;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
@@ -2484,6 +2519,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	min_write_lock_level = write_lock_level;
 
 again:
+	prev_cmp = -1;
 	/*
 	 * we try very hard to do read locks on the root
 	 */
@@ -2584,7 +2620,7 @@ cow_done:
 		if (!cow)
 			btrfs_unlock_up_safe(p, level + 1);
 
-		ret = bin_search(b, key, level, &slot);
+		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
 			int dec = 0;
@@ -2719,6 +2755,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
+	int prev_cmp;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2729,6 +2766,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 again:
+	prev_cmp = -1;
 	b = get_old_root(root, time_seq);
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
@@ -2746,7 +2784,7 @@ again:
 		 */
 		btrfs_unlock_up_safe(p, level + 1);
 
-		ret = bin_search(b, key, level, &slot);
+		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
 			int dec = 0;
-- 
1.7.9.5

