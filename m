Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8365C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF49222B1
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550060050;
	bh=6FBeO0I+XrxF/zLKkVITbPtCJ6poZqncH7AFCKXQMxw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oNZ6ZRliqHuDYqYjB5Tf3+T83W5S5zV5h8vUGgsYhm8faSqToz3Isst43xmkYUQSk
	 FfjzvD65vE1thRE8gB7CdPftd73fnKpLbN1xtBBb4PXnCrzgTHlJvdGSehIL1okHtI
	 Au4by8wBCX687UM3LcCJXlF+DNorzVZzYo+zlFXU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfBMMOJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfBMMOJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 07:14:09 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33023222B1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550060047;
        bh=6FBeO0I+XrxF/zLKkVITbPtCJ6poZqncH7AFCKXQMxw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KBsBsERMVyI+Tw1xHS2sHnMzfsOT5JBiW6igShfIuMlHZHnsgn918P7YR3GPkhMzB
         8+0IS1iM6jDJo8PpfHy9Sv8MRMAinYXr+FG99E1w1QuhoJxFnifHOZTDNbTAmZNCD7
         ydBMsmh051gh4zaQsg8jP5usiDKekDE2d2yTlzBM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] Btrfs: fix fsync after succession of renames of different files
Date:   Wed, 13 Feb 2019 12:14:03 +0000
Message-Id: <20190213121403.3386-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190212180628.25682-1-fdmanana@kernel.org>
References: <20190212180628.25682-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

After a succession of rename operations of different files and fsyncing
one of them, such that each file gets a new name that corresponds to an
old name of another file, we can end up with a log that will cause a
failure when attempted to replay at mount time (an EEXIST error).
We currently have correct behaviour when such succession of renames
involves only two files, but if there are more files involved, we end up
not logging all the inodes that are needed, therefore resulting in a
failure when attempting to replay the log.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/testdir
  $ touch /mnt/testdir/fname1
  $ touch /mnt/testdir/fname2

  $ sync

  $ mv /mnt/testdir/fname1 /mnt/testdir/fname3
  $ mv /mnt/testdir/fname2 /mnt/testdir/fname4
  $ ln /mnt/testdir/fname3 /mnt/testdir/fname2

  $ touch /mnt/testdir/fname1
  $ xfs_io -c "fsync" /mnt/testdir/fname1

  <power failure>

  $ mount /dev/sdb /mnt
  mount: mount /dev/sdb on /mnt failed: File exists

So fix this by checking all inode dependencies when logging an inode. That
is, if one logged inode A has a new name that matches the old name of some
other inode B, check if inode B has a new name that matches the old name
of some other inode C, and so on. This fix is implemented not by doing any
recursive function calls but by using an iterative method using a linked
list that is used in a first-in-first-out fashion.

A test case for fstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Reformatted a comment. Updated 2nd patch in the series.

 fs/btrfs/tree-log.c | 247 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 203 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ac232b3d6d7e..eda5c91accd1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1330,6 +1330,72 @@ static int btrfs_inode_ref_exists(struct inode *inode, struct inode *dir,
 	return ret;
 }
 
