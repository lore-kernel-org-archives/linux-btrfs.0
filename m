Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61243 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759087AbbBIUDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:31 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 02/16] btrfs-progs: deal with no extent info
Date: Mon, 9 Feb 2015 15:03:05 -0500
Message-ID: <1423512199-16552-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously we used to just set FULL_BACKREF if we couldn't lookup an extent info
for an extent.  Now we just bail out if we can't lookup the extent info, which
is less than good since fsck is supposed to fix these very problems.  So instead
figure out the flag we are supposed to use and pass that along instead.  This
patch also provides a test image to test this functionality.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c                                       |  43 +++++++++------------
 .../fsck-tests/014-no-extent-info/default_case.img | Bin 0 -> 4096 bytes
 2 files changed, 19 insertions(+), 24 deletions(-)
 create mode 100644 tests/fsck-tests/014-no-extent-info/default_case.img

diff --git a/cmds-check.c b/cmds-check.c
index 73d7866..ca40e35 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5686,6 +5686,7 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 			  struct root_item_record *ri)
 {
 	struct extent_buffer *buf;
+	struct extent_record *rec = NULL;
 	u64 bytenr;
 	u32 size;
 	u64 parent;
@@ -5738,8 +5739,6 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 	}
 	cache = lookup_cache_extent(extent_cache, bytenr, size);
 	if (cache) {
-		struct extent_record *rec;
-
 		rec = container_of(cache, struct extent_record, cache);
 		gen = rec->parent_generation;
 	}
@@ -5758,20 +5757,30 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 	 * FIXME, this only works only if we don't have any full
 	 * backref mode.
 	 */
+	flags = 0;
 	if (!init_extent_tree) {
 		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
 				       btrfs_header_level(buf), 1, NULL,
 				       &flags);
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			ret = calc_extent_flag(root, extent_cache, buf, ri, &flags);
+			if (ret < 0) {
+				fprintf(stderr, "Couldn't calc extent flags\n");
+				flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+			}
+		}
 	} else {
 		flags = 0;
 		ret = calc_extent_flag(root, extent_cache, buf, ri, &flags);
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			fprintf(stderr, "Couldn't calc extent flags\n");
+			flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+		}
 	}
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+		if (rec)
+			rec->flag_block_full_backref = 1;
 		parent = bytenr;
 		owner = 0;
 	} else {
@@ -7030,21 +7039,8 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 	int allocated = 0;
 	u64 flags = 0;
 
-	/*
-	 * remember our flags for recreating the extent.
-	 * FIXME, if we have cleared extent tree, we can not
-	 * lookup extent info in extent tree.
-	 */
-	if (!init_extent_tree) {
-		ret = btrfs_lookup_extent_info(NULL, info->extent_root,
-					rec->start, rec->max_size,
-					rec->metadata, NULL, &flags);
-		if (ret < 0)
-			return ret;
-	} else {
-		if (rec->flag_block_full_backref)
-			flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
-	}
+	if (rec->flag_block_full_backref)
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -7691,8 +7687,6 @@ static int deal_root_from_list(struct list_head *list,
 		 * one by one, otherwise we deal with node firstly which
 		 * can maximize readahead.
 		 */
-		if (!init_extent_tree && !rec->drop_level)
-			goto skip;
 		while (1) {
 			ret = run_next_block(trans, root, bits, bits_nr, &last,
 					     pending, seen, reada,
@@ -7703,10 +7697,11 @@ static int deal_root_from_list(struct list_head *list,
 			if (ret != 0)
 				break;
 		}
-skip:
 		free_extent_buffer(buf);
 		list_del(&rec->list);
 		free(rec);
+		if (ret < 0)
+			break;
 	}
 	while (ret >= 0) {
 		ret = run_next_block(trans, root, bits, bits_nr, &last,
diff --git a/tests/fsck-tests/014-no-extent-info/default_case.img b/tests/fsck-tests/014-no-extent-info/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..1ff27434a59f0b94ce18109690525aadf017b9ad
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

-- 
1.8.3.1

