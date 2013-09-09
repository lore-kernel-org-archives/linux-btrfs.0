Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36639 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3IIUmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 16:42:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 290029A067E
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Sep 2013 14:42:07 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id SnzMqGCqZsVK0G9G (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2013 14:42:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs-progs: make btrfsck fix backrefs that are broken
Date: Mon, 9 Sep 2013 16:41:56 -0400
Message-ID: <1378759318-3305-3-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1378759318-3305-1-git-send-email-jbacik@fusionio.com>
References: <1378759318-3305-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you set an file extent item's disk_bytenr to something completely wrong we
won't be able to fix this if it is the only one who has a ref on the original
disk bytenr.  Our extent records know exactly who is supposed to point at them,
so if we have an extent record that has no backrefs we can go and try to lookup
the backrefs ourselves.  If these backrefs do not point to an extent record that
was actually found then we can be pretty sure this extent record is valid and
the backref is bogus.  Then the verify_backref code can do its thing and reset
the backref to point to the right extent record and we can all carry on.  This
fixes a user reported corruption.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6cbd5a6..f05c73e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -56,6 +56,7 @@ struct extent_backref {
 	unsigned int found_extent_tree:1;
 	unsigned int full_backref:1;
 	unsigned int found_ref:1;
+	unsigned int broken:1;
 };
 
 struct data_backref {
@@ -4092,6 +4093,7 @@ struct extent_entry {
 	u64 bytenr;
 	u64 bytes;
 	int count;
+	int broken;
 	struct list_head list;
 };
 
@@ -4119,6 +4121,13 @@ static struct extent_entry *find_most_right_entry(struct list_head *entries)
 		}
 
 		/*
+		 * If there are as many broken entries as entries then we know
+		 * not to trust this particular entry.
+		 */
+		if (entry->broken == entry->count)
+			continue;
+
+		/*
 		 * If our current entry == best then we can't be sure our best
 		 * is really the best, so we need to keep searching.
 		 */
@@ -4129,7 +4138,7 @@ static struct extent_entry *find_most_right_entry(struct list_head *entries)
 		}
 
 		/* Prev == entry, not good enough, have to keep searching */
-		if (prev->count == entry->count)
+		if (!prev->broken && prev->count == entry->count)
 			continue;
 
 		if (!best)
@@ -4244,7 +4253,9 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	}
 
