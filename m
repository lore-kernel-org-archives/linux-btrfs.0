Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15899 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbbAMCE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 21:04:56 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D24GS7025912
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:04:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: Continue repair even some extent reference can't be repaired and report result to user.
Date: Tue, 13 Jan 2015 10:04:45 +0800
Message-ID: <1421114687-6084-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfsck will exit repairing if some extent reference
can't be repaired.
This is somewhat overkilled.

This patch will report number of all errors and fixed/recorded one, and
continue in repair mode.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 500207e..b275b39 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7279,6 +7279,9 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	int fixed = 0;
 	int had_dups = 0;
 	int recorded = 0;
+	u64 nr_fixed = 0;
+	u64 nr_recorded = 0;
+	u64 nr_err = 0;
 
 	if (repair) {
 		/*
@@ -7340,12 +7343,12 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	if (had_dups)
 		return -EAGAIN;
 
-	while(1) {
+	cache = first_cache_extent(extent_cache);
+	while(cache) {
+		err = 0;
 		fixed = 0;
 		recorded = 0;
-		cache = search_cache_extent(extent_cache, 0);
-		if (!cache)
-			break;
+
 		rec = container_of(cache, struct extent_record, cache);
 		if (rec->num_duplicates) {
 			fprintf(stderr, "extent item %llu has multiple extent "
@@ -7360,9 +7363,10 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			fprintf(stderr, "extent item %llu, found %llu\n",
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
+			err = 1;
 			ret = record_orphan_data_extents(root->fs_info, rec);
 			if (ret < 0)
-				goto repair_abort;
+				goto next;
 			if (ret == 0) {
 				recorded = 1;
 			} else {
@@ -7375,11 +7379,10 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 							root->fs_info,
 							extent_cache, rec);
 					if (ret)
-						goto repair_abort;
+						goto next;
 					fixed = 1;
 				}
 			}
-			err = 1;
 
 		}
 		if (all_backpointers_checked(rec, 1)) {
@@ -7387,48 +7390,55 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 
+			err = 1;
 			if (!fixed && !recorded && repair) {
 				ret = fixup_extent_refs(trans, root->fs_info,
 							extent_cache, rec);
 				if (ret)
-					goto repair_abort;
+					goto next;
 				fixed = 1;
 			}
-			err = 1;
 		}
 		if (!rec->owner_ref_checked) {
 			fprintf(stderr, "owner ref check failed [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
+			err = 1;
 			if (!fixed && !recorded && repair) {
 				ret = fixup_extent_refs(trans, root->fs_info,
 							extent_cache, rec);
 				if (ret)
-					goto repair_abort;
+					goto next;
 				fixed = 1;
 			}
-			err = 1;
 		}
-		if (err && !fixed)
-			mark_root_corrupted(root->fs_info, rec);
-
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
 		free(rec);
+next:
+		if (err && !fixed)
+			mark_root_corrupted(root->fs_info, rec);
+
+		nr_err += err;
+		nr_fixed += fixed;
+		nr_recorded += recorded;
+		cache = next_cache_extent(cache);
 	}
-repair_abort:
+
 	if (repair) {
-		if (ret && ret != -EAGAIN) {
-			fprintf(stderr, "failed to repair damaged filesystem, aborting\n");
-			exit(1);
-		} else if (!ret) {
+		if (!ret)
 			btrfs_fix_block_accounting(trans, root);
-		}
-		if (err)
-			fprintf(stderr, "repaired damaged extent references\n");
+		printf("Found %llu errors, fixed %llu, recorded %llu\n",
+		       nr_err, nr_fixed, nr_recorded);
+		if (nr_fixed == nr_err)
+			printf("repaired all damaged extent references\n");
+		else if (nr_fixed + nr_recorded == nr_err)
+			printf("all damaged extent references repaired or recorded for later repair\n");
+		else
+			printf("some extent referenced can't be repaired\n");
 		return ret;
 	}
-	return err;
+	return nr_err;
 }
 
 u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
-- 
2.2.1

