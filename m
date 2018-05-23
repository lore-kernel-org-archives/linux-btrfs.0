Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38092 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753723AbeEWP6k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:58:40 -0400
Received: by mail-qt0-f193.google.com with SMTP id m9-v6so28731717qtb.5
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:58:40 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 2/4] btrfs: remove the wait ordered logic in the log_one_extent path
Date: Wed, 23 May 2018 11:58:34 -0400
Message-Id: <20180523155836.4622-2-josef@toxicpanda.com>
In-Reply-To: <20180523155836.4622-1-josef@toxicpanda.com>
References: <20180523155836.4622-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Since we are waiting on all ordered extents at the start of the fsync()
path we don't need to wait on any logged ordered extents, and we don't
need to look up the checksums on the ordered extents as they will
already be on disk prior to getting here.  Rework this so we're only
looking up and copying the on-disk checksums for the extent range we
care about.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/tree-log.c | 118 +++++-----------------------------------------------
 1 file changed, 10 insertions(+), 108 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 43758e30aa7a..791b5a731456 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4082,127 +4082,30 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return 0;
 }
 
-static int wait_ordered_extents(struct btrfs_trans_handle *trans,
-				struct inode *inode,
-				struct btrfs_root *root,
-				const struct extent_map *em,
-				const struct list_head *logged_list,
-				bool *ordered_io_error)
+static int log_extent_csums(struct btrfs_trans_handle *trans,
+			    struct btrfs_inode *inode,
+			    struct btrfs_root *root,
+			    const struct extent_map *em)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_ordered_extent *ordered;
 	struct btrfs_root *log = root->log_root;
-	u64 mod_start = em->mod_start;
-	u64 mod_len = em->mod_len;
-	const bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 	u64 csum_offset;
 	u64 csum_len;
 	LIST_HEAD(ordered_sums);
 	int ret = 0;
 
-	*ordered_io_error = false;
-
-	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
+	if (inode->flags & BTRFS_INODE_NODATASUM ||
+	    test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
 	    em->block_start == EXTENT_MAP_HOLE)
 		return 0;
 
-	/*
-	 * Wait far any ordered extent that covers our extent map. If it
-	 * finishes without an error, first check and see if our csums are on
-	 * our outstanding ordered extents.
-	 */
-	list_for_each_entry(ordered, logged_list, log_list) {
-		struct btrfs_ordered_sum *sum;
-
-		if (!mod_len)
-			break;
-
-		if (ordered->file_offset + ordered->len <= mod_start ||
-		    mod_start + mod_len <= ordered->file_offset)
-			continue;
-
-		if (!test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) &&
-		    !test_bit(BTRFS_ORDERED_IOERR, &ordered->flags) &&
-		    !test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
-			const u64 start = ordered->file_offset;
-			const u64 end = ordered->file_offset + ordered->len - 1;
-
-			WARN_ON(ordered->inode != inode);
-			filemap_fdatawrite_range(inode->i_mapping, start, end);
-		}
-
-		wait_event(ordered->wait,
-			   (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) ||
-			    test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)));
-
-		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)) {
-			/*
-			 * Clear the AS_EIO/AS_ENOSPC flags from the inode's
-			 * i_mapping flags, so that the next fsync won't get
-			 * an outdated io error too.
-			 */
-			filemap_check_errors(inode->i_mapping);
-			*ordered_io_error = true;
-			break;
-		}
-		/*
-		 * We are going to copy all the csums on this ordered extent, so
-		 * go ahead and adjust mod_start and mod_len in case this
-		 * ordered extent has already been logged.
-		 */
-		if (ordered->file_offset > mod_start) {
-			if (ordered->file_offset + ordered->len >=
-			    mod_start + mod_len)
-				mod_len = ordered->file_offset - mod_start;
-			/*
-			 * If we have this case
-			 *
-			 * |--------- logged extent ---------|
-			 *       |----- ordered extent ----|
-			 *
-			 * Just don't mess with mod_start and mod_len, we'll
-			 * just end up logging more csums than we need and it
-			 * will be ok.
-			 */
-		} else {
-			if (ordered->file_offset + ordered->len <
-			    mod_start + mod_len) {
-				mod_len = (mod_start + mod_len) -
-					(ordered->file_offset + ordered->len);
-				mod_start = ordered->file_offset +
-					ordered->len;
-			} else {
-				mod_len = 0;
-			}
-		}
-
-		if (skip_csum)
-			continue;
-
-		/*
-		 * To keep us from looping for the above case of an ordered
-		 * extent that falls inside of the logged extent.
-		 */
-		if (test_and_set_bit(BTRFS_ORDERED_LOGGED_CSUM,
-				     &ordered->flags))
-			continue;
-
-		list_for_each_entry(sum, &ordered->list, list) {
-			ret = btrfs_csum_file_blocks(trans, log, sum);
-			if (ret)
-				break;
-		}
-	}
-
-	if (*ordered_io_error || !mod_len || ret || skip_csum)
-		return ret;
-
+	/* If we're compressed we have to save the entire range of csums. */
 	if (em->compress_type) {
 		csum_offset = 0;
 		csum_len = max(em->block_len, em->orig_block_len);
 	} else {
-		csum_offset = mod_start - em->start;
-		csum_len = mod_len;
+		csum_offset = em->mod_start - em->start;
+		csum_len = em->mod_len;
 	}
 
 	/* block start is already adjusted for the file extent offset. */
@@ -4244,8 +4147,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int extent_inserted = 0;
 	bool ordered_io_err = false;
 
-	ret = wait_ordered_extents(trans, &inode->vfs_inode, root, em,
-			logged_list, &ordered_io_err);
+	ret = log_extent_csums(trans, inode, root, em);
 	if (ret)
 		return ret;
 
-- 
2.14.3

