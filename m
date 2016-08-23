Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751640AbcHWRWK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 13:22:10 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u7NHLG0w019374
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:22:10 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 250tnw044s-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:22:10 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: handle pending renames with recycled inodes properly
Date: Tue, 23 Aug 2016 13:22:03 -0400
Message-ID: <1471972923-4833-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suppose you have the following tree in snap1 on a file system mounted with -o
inode_cache so that inode numbers are recycled

└── [    258]  a
    └── [    257]  b

and then you remove b, rename a to c, and then re-create b in c so you have the
following tree

└── [    258]  c
    └── [    257]  b

and then you try to do an incremental send you will hit

ASSERT(pending_move == 0);

in process_all_refs().  This is because we assume that any recycling of inodes
will not have a pending change in our path, which isn't the case.  This is the
case for the DELETE side, since we want to remove the old file using the old
path, but on the create side we could have a pending move and need to do the
normal pending rename dance.  So remove this ASSERT() and put it after the
DELETE phase as it makes sense there, and change the CREATE stage to bail if we
have pending_move set.  This fixes the ASSERT() and results in the proper send
stream.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/send.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b71dd29..2992ff1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4063,7 +4063,8 @@ out:
  * generation number, which means that it was deleted and recreated.
  */
 static int process_all_refs(struct send_ctx *sctx,
-			    enum btrfs_compare_tree_result cmd)
+			    enum btrfs_compare_tree_result cmd,
+			    int *pending_move)
 {
 	int ret;
 	struct btrfs_root *root;
@@ -4073,7 +4074,6 @@ static int process_all_refs(struct send_ctx *sctx,
 	struct extent_buffer *eb;
 	int slot;
 	iterate_inode_ref_t cb;
-	int pending_move = 0;
 
 	path = alloc_path_for_send();
 	if (!path)
@@ -4126,10 +4126,7 @@ static int process_all_refs(struct send_ctx *sctx,
 	}
 	btrfs_release_path(path);
 
-	ret = process_recorded_refs(sctx, &pending_move);
-	/* Only applicable to an incremental send. */
-	ASSERT(pending_move == 0);
-
+	ret = process_recorded_refs(sctx, pending_move);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -5521,6 +5518,8 @@ static int changed_inode(struct send_ctx *sctx,
 		 * deleted and the new one as new.
 		 */
 		if (sctx->cur_inode_new_gen) {
+			int pending_move = 0;
+
 			/*
 			 * First, process the inode as if it was deleted.
 			 */
@@ -5532,11 +5531,19 @@ static int changed_inode(struct send_ctx *sctx,
 			sctx->cur_inode_mode = btrfs_inode_mode(
 					sctx->right_path->nodes[0], right_ii);
 			ret = process_all_refs(sctx,
-					BTRFS_COMPARE_TREE_DELETED);
+					BTRFS_COMPARE_TREE_DELETED, &pending_move);
 			if (ret < 0)
 				goto out;
 
 			/*
+			 * We are deleting the old inode, which shouldn't have
+			 * pending moves affecting it for the delete phase, as
+			 * the pending stuff doesn't matter until we are talking
+			 * about adding the new inode.
+			 */
+			ASSERT(pending_move == 0);
+
+			/*
 			 * Now process the inode as if it was new.
 			 */
 			sctx->cur_inode_gen = left_gen;
@@ -5551,10 +5558,21 @@ static int changed_inode(struct send_ctx *sctx,
 			ret = send_create_inode_if_needed(sctx);
 			if (ret < 0)
 				goto out;
-
-			ret = process_all_refs(sctx, BTRFS_COMPARE_TREE_NEW);
+			ret = process_all_refs(sctx, BTRFS_COMPARE_TREE_NEW, &pending_move);
 			if (ret < 0)
 				goto out;
+
+			/*
+			 * This can happen if we have deleted the old inode from
+			 * it's parent directory, moved that parent directory
+			 * somewhere else, and re-created the inode in that same
+			 * parent directory.  If this occurs we need to treat
+			 * this like any other new inode that needs pending
+			 * renames processed before we process this inode.
+			 */
+			if (pending_move)
+				goto out;
+
 			/*
 			 * Advance send_progress now as we did not get into
 			 * process_recorded_refs_if_needed in the new_gen case.
-- 
1.8.3.1

