Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E24C282CA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 251EF2229F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549994816;
	bh=TAwoSlEeTZdFHntOvAHX9spJyaERS+pS64pO1zyEYE8=;
	h=From:To:Subject:Date:List-ID:From;
	b=w2btD22UyQkn41Mi5FtOAzP2m2Xde8RiUCKkgVlC2fsVsgowNLD8+4bmyWkhyOlfJ
	 BbGiA/o7u7qbKyJcVI0jeES9ooD9/H9s60gJyzcu+yPZ/LiY/+fxCBuNQlI0+oZDRh
	 pB6325vJ6kEtHUiAkW5k+Ix5TK6QlgGXFfJ3PdEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfBLSGx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbfBLSGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 13:06:53 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF872229F
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549994812;
        bh=TAwoSlEeTZdFHntOvAHX9spJyaERS+pS64pO1zyEYE8=;
        h=From:To:Subject:Date:From;
        b=bmNJqfdniPuRmeY771n/9r45FXc3tAQy8bw4LDKon/VCiIriOV0sB7n0gScgwhOSm
         /HQLAINaPY3PDFIWkOaEqgQAlvIE529v70DBbyMygnifUwkMrx2EsN+Vzr8C5Nr5yg
         TN1jKI7DiDJf4KEdd0lPBCLB0LaH1mUfU8geY3Tk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix fsync after succession of renames and unlink/rmdir
Date:   Tue, 12 Feb 2019 18:06:49 +0000
Message-Id: <20190212180649.32675-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

After a succession of renames operations of different files and unlinking
one of them, if we fsync one of the renamed files we can end up with a
log that will either fail to replay at mount time or result in a filesystem
that is in an inconsistent state. One example scenario:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/testdir
  $ touch /mnt/testdir/fname1
  $ touch /mnt/testdir/fname2

  $ sync

  $ mv /mnt/testdir/fname1 /mnt/testdir/fname3
  $ rm -f /mnt/testdir/fname2
  $ ln /mnt/testdir/fname3 /mnt/testdir/fname2

  $ touch /mnt/testdir/fname1
  $ xfs_io -c "fsync" /mnt/testdir/fname1

  <power failure>

  $ mount /dev/sdb /mnt
  $ umount /mnt
  $ btrfs check /dev/sdb
  [1/7] checking root items
  [2/7] checking extents
  [3/7] checking free space cache
  [4/7] checking fs roots
  root 5 inode 259 errors 2, no orphan item
  ERROR: errors found in fs roots
  Opening filesystem to check...
  Checking filesystem on /dev/sdc
  UUID: 20e4abb8-5a19-4492-8bb4-6084125c2d0d
  found 393216 bytes used, error(s) found
  total csum bytes: 0
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 122986
  file data blocks allocated: 262144
   referenced 262144

On a kernel without the first patch in this series, titled
"[PATCH] Btrfs: fix fsync after succession of renames of different files",
we get instead an error when mounting the filesystem due to failure of
replaying the log:

  $ mount /dev/sdb /mnt
  mount: mount /dev/sdb on /mnt failed: File exists

Fix this by logging the parent directory of an inode whenever we find an
inode that no longer exists (was unlinked in the current transaction),
during the procedure which finds inodes that have old names that collide
with new names of other inodes.

A test case for fstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8d52413b4f80..cbc7233e6f12 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4783,7 +4783,8 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 					 const int slot,
 					 const struct btrfs_key *key,
 					 struct btrfs_inode *inode,
-					 u64 *other_ino)
+					 u64 *other_ino,
+					 u64 *other_parent)
 {
 	int ret;
 	struct btrfs_path *search_path;
@@ -4849,6 +4850,7 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 				if (di_key.objectid != key->objectid) {
 					ret = 1;
 					*other_ino = di_key.objectid;
+					*other_parent = parent;
 				} else {
 					ret = 0;
 				}
@@ -4873,6 +4875,7 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 
 struct btrfs_ino_list {
 	u64 ino;
+	u64 parent;
 	struct list_head list;
 };
 
@@ -4880,7 +4883,8 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_path *path,
 				  struct btrfs_log_ctx *ctx,
-				  u64 ino)
+				  u64 ino,
+				  u64 parent)
 {
 	struct btrfs_ino_list *ino_elem;
 	LIST_HEAD(inode_list);
@@ -4890,6 +4894,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 	if (!ino_elem)
 		return -ENOMEM;
 	ino_elem->ino = ino;
+	ino_elem->parent = parent;
 	list_add_tail(&ino_elem->list, &inode_list);
 
 	while (!list_empty(&inode_list)) {
@@ -4900,6 +4905,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 		ino_elem = list_first_entry(&inode_list, struct btrfs_ino_list,
 					    list);
 		ino = ino_elem->ino;
+		parent = ino_elem->parent;
 		list_del(&ino_elem->list);
 		kfree(ino_elem);
 		if (ret)
@@ -4913,13 +4919,26 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 		inode = btrfs_iget(fs_info->sb, &key, root, NULL);
 		/*
 		 * If the other inode that had a conflicting dir entry was
-		 * deleted in the current transaction, we don't need to do more
-		 * work nor fallback to a transaction commit.
+		 * deleted in the current transaction, we need to log its parent
+		 * directory.
 		 */
 		if (IS_ERR(inode)) {
 			ret = PTR_ERR(inode);
-			if (ret == -ENOENT)
-				ret = 0;
+			if (ret == -ENOENT) {
+				key.objectid = parent;
+				inode = btrfs_iget(fs_info->sb, &key, root,
+						   NULL);
+				if (IS_ERR(inode)) {
+					ret = PTR_ERR(inode);
+				} else {
+					ret = btrfs_log_inode(trans, root,
+							      BTRFS_I(inode),
+							      LOG_INODE_ALL,
+							      0, LLONG_MAX,
+							      ctx);
+					iput(inode);
+				}
+			}
 			continue;
 		}
 		/*
@@ -4949,6 +4968,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			struct extent_buffer *leaf = path->nodes[0];
 			int slot = path->slots[0];
 			u64 other_ino = 0;
+			u64 other_parent = 0;
 
 			if (slot >= btrfs_header_nritems(leaf)) {
 				ret = btrfs_next_leaf(root, path);
@@ -4971,7 +4991,8 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 
 			ret = btrfs_check_ref_name_override(leaf, slot, &key,
 							    BTRFS_I(inode),
-							    &other_ino);
+							    &other_ino,
+							    &other_parent);
 			if (ret < 0)
 				break;
 			if (ret > 0) {
@@ -4981,6 +5002,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 					break;
 				}
 				ino_elem->ino = other_ino;
+				ino_elem->parent = other_parent;
 				list_add_tail(&ino_elem->list, &inode_list);
 				ret = 0;
 			}
@@ -5176,10 +5198,11 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		    inode->generation == trans->transid &&
 		    !recursive_logging) {
 			u64 other_ino = 0;
+			u64 other_parent = 0;
 
 			ret = btrfs_check_ref_name_override(path->nodes[0],
 					path->slots[0], &min_key, inode,
-					&other_ino);
+					&other_ino, &other_parent);
 			if (ret < 0) {
 				err = ret;
 				goto out_unlock;
@@ -5202,7 +5225,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				ins_nr = 0;
 
 				err = log_conflicting_inodes(trans, root, path,
-							     ctx, other_ino);
+							     ctx, other_ino,
+							     other_parent);
 				if (err)
 					goto out_unlock;
 				btrfs_release_path(path);
-- 
2.11.0