+static int add_link(struct btrfs_trans_handle *trans,
+		    struct btrfs_root *root,
+		    struct inode *dir,
+		    struct inode *inode,
+		    const char *name,
+		    int namelen,
+		    u64 ref_index)
+{
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct inode *other_inode = NULL;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	dir_item = btrfs_lookup_dir_item(NULL, root, path,
+					 btrfs_ino(BTRFS_I(dir)),
+					 name, namelen, 0);
+	if (!dir_item) {
+		btrfs_release_path(path);
+		goto add_link;
+	} else if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+
+	/*
+	 * Our inode's dentry collides with the dentry of another inode which is
+	 * in the log but not yet processed since it has a higher inode number.
+	 * So delete that other dentry.
+	 */
+	btrfs_dir_item_key_to_cpu(path->nodes[0], dir_item, &key);
+	btrfs_release_path(path);
+	other_inode = read_one_inode(root, key.objectid);
+	if (!other_inode) {
+		ret = -ENOENT;
+		goto out;
+	}
+	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+				 BTRFS_I(other_inode),
+				 name, namelen);
+	if (ret)
+		goto out;
+	/*
+	 * If we dropped the link count to 0, bump it so that later the iput()
+	 * on the inode will not free it. We will fixup the link count later.
+	 */
+	if (other_inode->i_nlink == 0)
+		inc_nlink(other_inode);
+
+	ret = btrfs_run_delayed_items(trans);
+	if (ret)
+		goto out;
+add_link:
+	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
+			     name, namelen, 0, ref_index);
+out:
+	iput(other_inode);
+	btrfs_free_path(path);
+
+	return ret;
+}
+
 /*
  * replay one inode back reference item found in the log tree.
  * eb, slot and key refer to the buffer and key found in the log tree.
@@ -1466,9 +1532,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				goto out;
 
 			/* insert our name */
-			ret = btrfs_add_link(trans, BTRFS_I(dir),
-					BTRFS_I(inode),
-					name, namelen, 0, ref_index);
+			ret = add_link(trans, root, dir, inode,
+				       name, namelen, ref_index);
 			if (ret)
 				goto out;
 
@@ -4780,8 +4845,12 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 			btrfs_dir_item_key_to_cpu(search_path->nodes[0],
 						  di, &di_key);
 			if (di_key.type == BTRFS_INODE_ITEM_KEY) {
-				ret = 1;
-				*other_ino = di_key.objectid;
+				if (di_key.objectid != key->objectid) {
+					ret = 1;
+					*other_ino = di_key.objectid;
+				} else {
+					ret = 0;
+				}
 			} else {
 				ret = -EAGAIN;
 			}
@@ -4801,6 +4870,127 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 	return ret;
 }
 
