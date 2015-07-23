Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14689 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbbGWJSZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 05:18:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: fsck: Check if a metadata tree block crossing stripe boundary
Date: Thu, 23 Jul 2015 17:18:08 +0800
Message-ID: <1437643090-13920-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel btrfs_map_block() function has a limitation that it can only
map BTRFS_STRIPE_LEN size.
That will cause scrub fails to scrub tree block which crosses strip
boundary, causing BUG_ON().

Normally, it's OK as metadata is always in metadata chunk and
BTRFS_STRIPE_LEN can always be divided by node/leaf size.
So without mixed block group, tree block won't cross stripe boundary.

But for mixed block group, especially for converted btrfs from ext4,
it's almost sure one or more tree blocks are not aligned with node size
and cross stripe boundary.
Causing bug with kernel scrub.

This patch will report the problem, although we don't have a good idea
to fix it in user space until we add the ability to relocate tree block
in user space.

Also, kernel codes should also be checked for such tree block alloc
problem.

Reported-by: Chris Murphy <lists@colorremedies.com>
Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 28 +++++++++++++++++++++++++++-
 volumes.h    | 10 ++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index dd2fce3..49c1f4a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -126,6 +126,7 @@ struct extent_record {
 	unsigned int is_root:1;
 	unsigned int metadata:1;
 	unsigned int bad_full_backref:1;
+	unsigned int crossing_stripes:1;
 };
 
 struct inode_backref {
@@ -3734,7 +3735,7 @@ static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 	if (rec->content_checked && rec->owner_ref_checked &&
 	    rec->extent_item_refs == rec->refs && rec->refs > 0 &&
 	    rec->num_duplicates == 0 && !all_backpointers_checked(rec, 0) &&
-	    !rec->bad_full_backref) {
+	    !rec->bad_full_backref && !rec->crossing_stripes) {
 		remove_cache_extent(extent_cache, &rec->cache);
 		free_all_extent_backrefs(rec);
 		list_del_init(&rec->list);
@@ -4381,6 +4382,15 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		if (rec->max_size < max_size)
 			rec->max_size = max_size;
 
+		/*
+		 * for metadata extent, it can't cross stripe_len boundary, or
+		 * kernel scrub can't handle it
+		 * And now stripe_len is fixed to BTRFS_STRIPE_LEN yet,
+		 * just check it.
+		 */
+		if (metadata && check_crossing_stripes(rec->start,
+						       rec->max_size))
+				rec->crossing_stripes = 1;
 		maybe_free_extent_rec(extent_cache, rec);
 		return ret;
 	}
@@ -4433,6 +4443,10 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		rec->content_checked = 1;
 		rec->owner_ref_checked = 1;
 	}
+
+	if (metadata)
+		if (check_crossing_stripes(rec->start, rec->max_size))
+			rec->crossing_stripes = 1;
 	return ret;
 }
 
@@ -7478,6 +7492,18 @@ static int check_extent_refs(struct btrfs_root *root,
 			err = 1;
 			cur_err = 1;
 		}
+		/*
+		 * Although it's not a extent ref problem, still reuse this
+		 * routine for error reporting
+		 * No repair function yet.
+		 */
+		if (rec->crossing_stripes) {
+			fprintf(stderr,
+				"bad metadata [%llu, %llu) crossing stripe boundary\n",
+				rec->start, rec->start + rec->max_size);
+			err = 1;
+			cur_err = 1;
+		}
 
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
diff --git a/volumes.h b/volumes.h
index 99a3fa1..71d5d66 100644
--- a/volumes.h
+++ b/volumes.h
@@ -148,6 +148,16 @@ struct map_lookup {
 #define BTRFS_RAID5_P_STRIPE ((u64)-2)
 #define BTRFS_RAID6_Q_STRIPE ((u64)-1)
 
+/*
+ * Check if the given range cross stripes.
+ * To ensure kernel scrub won't causing bug on with METADATA in mixed
+ * block group
+ */
+static inline int check_crossing_stripes(u64 start, u64 len)
+{
+	return (start / BTRFS_STRIPE_LEN) !=
+	       ((start + len) / BTRFS_STRIPE_LEN);
+}
 
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      u64 logical, u64 *length, u64 *type,
-- 
2.4.6

