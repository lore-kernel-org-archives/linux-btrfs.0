Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27178 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaD2FIi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 01:08:38 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s3T58aER028837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:37 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3T58alG003625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:36 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3T58aYt024856
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:36 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make log message easier to grep for
Date: Tue, 29 Apr 2014 13:08:26 +0800
Message-Id: <1398748106-5916-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While greping for "you don't have the default diritem, this isn't going to work",
I found it's just hard since we use

printk("...default dir"
	"item ...");

To make developer's life easier, I checked all the similar code and made it
easier to grep for.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-inode.c    | 8 ++------
 fs/btrfs/extent-tree.c      | 4 ++--
 fs/btrfs/extent_io.c        | 6 ++----
 fs/btrfs/free-space-cache.c | 3 +--
 fs/btrfs/ioctl.c            | 7 +++----
 fs/btrfs/qgroup.c           | 6 ++----
 fs/btrfs/scrub.c            | 9 +++------
 fs/btrfs/send.c             | 4 +---
 fs/btrfs/volumes.c          | 9 +++------
 9 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 33e561a..4160778 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1492,9 +1492,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		btrfs_err(root->fs_info, "err add delayed dir index item(name: %.*s) "
-				"into the insertion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)",
+		btrfs_err(root->fs_info, "err add delayed dir index item(name: %.*s) into the insertion tree of the delayed node (root id: %llu, inode id: %llu, errno: %d)",
 				name_len, name, delayed_node->root->objectid,
 				delayed_node->inode_id, ret);
 		BUG();
@@ -1564,9 +1562,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
 	if (unlikely(ret)) {
-		btrfs_err(root->fs_info, "err add delayed dir index item(index: %llu) "
-				"into the deletion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)",
+		btrfs_err(root->fs_info, "err add delayed dir index item(index: %llu) into the deletion tree of the delayed node (root id: %llu, inode id: %llu, errno: %d)",
 				index, node->root->objectid, node->inode_id,
 				ret);
 		BUG();
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5590af9..911abf4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5805,8 +5805,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	refs = btrfs_extent_refs(leaf, ei);
 	if (refs < refs_to_drop) {
-		btrfs_err(info, "trying to drop %d refs but we only have %Lu "
-			  "for bytenr %Lu\n", refs_to_drop, refs, bytenr);
+		btrfs_err(info, "trying to drop %d refs but we only have %llu for bytenr %llu\n",
+			  refs_to_drop, refs, bytenr);
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c43896..80be17c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2401,8 +2401,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 					bvec->bv_offset, bvec->bv_len);
 			else
 				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page write in btrfs with offset %u and "
-				   "length %u",
+				   "incomplete page write in btrfs with offset %u and length %u",
 					bvec->bv_offset, bvec->bv_len);
 		}
 
@@ -2484,8 +2483,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					bvec->bv_offset, bvec->bv_len);
 			else
 				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page read in btrfs with offset %u and "
