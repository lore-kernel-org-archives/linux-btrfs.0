Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43148 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbaEERkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 13:40:25 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMq-0007ak-1D
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 17:07:52 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.82)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0002Pg-Lc
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 18:07:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs check: Pre-sort keys in a block while searching
Date: Mon,  5 May 2014 18:07:50 +0100
Message-Id: <1399309671-9240-3-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
References: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we think we might have a messed-up block with keys out of order
(e.g. during fsck), we still need to be able to find a key in the block.
To deal with this, we copy the keys, keeping track of where they came from
in the original node/leaf, sort them, and then do the binary search.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-check.c |  1 +
 ctree.c      | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 ctree.h      |  2 ++
 3 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fc84ad8..b2e4a46 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2439,6 +2439,7 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(buf);
 	path->lowest_level = level;
 	path->skip_check_block = 1;
+	path->bin_search_presort = 1;
 	if (level)
 		btrfs_node_key_to_cpu(buf, &k1, 0);
 	else
diff --git a/ctree.c b/ctree.c
index 9e5b30f..30e1785 100644
--- a/ctree.c
+++ b/ctree.c
@@ -388,6 +388,16 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
 	return 0;
 }
 
+int btrfs_comp_disk_keys(struct btrfs_disk_key *dk1,
+			 struct btrfs_disk_key *dk2)
+{
+	struct btrfs_key k1, k2;
+
+	btrfs_disk_key_to_cpu(&k1, dk1);
+	btrfs_disk_key_to_cpu(&k2, dk2);
+	return btrfs_comp_cpu_keys(&k1, &k2);
+}
+
 /*
  * compare two keys in a memcmp fashion
  */
@@ -598,25 +608,73 @@ static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
 	return 1;
 }
 
+static int cmp_disk_keys(const void *k1, const void *k2)
+{
+	return btrfs_comp_disk_keys((struct btrfs_disk_key *)k1, (struct btrfs_disk_key *)k2);
+}
+
+/* Copy the item keys and their original positions into a second
+ * extent buffer, which can be safely passed to generic_bin_search in
+ * the case where the keys might be out of order.
+ */
+static void sort_key_copy(struct extent_buffer *tgt, struct extent_buffer *src,
+			  int offset, int item_size, int nitems)
+{
+	struct btrfs_disk_key *src_item;
+	struct btrfs_item *tgt_item;
+	int i;
+
+	for (i = 0; i < nitems; i++) {
+		/* We abuse the struct btrfs_item slightly here: the key
+		 * is the key we care about; the offset field is the
+		 * original slot number */
+		src_item = (struct btrfs_disk_key *)(src->data + offset + i*item_size);
+		tgt_item = (struct btrfs_item *)(tgt->data + i*sizeof(struct btrfs_item));
+		memcpy(tgt_item, src_item, sizeof(struct btrfs_disk_key));
+		tgt_item->offset = i;
+	}
+	qsort(tgt->data, nitems, sizeof(struct btrfs_item), cmp_disk_keys);
+}
+
 /*
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
 static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
-		      int level, int *slot)
+		      int level, int pre_sort, int *slot)
 {
-	if (level == 0)
-		return generic_bin_search(eb,
-					  offsetof(struct btrfs_leaf, items),
-					  sizeof(struct btrfs_item),
-					  key, btrfs_header_nritems(eb),
-					  slot);
-	else
-		return generic_bin_search(eb,
-					  offsetof(struct btrfs_node, ptrs),
-					  sizeof(struct btrfs_key_ptr),
-					  key, btrfs_header_nritems(eb),
-					  slot);
+	struct extent_buffer *sorted = NULL;
+	int ret;
+	int offset, size, nritems;
+
+	if (level == 0) {
+		offset = offsetof(struct btrfs_leaf, items);
+		size = sizeof(struct btrfs_item);
+	} else {
+		offset = offsetof(struct btrfs_node, ptrs);
+		size = sizeof(struct btrfs_key_ptr);
+	}
+	nritems = btrfs_header_nritems(eb);
+
+	if (pre_sort) {
+		sorted = alloc_extent_buffer(eb->tree, eb->dev_bytenr, eb->len);
+		sort_key_copy(sorted, eb, offset, size, nritems);
+		offset = 0;
+		size = sizeof(struct btrfs_item);
+		eb = sorted;
+	}
+
+	ret = generic_bin_search(eb, offset, size, key, nritems, slot);
+
+	if (pre_sort) {
+		/* We have the sorted slot number, which is probably unhelpful
+		   if the sort changed the order. So, return the original slot
+		   number, not the sorted position. */
+		*slot = ((struct btrfs_item *)(eb->data + (*slot)*size))->offset;
+		free_extent_buffer(sorted);
+	}
+
+	return ret;
 }
 
 struct extent_buffer *read_node_slot(struct btrfs_root *root,
@@ -1075,7 +1133,7 @@ again:
 		ret = check_block(root, p, level);
 		if (ret)
 			return -1;
-		ret = bin_search(b, key, level, &slot);
+		ret = bin_search(b, key, level, p->bin_search_presort, &slot);
 		if (level != 0) {
 			if (ret && slot > 0)
 				slot -= 1;
diff --git a/ctree.h b/ctree.h
index a4d2cd1..4668446 100644
--- a/ctree.h
+++ b/ctree.h
@@ -540,6 +540,8 @@ struct btrfs_path {
 	int reada;
 	/* keep some upper locks as we walk down */
 	int lowest_level;
+	/* For check: Sort the keys in a block before applying a binary search */
+	int bin_search_presort;
 
 	/*
 	 * set by btrfs_split_item, tells search_slot to keep all locks
-- 
1.9.2