+struct btrfs_ino_list {
+	u64 ino;
+	struct list_head list;
+};
+
+static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_path *path,
+				  struct btrfs_log_ctx *ctx,
+				  u64 ino)
+{
+	struct btrfs_ino_list *ino_elem;
+	LIST_HEAD(inode_list);
+	int ret = 0;
+
+	ino_elem = kmalloc(sizeof(*ino_elem), GFP_NOFS);
+	if (!ino_elem)
+		return -ENOMEM;
+	ino_elem->ino = ino;
+	list_add_tail(&ino_elem->list, &inode_list);
+
+	while (!list_empty(&inode_list)) {
+		struct btrfs_fs_info *fs_info = root->fs_info;
+		struct btrfs_key key;
+		struct inode *inode;
+
+		ino_elem = list_first_entry(&inode_list, struct btrfs_ino_list,
+					    list);
+		ino = ino_elem->ino;
+		list_del(&ino_elem->list);
+		kfree(ino_elem);
+		if (ret)
+			continue;
+
+		btrfs_release_path(path);
+
+		key.objectid = ino;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+		inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+		/*
+		 * If the other inode that had a conflicting dir entry was
+		 * deleted in the current transaction, we don't need to do more
+		 * work nor fallback to a transaction commit.
+		 */
+		if (IS_ERR(inode)) {
+			ret = PTR_ERR(inode);
+			if (ret == -ENOENT)
+				ret = 0;
+			continue;
+		}
+		/*
+		 * We are safe logging the other inode without acquiring its
+		 * lock as long as we log with the LOG_INODE_EXISTS mode. We
+		 * are safe against concurrent renames of the other inode as
+		 * well because during a rename we pin the log and update the
+		 * log with the new name before we unpin it.
+		 */
+		ret = btrfs_log_inode(trans, root, BTRFS_I(inode),
+				      LOG_OTHER_INODE, 0, LLONG_MAX, ctx);
+		if (ret) {
+			iput(inode);
+			continue;
+		}
+
+		key.objectid = ino;
+		key.type = BTRFS_INODE_REF_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0) {
+			iput(inode);
+			continue;
+		}
+
+		while (true) {
+			struct extent_buffer *leaf = path->nodes[0];
+			int slot = path->slots[0];
+			u64 other_ino = 0;
+
+			if (slot >= btrfs_header_nritems(leaf)) {
+				ret = btrfs_next_leaf(root, path);
+				if (ret < 0) {
+					break;
+				} else if (ret > 0) {
+					ret = 0;
+					break;
+				}
+				continue;
+			}
+
+			btrfs_item_key_to_cpu(leaf, &key, slot);
+			if (key.objectid != ino ||
+			    (key.type != BTRFS_INODE_REF_KEY &&
+			     key.type != BTRFS_INODE_EXTREF_KEY)) {
+				ret = 0;
+				break;
+			}
+
+			ret = btrfs_check_ref_name_override(leaf, slot, &key,
+							    BTRFS_I(inode),
+							    &other_ino);
+			if (ret < 0)
+				break;
+			if (ret > 0) {
+				ino_elem = kmalloc(sizeof(*ino_elem), GFP_NOFS);
+				if (!ino_elem) {
+					ret = -ENOMEM;
+					break;
+				}
+				ino_elem->ino = other_ino;
+				list_add_tail(&ino_elem->list, &inode_list);
+				ret = 0;
+			}
+			path->slots[0]++;
+		}
+		iput(inode);
+	}
+
+	return ret;
+}
+
 /* log a single inode in the tree log.
  * At least one parent directory for this inode must exist in the tree
  * or be logged already.
@@ -4840,6 +5030,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	u64 logged_isize = 0;
 	bool need_log_inode_item = true;
 	bool xattrs_logged = false;
+	bool recursive_logging = (inode_only == LOG_OTHER_INODE);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4981,7 +5172,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 		if ((min_key.type == BTRFS_INODE_REF_KEY ||
 		     min_key.type == BTRFS_INODE_EXTREF_KEY) &&
-		    inode->generation == trans->transid) {
+		    inode->generation == trans->transid &&
+		    !recursive_logging) {
 			u64 other_ino = 0;
 
 			ret = btrfs_check_ref_name_override(path->nodes[0],
@@ -4992,9 +5184,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				goto out_unlock;
 			} else if (ret > 0 && ctx &&
 				   other_ino != btrfs_ino(BTRFS_I(ctx->inode))) {
-				struct btrfs_key inode_key;
-				struct inode *other_inode;
-
 				if (ins_nr > 0) {
 					ins_nr++;
 				} else {
@@ -5010,43 +5199,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 					goto out_unlock;
 				}
 				ins_nr = 0;
-				btrfs_release_path(path);
-				inode_key.objectid = other_ino;
-				inode_key.type = BTRFS_INODE_ITEM_KEY;
-				inode_key.offset = 0;
-				other_inode = btrfs_iget(fs_info->sb,
-							 &inode_key, root,
-							 NULL);
-				/*
-				 * If the other inode that had a conflicting dir
-				 * entry was deleted in the current transaction,
-				 * we don't need to do more work nor fallback to
-				 * a transaction commit.
-				 */
-				if (other_inode == ERR_PTR(-ENOENT)) {
-					goto next_key;
-				} else if (IS_ERR(other_inode)) {
-					err = PTR_ERR(other_inode);
-					goto out_unlock;
-				}
-				/*
-				 * We are safe logging the other inode without
-				 * acquiring its i_mutex as long as we log with
-				 * the LOG_INODE_EXISTS mode. We're safe against
-				 * concurrent renames of the other inode as well
-				 * because during a rename we pin the log and
-				 * update the log with the new name before we
-				 * unpin it.
-				 */
-				err = btrfs_log_inode(trans, root,
-						BTRFS_I(other_inode),
-						LOG_OTHER_INODE, 0, LLONG_MAX,
-						ctx);
-				iput(other_inode);
+
+				err = log_conflicting_inodes(trans, root, path,
+							     ctx, other_ino);
 				if (err)
 					goto out_unlock;
-				else
-					goto next_key;
+				btrfs_release_path(path);
+				goto next_key;
 			}
 		}
 
-- 
2.11.0

