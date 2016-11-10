Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933808AbcKJPCE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 10:02:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D4E6BAC83
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Nov 2016 15:02:02 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: Fix extents after finding all errors
Date: Thu, 10 Nov 2016 09:01:47 -0600
Message-Id: <20161110150147.19766-2-rgoldwyn@suse.de>
In-Reply-To: <20161110150147.19766-1-rgoldwyn@suse.de>
References: <20161110150147.19766-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplifying the logic of fixing.

Calling fixup_extent_ref() after encountering every error causes
more error messages after the extent is fixed. In case of multiple errors,
this is confusing because the error message is displayed after the fix
message and it works on stale data. It is best to show all errors and
then fix the extents.

Set a variable and call fixup_extent_ref() if it is set. err is not used,
so cleared it.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 cmds-check.c | 75 +++++++++++++++++++-----------------------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 779870a..8fa0b38 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8994,6 +8994,9 @@ out:
 			ret = err;
 	}
 
+	if (!ret)
+		fprintf(stderr, "Repaired extent references for %llu\n", (unsigned long long)rec->start);
+
 	btrfs_release_path(&path);
 	return ret;
 }
@@ -9051,7 +9054,11 @@ static int fixup_extent_flags(struct btrfs_fs_info *fs_info,
 	btrfs_set_extent_flags(path.nodes[0], ei, flags);
 	btrfs_mark_buffer_dirty(path.nodes[0]);
 	btrfs_release_path(&path);
-	return btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	if (!ret)
+		fprintf(stderr, "Repaired extent flags for %llu\n", (unsigned long long)rec->start);
+
+	return ret;
 }
 
 /* right now we only prune from the extent allocation tree */
@@ -9178,11 +9185,8 @@ static int check_extent_refs(struct btrfs_root *root,
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
-	int err = 0;
 	int ret = 0;
-	int fixed = 0;
 	int had_dups = 0;
-	int recorded = 0;
 
 	if (repair) {
 		/*
@@ -9251,9 +9255,8 @@ static int check_extent_refs(struct btrfs_root *root,
 
 	while(1) {
 		int cur_err = 0;
+		int fix = 0;
 
-		fixed = 0;
-		recorded = 0;
 		cache = search_cache_extent(extent_cache, 0);
 		if (!cache)
 			break;
@@ -9261,7 +9264,6 @@ static int check_extent_refs(struct btrfs_root *root,
 		if (rec->num_duplicates) {
 			fprintf(stderr, "extent item %llu has multiple extent "
 				"items\n", (unsigned long long)rec->start);
-			err = 1;
 			cur_err = 1;
 		}
 
@@ -9272,57 +9274,33 @@ static int check_extent_refs(struct btrfs_root *root,
 			fprintf(stderr, "extent item %llu, found %llu\n",
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
-			ret = record_orphan_data_extents(root->fs_info, rec);
-			if (ret < 0)
+			fix = record_orphan_data_extents(root->fs_info, rec);
+			if (fix < 0)
 				goto repair_abort;
-			if (ret == 0) {
-				recorded = 1;
-			} else {
-				/*
-				 * we can't use the extent to repair file
-				 * extent, let the fallback method handle it.
-				 */
-				if (!fixed && repair) {
-					ret = fixup_extent_refs(
-							root->fs_info,
-							extent_cache, rec);
-					if (ret)
-						goto repair_abort;
-					fixed = 1;
-				}
-			}
-			err = 1;
 			cur_err = 1;
 		}
 		if (all_backpointers_checked(rec, 1)) {
 			fprintf(stderr, "backpointer mismatch on [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
-
-			if (!fixed && !recorded && repair) {
-				ret = fixup_extent_refs(root->fs_info,
-							extent_cache, rec);
-				if (ret)
-					goto repair_abort;
-				fixed = 1;
-			}
+			fix = 1;
 			cur_err = 1;
-			err = 1;
 		}
 		if (!rec->owner_ref_checked) {
 			fprintf(stderr, "owner ref check failed [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
-			if (!fixed && !recorded && repair) {
-				ret = fixup_extent_refs(root->fs_info,
-							extent_cache, rec);
-				if (ret)
-					goto repair_abort;
-				fixed = 1;
-			}
-			err = 1;
+			fix = 1;
 			cur_err = 1;
 		}
+
+		if (repair && fix) {
+			ret = fixup_extent_refs(root->fs_info, extent_cache, rec);
+			if (ret)
+				goto repair_abort;
+		}
+
+
 		if (rec->bad_full_backref) {
 			fprintf(stderr, "bad full backref, on [%llu]\n",
 				(unsigned long long)rec->start);
@@ -9330,9 +9308,8 @@ static int check_extent_refs(struct btrfs_root *root,
 				ret = fixup_extent_flags(root->fs_info, rec);
 				if (ret)
 					goto repair_abort;
-				fixed = 1;
+				fix = 1;
 			}
-			err = 1;
 			cur_err = 1;
 		}
 		/*
@@ -9344,7 +9321,6 @@ static int check_extent_refs(struct btrfs_root *root,
 			fprintf(stderr,
 				"bad metadata [%llu, %llu) crossing stripe boundary\n",
 				rec->start, rec->start + rec->max_size);
-			err = 1;
 			cur_err = 1;
 		}
 
@@ -9352,13 +9328,12 @@ static int check_extent_refs(struct btrfs_root *root,
 			fprintf(stderr,
 				"bad extent [%llu, %llu), type mismatch with chunk\n",
 				rec->start, rec->start + rec->max_size);
-			err = 1;
 			cur_err = 1;
 		}
 
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
-		if (!init_extent_tree && repair && (!cur_err || fixed))
+		if (!init_extent_tree && repair && (!cur_err || fix))
 			clear_extent_dirty(root->fs_info->excluded_extents,
 					   rec->start,
 					   rec->start + rec->max_size - 1,
@@ -9385,11 +9360,9 @@ repair_abort:
 			if (ret)
 				goto repair_abort;
 		}
-		if (err)
-			fprintf(stderr, "repaired damaged extent references\n");
 		return ret;
 	}
-	return err;
+	return 0;
 }
 
 u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
-- 
2.10.0