-				   "length %u",
+				   "incomplete page read in btrfs with offset %u and length %u",
 					bvec->bv_offset, bvec->bv_len);
 		}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 73f3de7..904959e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -668,8 +668,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 
 	if (BTRFS_I(inode)->generation != generation) {
 		btrfs_err(root->fs_info,
-			"free space inode generation (%llu) "
-			"did not match free space cache generation (%llu)",
+			"free space inode generation (%llu) did not match free space cache generation (%llu)",
 			BTRFS_I(inode)->generation, generation);
 		return 0;
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7b001ab..3e90f94 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1868,8 +1868,8 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
 		if (key.objectid == root->root_key.objectid) {
 			ret = -EPERM;
-			btrfs_err(root->fs_info, "deleting default subvolume "
-				  "%llu is not allowed", key.objectid);
+			btrfs_err(root->fs_info, "deleting default subvolume %llu is not allowed",
+				  key.objectid);
 			goto out;
 		}
 		btrfs_release_path(path);
@@ -3480,8 +3480,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		btrfs_end_transaction(trans, root);
-		btrfs_err(new_root->fs_info, "Umm, you don't have the default dir"
-			   "item, this isn't going to work");
+		btrfs_err(new_root->fs_info, "Umm, you don't have the default dir item, this isn't going to work");
 		ret = -ENOENT;
 		goto out;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2cf9058..ab5693e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -309,8 +309,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			    fs_info->generation) {
 				flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 				btrfs_err(fs_info,
-					"qgroup generation mismatch, "
-					"marked as inconsistent");
+					"qgroup generation mismatch, marked as inconsistent");
 			}
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
@@ -1834,8 +1833,7 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
 		return;
 	btrfs_err(trans->root->fs_info,
-		"qgroups not uptodate in trans handle %p:  list is%s empty, "
-		"seq is %#x.%x",
+		"qgroups not uptodate in trans handle %p:  list is%s empty, seq is %#x.%x",
 		trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
 		(u32)(trans->delayed_ref_elem.seq >> 32),
 		(u32)trans->delayed_ref_elem.seq);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 68a5a26..8617504 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2511,8 +2511,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			if (key.objectid < logical &&
 			    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
 				btrfs_err(fs_info,
-					   "scrub: tree block %llu spanning "
-					   "stripes, ignored. logical=%llu",
+					   "scrub: tree block %llu spanning stripes, ignored. logical=%llu",
 				       key.objectid, logical);
 				goto next;
 			}
@@ -2934,8 +2933,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
 		btrfs_err(fs_info,
-			   "scrub: size assumption sectorsize != PAGE_SIZE "
-			   "(%d != %lu) fails",
+			   "scrub: size assumption sectorsize != PAGE_SIZE (%d != %lu) fails",
 		       fs_info->chunk_root->sectorsize, PAGE_SIZE);
 		return -EINVAL;
 	}
@@ -2948,8 +2946,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * would exhaust the array bounds of pagev member in
 		 * struct scrub_block
 		 */
-		btrfs_err(fs_info, "scrub: size assumption nodesize and sectorsize "
-			   "<= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails",
+		btrfs_err(fs_info, "scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails",
 		       fs_info->chunk_root->nodesize,
 		       SCRUB_MAX_PAGES_PER_BLOCK,
 		       fs_info->chunk_root->sectorsize,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eb6537a..8444eb0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1344,9 +1344,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	if (!backref_ctx->found_itself) {
 		/* found a bug in backref code? */
 		ret = -EIO;
-		btrfs_err(sctx->send_root->fs_info, "did not find backref in "
-				"send_root. inode=%llu, offset=%llu, "
-				"disk_byte=%llu found extent=%llu\n",
+		btrfs_err(sctx->send_root->fs_info, "did not find backref in send_root. inode=%llu, offset=%llu, disk_byte=%llu found extent=%llu\n",
 				ino, data_offset, disk_byte, found_key.objectid);
 		goto out;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 558f46c..0e63afb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3152,8 +3152,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
 		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
-			btrfs_err(fs_info, "with mixed groups data and "
-				   "metadata balance options must be the same");
+			btrfs_err(fs_info, "with mixed groups data and metadata balance options must be the same");
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3179,8 +3178,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
 	     (bctl->data.target & ~allowed))) {
-		btrfs_err(fs_info, "unable to start balance with target "
-			   "data profile %llu",
+		btrfs_err(fs_info, "unable to start balance with target data profile %llu",
 		       bctl->data.target);
 		ret = -EINVAL;
 		goto out;
@@ -3229,8 +3227,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 			if (bctl->flags & BTRFS_BALANCE_FORCE) {
 				btrfs_info(fs_info, "force reducing metadata integrity");
 			} else {
-				btrfs_err(fs_info, "balance will reduce metadata "
-					   "integrity, use force if you want this");
+				btrfs_err(fs_info, "balance will reduce metadata integrity, use force if you want this");
 				ret = -EINVAL;
 				goto out;
 			}
-- 
1.8.1.4

