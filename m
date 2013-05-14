Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41156 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3ENSsd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 14:48:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8A7C89A0402
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:48:32 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Y2xWiyGcfsAEs4jd (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:48:31 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make fsck fix certain file extent inconsistencies
Date: Tue, 14 May 2013 14:48:28 -0400
Message-ID: <1368557308-2967-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree log bug I introduced could create inconsistent file extent entries in
the file system tree and in some worst cases even create multiple extent entries
for the same entry.  To fix this we need to do a few things

1) Keep track of extent items that overlap and then pick the one that covers the
largest area and delete the rest of the items.

2) Keep track of file extent items that land in extent items but don't match
disk_bytenr/disk_num_bytes exactly.  Once we find these we need to figure out
who is the right ref and then fix all of the other refs to agree.

Each of these cases require a complete rescan of all of the extents, so
unfortunately if you hit this particular problem the fsck is going to take quite
a while since it will likely rescan all the trees 2 or 3 times.  With this patch
the broken file system a user sent me is fixed and a broken file system that was
created by my reproducer is also fixed.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c  |  693 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 ctree.h       |    2 +
 disk-io.c     |    3 +
 extent-tree.c |    6 +
 4 files changed, 666 insertions(+), 38 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1e5e005..c5bca84 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -49,6 +49,7 @@ static u64 btree_space_waste = 0;
 static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
 static int found_old_backref = 0;
+static LIST_HEAD(duplicate_extents);
 
 struct extent_backref {
 	struct list_head list;
@@ -66,7 +67,9 @@ struct data_backref {
 	};
 	u64 owner;
 	u64 offset;
+	u64 disk_bytenr;
 	u64 bytes;
+	u64 ram_bytes;
 	u32 num_refs;
 	u32 found_ref;
 };
@@ -81,6 +84,8 @@ struct tree_backref {
 
 struct extent_record {
 	struct list_head backrefs;
+	struct list_head dups;
+	struct list_head list;
 	struct cache_extent cache;
 	struct btrfs_disk_key parent_key;
 	u64 start;
@@ -95,6 +100,8 @@ struct extent_record {
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
 	unsigned int metadata:1;
+	unsigned int found_rec:1;
+	unsigned int has_duplicate:1;
 };
 
 struct inode_backref {
@@ -1923,6 +1930,17 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)dback->offset,
 					dback->found_ref, dback->num_refs, back);
 			}
+			if (dback->disk_bytenr != rec->start) {
+				err = 1;
+				if (!print_errs)
+					goto out;
+				fprintf(stderr, "Backref disk bytenr does not"
+					" match extent record, bytenr=%llu, "
+					"ref bytenr=%llu\n",
+					(unsigned long long)rec->start,
+					(unsigned long long)dback->disk_bytenr);
+			}
+
 			if (dback->bytes != rec->nr) {
 				err = 1;
 				if (!print_errs)
@@ -1969,6 +1987,24 @@ static int free_all_extent_backrefs(struct extent_record *rec)
 	return 0;
 }
 
+static void free_extent_cache(struct btrfs_fs_info *fs_info,
+			      struct cache_tree *extent_cache)
+{
+	struct cache_extent *cache;
+	struct extent_record *rec;
+
+	while (1) {
+		cache = find_first_cache_extent(extent_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct extent_record, cache);
+		btrfs_unpin_extent(fs_info, rec->start, rec->max_size);
+		remove_cache_extent(extent_cache, cache);
+		free_all_extent_backrefs(rec);
+		free(rec);
+	}
+}
+
 static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 				 struct extent_record *rec)
 {
@@ -2180,7 +2216,8 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 static struct data_backref *find_data_backref(struct extent_record *rec,
 						u64 parent, u64 root,
 						u64 owner, u64 offset,
-						int found_ref, u64 bytes)
+						int found_ref,
+						u64 disk_bytenr, u64 bytes)
 {
 	struct list_head *cur = rec->backrefs.next;
 	struct extent_backref *node;
@@ -2203,7 +2240,8 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 			if (back->root == root && back->owner == owner &&
 			    back->offset == offset) {
 				if (found_ref && node->found_ref &&
-				    back->bytes != bytes)
+				    (back->bytes != bytes ||
+				    back->disk_bytenr != disk_bytenr))
 					continue;
 				return back;
 			}
@@ -2250,6 +2288,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	struct extent_record *rec;
 	struct cache_extent *cache;
 	int ret = 0;