-	if (dback->disk_bytenr > entry->bytenr) {
+	if (dback->node.broken && dback->disk_bytenr != entry->bytenr) {
+		btrfs_set_file_extent_disk_bytenr(leaf, fi, entry->bytenr);
+	} else if (dback->disk_bytenr > entry->bytenr) {
 		u64 off_diff, offset;
 
 		off_diff = dback->disk_bytenr - entry->bytenr;
@@ -4304,7 +4315,9 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 	struct extent_entry *entry, *best = NULL;
 	LIST_HEAD(entries);
 	int nr_entries = 0;
+	int broken_entries = 0;
 	int ret = 0;
+	short mismatch = 0;
 
 	/*
 	 * Metadata is easy and the backrefs should always agree on bytenr and
@@ -4346,11 +4359,25 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 			list_add_tail(&entry->list, &entries);
 			nr_entries++;
 		}
+
+		/*
+		 * If we only have on entry we may think the entries agree when
+		 * in reality they don't so we have to do some extra checking.
+		 */
+		if (dback->disk_bytenr != rec->start ||
+		    dback->bytes != rec->nr || back->broken)
+			mismatch = 1;
+
+		if (back->broken) {
+			entry->broken++;
+			broken_entries++;
+		}
+
 		entry->count++;
 	}
 
 	/* Yay all the backrefs agree, carry on good sir */
-	if (nr_entries <= 1)
+	if (nr_entries <= 1 && !mismatch)
 		goto out;
 
 	fprintf(stderr, "attempting to repair backref discrepency for bytenr "
@@ -4369,13 +4396,28 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 	 */
 	if (!best) {
 		entry = find_entry(&entries, rec->start, rec->nr);
-		if (!entry) {
+		if (!entry && (!broken_entries || !rec->found_rec)) {
 			fprintf(stderr, "Backrefs don't agree with eachother "
 				"and extent record doesn't agree with anybody,"
 				" so we can't fix bytenr %Lu bytes %Lu\n",
 				rec->start, rec->nr);
 			ret = -EINVAL;
 			goto out;
+		} else if (!entry) {
+			/*
+			 * Ok our backrefs were broken, we'll assume this is the
+			 * correct value and add an entry for this range.
+			 */
+			entry = malloc(sizeof(struct extent_entry));
+			if (!entry) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memset(entry, 0, sizeof(*entry));
+			entry->bytenr = rec->start;
+			entry->bytes = rec->nr;
+			list_add_tail(&entry->list, &entries);
+			nr_entries++;
 		}
 		entry->count++;
 		best = find_most_right_entry(&entries);
@@ -4622,6 +4664,92 @@ out:
 	return ret ? ret : nr_del;
 }
 
+static int find_possible_backrefs(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *info,
+				  struct btrfs_path *path,
+				  struct cache_tree *extent_cache,
+				  struct extent_record *rec)
+{
+	struct btrfs_root *root;
+	struct extent_backref *back;
+	struct data_backref *dback;
+	struct cache_extent *cache;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 bytenr, bytes;
+	int ret;
+
+	list_for_each_entry(back, &rec->backrefs, list) {
+		dback = (struct data_backref *)back;
+
+		/* We found this one, we don't need to do a lookup */
+		if (dback->found_ref)
+			continue;
+		/* Don't care about full backrefs (poor unloved backrefs) */
+		if (back->full_backref)
+			continue;
+		key.objectid = dback->root;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		root = btrfs_read_fs_root(info, &key);
+
+		/* No root, definitely a bad ref, skip */
+		if (IS_ERR(root) && PTR_ERR(root) == -ENOENT)
+			continue;
+		/* Other err, exit */
+		if (IS_ERR(root))
+			return PTR_ERR(root);
+
+		key.objectid = dback->owner;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+		key.offset = dback->offset;
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret) {
+			btrfs_release_path(path);
+			if (ret < 0)
+				return ret;
+			/* Didn't find it, we can carry on */
+			ret = 0;
+			continue;
+		}
+
+		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_file_extent_item);
+		bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], fi);
+		bytes = btrfs_file_extent_disk_num_bytes(path->nodes[0], fi);
+		btrfs_release_path(path);
+		cache = lookup_cache_extent(extent_cache, bytenr, 1);
+		if (cache) {
+			struct extent_record *tmp;
+			tmp = container_of(cache, struct extent_record, cache);
+
+			/*
+			 * If we found an extent record for the bytenr for this
+			 * particular backref then we can't add it to our
+			 * current extent record.  We only want to add backrefs
+			 * that don't have a corresponding extent item in the
+			 * extent tree since they likely belong to this record
+			 * and we need to fix it if it doesn't match bytenrs.
+			 */
+			if  (tmp->found_rec)
+				continue;
+		}
+
+		dback->found_ref += 1;
+		dback->disk_bytenr = bytenr;
+		dback->bytes = bytes;
+
+		/*
+		 * Set this so the verify backref code knows not to trust the
+		 * values in this backref.
+		 */
+		back->broken = 1;
+	}
+
+	return 0;
+}
+
 /*
  * when an incorrect extent item is found, this will delete
  * all of the existing entries for it and recreate them
@@ -4629,6 +4757,7 @@ out:
  */
 static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *info,
+			     struct cache_tree *extent_cache,
 			     struct extent_record *rec)
 {
 	int ret;
@@ -4650,6 +4779,20 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	if (rec->refs != rec->extent_item_refs && !rec->metadata) {
+		/*
+		 * Sometimes the backrefs themselves are so broken they don't
+		 * get attached to any meaningful rec, so first go back and
+		 * check any of our backrefs that we couldn't find and throw
+		 * them into the list if we find the backref so that
+		 * verify_backrefs can figure out what to do.
+		 */
+		ret = find_possible_backrefs(trans, info, path, extent_cache,
+					     rec);
+		if (ret < 0)
+			goto out;
+	}
+
 	/* step one, make sure all of the backrefs agree */
 	ret = verify_backrefs(trans, info, path, rec);
 	if (ret < 0)
@@ -4959,7 +5102,8 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
 			if (!fixed && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info, rec);
+				ret = fixup_extent_refs(trans, root->fs_info,
+							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
 				fixed = 1;
@@ -4973,7 +5117,8 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->nr);
 
 			if (!fixed && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info, rec);
+				ret = fixup_extent_refs(trans, root->fs_info,
+							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
 				fixed = 1;
@@ -4986,7 +5131,8 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 			if (!fixed && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info, rec);
+				ret = fixup_extent_refs(trans, root->fs_info,
+							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
 				fixed = 1;
-- 
1.7.7.6

