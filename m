Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38128 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:16 -0400
Received: by mail-qt0-f195.google.com with SMTP id x7-v6so11304534qtk.5
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:01 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 18/35] btrfs: set max_extent_size properly
Date: Thu, 30 Aug 2018 13:42:08 -0400
Message-Id: <20180830174225.2200-19-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We can't use entry->bytes if our entry is a bitmap entry, we need to use
entry->max_extent_size in that case.  Fix up all the logic to make this
consistent.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/free-space-cache.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index db93a5f035a0..53521027dd78 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1766,6 +1766,18 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	return -1;
 }
 
+static void set_max_extent_size(struct btrfs_free_space *entry,
+				u64 *max_extent_size)
+{
+	if (entry->bitmap) {
+		if (entry->max_extent_size > *max_extent_size)
+			*max_extent_size = entry->max_extent_size;
+	} else {
+		if (entry->bytes > *max_extent_size)
+			*max_extent_size = entry->bytes;
+	}
+}
+
 /* Cache the size of the max extent in bytes */
 static struct btrfs_free_space *
 find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
@@ -1787,8 +1799,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 	for (node = &entry->offset_index; node; node = rb_next(node)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		if (entry->bytes < *bytes) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			set_max_extent_size(entry, max_extent_size);
 			continue;
 		}
 
@@ -1806,8 +1817,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		}
 
 		if (entry->bytes < *bytes + align_off) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			set_max_extent_size(entry, max_extent_size);
 			continue;
 		}
 
@@ -1819,8 +1829,8 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 				*offset = tmp;
 				*bytes = size;
 				return entry;
-			} else if (size > *max_extent_size) {
-				*max_extent_size = size;
+			} else {
+				set_max_extent_size(entry, max_extent_size);
 			}
 			continue;
 		}
@@ -2680,8 +2690,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	err = search_bitmap(ctl, entry, &search_start, &search_bytes, true);
 	if (err) {
-		if (search_bytes > *max_extent_size)
-			*max_extent_size = search_bytes;
+		set_max_extent_size(entry, max_extent_size);
 		return 0;
 	}
 
@@ -2718,8 +2727,8 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	while (1) {
-		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
-			*max_extent_size = entry->bytes;
+		if (entry->bytes < bytes)
+			set_max_extent_size(entry, max_extent_size);
 
 		if (entry->bytes < bytes ||
 		    (!entry->bitmap && entry->offset < min_start)) {
-- 
2.14.3