+	int dup = 0;
 
 	cache = find_cache_extent(extent_cache, start, nr);
 	if (cache) {
@@ -2264,16 +2303,39 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		 * record says was the real size, this way we can compare it to
 		 * the backrefs.
 		 */
-		if (extent_rec)
-			rec->nr = nr;
+		if (extent_rec) {
+			if (rec->found_rec) {
+				struct extent_record *tmp;
 
-		if (start != rec->start) {
-			fprintf(stderr, "warning, start mismatch %llu %llu\n",
-				(unsigned long long)rec->start,
-				(unsigned long long)start);
-			ret = 1;
+				dup = 1;
+				if (list_empty(&rec->list))
+					list_add_tail(&rec->list,
+						      &duplicate_extents);
+
+				/*
+				 * We have to do this song and dance in case we
+				 * find an extent record that falls inside of
+				 * our current extent record but does not have
+				 * the same objectid.
+				 */
+				tmp = malloc(sizeof(*tmp));
+				if (!tmp)
+					return -ENOMEM;
+				tmp->start = start;
+				tmp->max_size = max_size;
+				tmp->nr = nr;
+				tmp->found_rec = 1;
+				tmp->metadata = metadata;
+				INIT_LIST_HEAD(&tmp->list);
+				list_add_tail(&tmp->list, &rec->dups);
+				rec->has_duplicate = 1;
+			} else {
+				rec->nr = nr;
+			}
+			rec->found_rec = 1;
 		}
-		if (extent_item_refs) {
+
+		if (extent_item_refs && !dup) {
 			if (rec->extent_item_refs) {
 				fprintf(stderr, "block %llu rec "
 					"extent_item_refs %llu, passed %llu\n",
@@ -2304,10 +2366,14 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->start = start;
 	rec->max_size = max_size;
 	rec->nr = max(nr, max_size);
+	rec->found_rec = extent_rec;
 	rec->content_checked = 0;
 	rec->owner_ref_checked = 0;
+	rec->has_duplicate = 0;
 	rec->metadata = metadata;
 	INIT_LIST_HEAD(&rec->backrefs);
+	INIT_LIST_HEAD(&rec->dups);
+	INIT_LIST_HEAD(&rec->list);
 
 	if (is_root)
 		rec->is_root = 1;
@@ -2406,9 +2472,6 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	}
 
 	rec = container_of(cache, struct extent_record, cache);
-	if (rec->start != bytenr) {
-		abort();
-	}
 	if (rec->max_size < max_size)
 		rec->max_size = max_size;
 
@@ -2423,7 +2486,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	 * prealloc extents or point inside of a prealloc extent.
 	 */
 	back = find_data_backref(rec, parent, root, owner, offset, found_ref,
-				 max_size);
+				 bytenr, max_size);
 	if (!back)
 		back = alloc_data_backref(rec, parent, root, owner, offset,
 					  max_size);
@@ -2435,6 +2498,10 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->node.found_ref = 1;
 		back->found_ref += 1;
 		back->bytes = max_size;
+		back->disk_bytenr = bytenr;
+		rec->refs += 1;
+		rec->content_checked = 1;
+		rec->owner_ref_checked = 1;
 	} else {
 		if (back->node.found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
@@ -3240,11 +3307,6 @@ static int run_next_block(struct btrfs_root *root,
 			}
 			data_bytes_referenced +=
 				btrfs_file_extent_num_bytes(buf, fi);
-			ret = add_extent_rec(extent_cache, NULL,
-				   btrfs_file_extent_disk_bytenr(buf, fi),
-				   btrfs_file_extent_disk_num_bytes(buf, fi),
-				   0, 0, 1, 1, 0, 0,
-				   btrfs_file_extent_disk_num_bytes(buf, fi));
 			add_data_backref(extent_cache,
 				btrfs_file_extent_disk_bytenr(buf, fi),
 				parent, owner, key.objectid, key.offset -
@@ -3344,7 +3406,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 	if (is_data) {
 		struct data_backref *back;
 		back = find_data_backref(rec, parent, root_objectid, owner,
-					 offset, 1, num_bytes);
+					 offset, 1, bytenr, num_bytes);
 		if (!back)
 			goto out;
 		if (back->node.found_ref) {
@@ -3607,6 +3669,454 @@ fail:
 	return ret;
 }
 
+struct extent_entry {
+	u64 bytenr;
+	u64 bytes;
+	int count;
+	struct list_head list;
+};
+
+static struct extent_entry *find_entry(struct list_head *entries,
+				       u64 bytenr, u64 bytes)
+{
+	struct extent_entry *entry = NULL;
+
+	list_for_each_entry(entry, entries, list) {
+		if (entry->bytenr == bytenr && entry->bytes == bytes)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static struct extent_entry *find_most_right_entry(struct list_head *entries)
+{
+	struct extent_entry *entry, *best = NULL, *prev = NULL;
+
+	list_for_each_entry(entry, entries, list) {
+		if (!prev) {
+			prev = entry;
+			continue;
+		}
+
+		/*
+		 * If our current entry == best then we can't be sure our best
+		 * is really the best, so we need to keep searching.
+		 */
+		if (best && best->count == entry->count) {
+			prev = entry;
+			best = NULL;
+			continue;
+		}
+
+		/* Prev == entry, not good enough, have to keep searching */
+		if (prev->count == entry->count)
+			continue;
+
+		if (!best)
+			best = (prev->count > entry->count) ? prev : entry;
+		else if (best->count < entry->count)
+			best = entry;
+		prev = entry;
+	}
+
+	return best;
+}
+
+static int repair_ref(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *info, struct btrfs_path *path,
+		      struct data_backref *dback, struct extent_entry *entry)
+{
+	struct btrfs_root *root;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 bytenr, bytes;
+	int ret;
+
+	key.objectid = dback->root;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root(info, &key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Couldn't find root for our ref\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * The backref points to the original offset of the extent if it was
+	 * split, so we need to search down to the offset we have and then walk
+	 * forward until we find the backref we're looking for.
+	 */
+	key.objectid = dback->owner;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = dback->offset;
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error looking up ref %d\n", ret);
+		return ret;
+	}
+
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret) {
+				fprintf(stderr, "Couldn't find our ref, next\n");
+				return -EINVAL;
+			}
+		}
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != dback->owner ||
+		    key.type != BTRFS_EXTENT_DATA_KEY) {
+			fprintf(stderr, "Couldn't find our ref, search\n");
+			return -EINVAL;
+		}
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+
+		if (bytenr == dback->disk_bytenr && bytes == dback->bytes)
+			break;
+		path->slots[0]++;
+	}
+
+	btrfs_release_path(root, path);
+
+	/*
+	 * Have to make sure that this root gets updated when we commit the
+	 * transaction
+	 */
+	root->track_dirty = 1;
+	if (root->last_trans != trans->transid) {
+		root->last_trans = trans->transid;
+		root->commit_root = root->node;
+		extent_buffer_get(root->node);
+	}
+
+	/*
+	 * Ok we have the key of the file extent we want to fix, now we can cow
+	 * down to the thing and fix it.
+	 */
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0) {
+		fprintf(stderr, "Error cowing down to ref [%Lu, %u, %Lu]: %d\n",
+			key.objectid, key.type, key.offset, ret);
+		return ret;
+	}
+	if (ret > 0) {
+		fprintf(stderr, "Well that's odd, we just found this key "
+			"[%Lu, %u, %Lu]\n", key.objectid, key.type,
+			key.offset);
+		return -EINVAL;
+	}
+	leaf = path->nodes[0];
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			    struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_compression(leaf, fi) &&
+	    dback->disk_bytenr != entry->bytenr) {
+		fprintf(stderr, "Ref doesn't match the record start and is "
+			"compressed, please take a btrfs-image of this file "
+			"system and send it to a btrfs developer so they can "
+			"complete this functionality for bytenr %Lu\n",
+			dback->disk_bytenr);
+		return -EINVAL;
+	}
+
+	if (dback->disk_bytenr > entry->bytenr) {
+		u64 off_diff, offset;
+
+		off_diff = dback->disk_bytenr - entry->bytenr;
+		offset = btrfs_file_extent_offset(leaf, fi);
+		if (dback->disk_bytenr + offset +
+		    btrfs_file_extent_num_bytes(leaf, fi) >
+		    entry->bytenr + entry->bytes) {
+			fprintf(stderr, "Ref is past the entry end, please "
+				"take a btrfs-image of this file system and "
+				"send it to a btrfs developer, ref %Lu\n",
+				dback->disk_bytenr);
+			return -EINVAL;
+		}
+		offset += off_diff;
+		btrfs_set_file_extent_disk_bytenr(leaf, fi, entry->bytenr);
+		btrfs_set_file_extent_offset(leaf, fi, offset);
+	} else if (dback->disk_bytenr < entry->bytenr) {
+		u64 offset;
+
+		offset = btrfs_file_extent_offset(leaf, fi);
+		if (dback->disk_bytenr + offset < entry->bytenr) {
+			fprintf(stderr, "Ref is before the entry start, please"
+				" take a btrfs-image of this file system and "
+				"send it to a btrfs developer, ref %Lu\n",
+				dback->disk_bytenr);
+			return -EINVAL;
+		}
+
+		offset += dback->disk_bytenr;
+		offset -= entry->bytenr;
+		btrfs_set_file_extent_disk_bytenr(leaf, fi, entry->bytenr);
+		btrfs_set_file_extent_offset(leaf, fi, offset);
+	}
+
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, entry->bytes);
+
+	/*
+	 * Chances are if disk_num_bytes were wrong then so is ram_bytes, but
+	 * only do this if we aren't using compression, otherwise it's a
+	 * trickier case.
+	 */
+	if (!btrfs_file_extent_compression(leaf, fi))
+		btrfs_set_file_extent_ram_bytes(leaf, fi, entry->bytes);
+	else
+		printf("ram bytes may be wrong?\n");
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+	return 0;
+}
+
+static int verify_backrefs(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *info, struct btrfs_path *path,
+			   struct extent_record *rec)
+{
+	struct extent_backref *back;
+	struct data_backref *dback;
+	struct extent_entry *entry, *best = NULL;
+	LIST_HEAD(entries);
+	int nr_entries = 0;
+	int ret = 0;
+
+	/*
+	 * Metadata is easy and the backrefs should always agree on bytenr and
+	 * size, if not we've got bigger issues.
+	 */
+	if (rec->metadata)
+		return 0;
+
+	list_for_each_entry(back, &rec->backrefs, list) {
+		dback = (struct data_backref *)back;
+		/*
+		 * We only pay attention to backrefs that we found a real
+		 * backref for.
+		 */
+		if (dback->found_ref == 0)
+			continue;
+		if (back->full_backref)
+			continue;
+
+		/*
+		 * For now we only catch when the bytes don't match, not the
+		 * bytenr.  We can easily do this at the same time, but I want
+		 * to have a fs image to test on before we just add repair
+		 * functionality willy-nilly so we know we won't screw up the
+		 * repair.
+		 */
+
+		entry = find_entry(&entries, dback->disk_bytenr,
+				   dback->bytes);
+		if (!entry) {
+			entry = malloc(sizeof(struct extent_entry));
+			if (!entry) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memset(entry, 0, sizeof(*entry));
+			entry->bytenr = dback->disk_bytenr;
+			entry->bytes = dback->bytes;
+			list_add_tail(&entry->list, &entries);
+			nr_entries++;
+		}
+		entry->count++;
+	}
+
+	/* Yay all the backrefs agree, carry on good sir */
+	if (nr_entries <= 1)
+		goto out;
+
+	fprintf(stderr, "attempting to repair backref discrepency for bytenr "
+		"%Lu\n", rec->start);
+
+	/*
+	 * First we want to see if the backrefs can agree amongst themselves who
+	 * is right, so figure out which one of the entries has the highest
+	 * count.
+	 */
+	best = find_most_right_entry(&entries);
+
+	/*
+	 * Ok so we may have an even split between what the backrefs think, so
+	 * this is where we use the extent ref to see what it thinks.
+	 */
+	if (!best) {
+		entry = find_entry(&entries, rec->start, rec->nr);
+		if (!entry) {
+			fprintf(stderr, "Backrefs don't agree with eachother "
+				"and extent record doesn't agree with anybody,"
+				" so we can't fix bytenr %Lu bytes %Lu\n",
+				rec->start, rec->nr);
+			ret = -EINVAL;
+			goto out;
+		}
+		entry->count++;
+		best = find_most_right_entry(&entries);
+		if (!best) {
+			fprintf(stderr, "Backrefs and extent record evenly "
+				"split on who is right, this is going to "
+				"require user input to fix bytenr %Lu bytes "
+				"%Lu\n", rec->start, rec->nr);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/*
+	 * I don't think this can happen currently as we'll abort() if we catch
+	 * this case higher up, but in case somebody removes that we still can't
+	 * deal with it properly here yet, so just bail out of that's the case.
+	 */
+	if (best->bytenr != rec->start) {
+		fprintf(stderr, "Extent start and backref starts don't match, "
+			"please use btrfs-image on this file system and send "
+			"it to a btrfs developer so they can make fsck fix "
+			"this particular case.  bytenr is %Lu, bytes is %Lu\n",
+			rec->start, rec->nr);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Ok great we all agreed on an extent record, let's go find the real
+	 * references and fix up the ones that don't match.
+	 */
+	list_for_each_entry(back, &rec->backrefs, list) {
+		dback = (struct data_backref *)back;
+
+		/*
+		 * Still ignoring backrefs that don't have a real ref attached
+		 * to them.
+		 */
+		if (dback->found_ref == 0)
+			continue;
+		if (back->full_backref)
+			continue;
+
+		if (dback->bytes == best->bytes &&
+		    dback->disk_bytenr == best->bytenr)
+			continue;
+
+		ret = repair_ref(trans, info, path, dback, best);
+		if (ret)
+			goto out;
+	}
+
+	/*
+	 * Ok we messed with the actual refs, which means we need to drop our
+	 * entire cache and go back and rescan.  I know this is a huge pain and
+	 * adds a lot of extra work, but it's the only way to be safe.  Once all
+	 * the backrefs agree we may not need to do anything to the extent
+	 * record itself.
+	 */
+	ret = -EAGAIN;
+out:
+	while (!list_empty(&entries)) {
+		entry = list_entry(entries.next, struct extent_entry, list);
+		list_del_init(&entry->list);
+		free(entry);
+	}
+	return ret;
+}
+
+static int delete_duplicate_records(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct extent_record *rec)
+{
+	LIST_HEAD(delete_list);
+	struct btrfs_path *path;
+	struct extent_record *tmp, *good, *n;
+	int ret = 0;
+	struct btrfs_key key;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	good = rec;
+	/* Find the record that covers all of the duplicates. */
+	list_for_each_entry(tmp, &rec->dups, list) {
+		if (good->start < tmp->start)
+			continue;
+		if (good->nr > tmp->nr)
+			continue;
+
+		if (tmp->start + tmp->nr < good->start + good->nr) {
+			fprintf(stderr, "Ok we have overlapping extents that "
+				"aren't completely covered by eachother, this "
+				"is going to require more careful thought.  "
+				"The extents are [%Lu-%Lu] and [%Lu-%Lu]\n",
+				tmp->start, tmp->nr, good->start, good->nr);
+			abort();
+		}
+		good = tmp;
+	}
+
+	if (good != rec)
+		list_add_tail(&rec->list, &delete_list);
+
+	list_for_each_entry_safe(tmp, n, &rec->dups, list) {
+		if (tmp == good)
+			continue;
+		list_move_tail(&tmp->list, &delete_list);
+	}
+
+	root = root->fs_info->extent_root;
+	list_for_each_entry(tmp, &delete_list, list) {
+		key.objectid = tmp->start;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = tmp->nr;
+
+		/* Shouldn't happen but just in case */
+		if (tmp->metadata) {
+			fprintf(stderr, "Well this shouldn't happen, extent "
+				"record overlaps but is metadata? "
+				"[%Lu, %Lu]\n", tmp->start, tmp->nr);
+			abort();
+		}
+
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret) {
+			if (ret > 0)
+				ret = -EINVAL;
+			goto out;
+		}
+		ret = btrfs_del_item(trans, root, path);
+		if (ret)
+			goto out;
+		btrfs_release_path(root, path);
+	}
+
+out:
+	while (!list_empty(&delete_list)) {
+		tmp = list_entry(delete_list.next, struct extent_record, list);
+		list_del_init(&tmp->list);
+		if (tmp == rec)
+			continue;
+		free(tmp);
+	}
+
+	while (!list_empty(&rec->dups)) {
+		tmp = list_entry(rec->dups.next, struct extent_record, list);
+		list_del_init(&tmp->list);
+		free(tmp);
+	}
+
+	btrfs_free_path(path);
+
+	return ret;
+}
+
 /*
  * when an incorrect extent item is found, this will delete
  * all of the existing entries for it and recreate them
@@ -3633,7 +4143,12 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 
 	path = btrfs_alloc_path();
 
-	/* step one, delete all the existing records */
+	/* step one, make sure all of the backrefs agree */
+	ret = verify_backrefs(trans, info, path, rec);
+	if (ret < 0)
+		goto out;
+
+	/* step two, delete all the existing records */
 	ret = delete_extent_records(trans, info->extent_root, path,
 				    rec->start, rec->max_size);
 
@@ -3647,7 +4162,7 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	/* step two, recreate all the refs we did find */
+	/* step three, recreate all the refs we did find */
 	while(cur != &rec->backrefs) {
 		back = list_entry(cur, struct extent_backref, list);
 		cur = cur->next;
@@ -3820,16 +4335,43 @@ static int check_block_groups(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 start, end;
+	int ret;
+
+	while (1) {
+		ret = find_first_extent_bit(&fs_info->free_space_cache, 0,
+					    &start, &end, EXTENT_DIRTY);
+		if (ret)
+			break;
+		clear_extent_dirty(&fs_info->free_space_cache, start, end,
+				   GFP_NOFS);
+	}
+
+	start = 0;
+	while (1) {
+		cache = btrfs_lookup_first_block_group(fs_info, start);
+		if (!cache)
+			break;
+		if (cache->cached)
+			cache->cached = 0;
+		start = cache->key.objectid + cache->key.offset;
+	}
+}
+
 static int check_extent_refs(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct cache_tree *extent_cache, int repair)
 {
-	struct extent_record *rec;
+	struct extent_record *rec, *n;
 	struct cache_extent *cache;
 	int err = 0;
 	int ret = 0;
 	int fixed = 0;
 	int reinit = 0;
+	int had_dups = 0;
 
 	if (repair) {
 		/*
@@ -3858,13 +4400,39 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		check_block_groups(trans, root->fs_info, &reinit);
 		if (reinit)
 			btrfs_read_block_groups(root->fs_info->extent_root);
+		reset_cached_block_groups(root->fs_info);
 	}
+
+	/*
+	 * We need to delete any duplicate entries we find first otherwise we
+	 * could mess up the extent tree when we have backrefs that actually
+	 * belong to a different extent item and not the weird duplicate one.
+	 */
+	list_for_each_entry_safe(rec, n, &duplicate_extents, list) {
+		if (!repair)
+			break;
+		list_del_init(&rec->list);
+		had_dups = 1;
+		ret = delete_duplicate_records(trans, root, rec);
+		if (ret)
+			return ret;
+	}
+
+	if (had_dups)
+		return -EAGAIN;
+
 	while(1) {
 		fixed = 0;
 		cache = find_first_cache_extent(extent_cache, 0);
 		if (!cache)
 			break;
 		rec = container_of(cache, struct extent_record, cache);
+		if (rec->has_duplicate) {
+			fprintf(stderr, "extent item %llu has multiple extent "
+				"items\n", (unsigned long long)rec->start);
+			err = 1;
+		}
+
 		if (rec->refs != rec->extent_item_refs) {
 			fprintf(stderr, "ref mismatch on [%llu %llu] ",
 				(unsigned long long)rec->start,
@@ -3914,10 +4482,10 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	}
 repair_abort:
 	if (repair) {
-		if (ret) {
+		if (ret && ret != -EAGAIN) {
 			fprintf(stderr, "failed to repair damaged filesystem, aborting\n");
 			exit(1);
-		} else {
+		} else if (!ret) {
 			btrfs_fix_block_accounting(trans, root);
 		}
 		if (err)
@@ -3927,8 +4495,20 @@ repair_abort:
 	return err;
 }
 
-static int check_extents(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, int repair)
+static void free_cache_tree(struct cache_tree *tree)
+{
+	struct cache_extent *cache;
+
+	while (1) {
+		cache = find_first_cache_extent(tree, 0);
+		if (!cache)
+			break;
+		remove_cache_extent(tree, cache);
+		free(cache);
+	}
+}
+
+static int check_extents(struct btrfs_root *root, int repair)
 {
 	struct cache_tree extent_cache;
 	struct cache_tree seen;
@@ -3944,6 +4524,7 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	struct block_info *bits;
 	int bits_nr;
 	struct extent_buffer *leaf;
+	struct btrfs_trans_handle *trans = NULL;
 	int slot;
 	struct btrfs_root_item ri;
 
@@ -3955,6 +4536,11 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	cache_tree_init(&corrupt_blocks);
 
 	if (repair) {
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			fprintf(stderr, "Error starting transaction\n");
+			return PTR_ERR(trans);
+		}
 		root->fs_info->fsck_extent_cache = &extent_cache;
 		root->fs_info->free_extent_hook = free_extent_hook;
 		root->fs_info->corrupt_blocks = &corrupt_blocks;
@@ -3967,6 +4553,7 @@ static int check_extents(struct btrfs_trans_handle *trans,
 		exit(1);
 	}
 
+again:
 	add_root_to_pending(root->fs_info->tree_root->node,
 			    &extent_cache, &pending, &seen, &nodes,
 			    &root->fs_info->tree_root->root_key);
@@ -4018,13 +4605,40 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	}
 	ret = check_extent_refs(trans, root, &extent_cache, repair);
 
+	if (ret == -EAGAIN) {
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret)
+			goto out;
+
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+
+		free_corrupt_blocks(root->fs_info);
+		free_cache_tree(&seen);
+		free_cache_tree(&pending);
+		free_cache_tree(&reada);
+		free_cache_tree(&nodes);
+		free_extent_cache(root->fs_info, &extent_cache);
+		goto again;
+	}
+
+	if (trans) {
+		int err;
+
+		err = btrfs_commit_transaction(trans, root);
+		if (!ret)
+			ret = err;
+	}
+out:
 	if (repair) {
 		free_corrupt_blocks(root->fs_info);
 		root->fs_info->fsck_extent_cache = NULL;
 		root->fs_info->free_extent_hook = NULL;
 		root->fs_info->corrupt_blocks = NULL;
 	}
-
 	free(bits);
 	return ret;
 }
@@ -4053,7 +4667,6 @@ int cmd_check(int argc, char **argv)
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
-	struct btrfs_trans_handle *trans = NULL;
 	u64 bytenr = 0;
 	char uuidbuf[37];
 	int ret;
@@ -4128,19 +4741,28 @@ int cmd_check(int argc, char **argv)
 	root = info->fs_root;
 
 	fprintf(stderr, "checking extents\n");
-	if (rw)
-		trans = btrfs_start_transaction(root, 1);
-
 	if (init_csum_tree) {
+		struct btrfs_trans_handle *trans;
+
 		fprintf(stderr, "Reinit crc root\n");
+		trans = btrfs_start_transaction(info->csum_root, 1);
+		if (IS_ERR(trans)) {
+			fprintf(stderr, "Error starting transaction\n");
+			return PTR_ERR(trans);
+		}
+
 		ret = btrfs_fsck_reinit_root(trans, info->csum_root);
 		if (ret) {
 			fprintf(stderr, "crc root initialization failed\n");
 			return -EIO;
 		}
+
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret)
+			exit(1);
 		goto out;
 	}
-	ret = check_extents(trans, root, repair);
+	ret = check_extents(root, repair);
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree\n");
 
@@ -4163,11 +4785,6 @@ int cmd_check(int argc, char **argv)
 	ret = check_root_refs(root, &root_cache);
 out:
 	free_root_recs(&root_cache);
-	if (rw) {
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret)
-			exit(1);
-	}
 	close_ctree(root);
 
 	if (found_old_backref) { /*
diff --git a/ctree.h b/ctree.h
index 5563af3..615bce4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2075,6 +2075,8 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 int btrfs_check_block_accounting(struct btrfs_root *root);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
+void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
+			u64 bytenr, u64 num_bytes);
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root);
 int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
diff --git a/disk-io.c b/disk-io.c
index b001e35..d71eee4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -538,7 +538,10 @@ static int commit_tree_roots(struct btrfs_trans_handle *trans,
 		list_del_init(next);
 		root = list_entry(next, struct btrfs_root, dirty_list);
 		update_cowonly_root(trans, root);
+		free_extent_buffer(root->commit_root);
+		root->commit_root = NULL;
 	}
+
 	return 0;
 }
 
diff --git a/extent-tree.c b/extent-tree.c
index 4ddf48c..7906664 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2185,6 +2185,12 @@ void btrfs_pin_extent(struct btrfs_fs_info *fs_info,
 	update_pinned_extents(fs_info->extent_root, bytenr, num_bytes, 1);
 }
 
+void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
+			u64 bytenr, u64 num_bytes)
+{
+	update_pinned_extents(fs_info->extent_root, bytenr, num_bytes, 0);
+}
+
 /*
  * remove an extent from the root, returns 0 on success
  */
-- 
1.7.7.6

