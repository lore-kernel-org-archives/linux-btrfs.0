Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56711 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbaC0S4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 14:56:55 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2RIjJ9J032555
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 11:56:55 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1jvqfd0jfv-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 11:56:54 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not reset last_snapshot after relocation
Date: Thu, 27 Mar 2014 14:56:51 -0400
Message-ID: <1395946611-6568-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was done to allow NO_COW to continue to be NO_COW after relocation but it
is not right.  When relocating we will convert blocks to FULL_BACKREF that we
relocate.  We can leave some of these full backref blocks behind if they are not
cow'ed out during the relocation, like if we fail the relocation with ENOSPC and
then just drop the reloc tree.  Then when we go to cow the block again we won't
lookup the extent flags because we won't think there has been a snapshot
recently which means we will do our normal ref drop thing instead of adding back
a tree ref and dropping the shared ref.  This will cause btrfs_free_extent to
blow up because it can't find the ref we are trying to free.  This was found
with my ref verifying tool.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/relocation.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ec00777..f026a82 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2318,7 +2318,6 @@ void free_reloc_roots(struct list_head *list)
 static noinline_for_stack
 int merge_reloc_roots(struct reloc_control *rc)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
 	u64 last_snap;
@@ -2376,26 +2375,6 @@ again:
 				list_add_tail(&reloc_root->root_list,
 					      &reloc_roots);
 			goto out;
-		} else if (!ret) {
-			/*
-			 * recover the last snapshot tranid to avoid
-			 * the space balance break NOCOW.
-			 */
-			root = read_fs_root(rc->extent_root->fs_info,
-					    objectid);
-			if (IS_ERR(root))
-				continue;
-
-			trans = btrfs_join_transaction(root);
-			BUG_ON(IS_ERR(trans));
-
-			/* Check if the fs/file tree was snapshoted or not. */
-			if (btrfs_root_last_snapshot(&root->root_item) ==
-			    otransid - 1)
-				btrfs_set_root_last_snapshot(&root->root_item,
-							     last_snap);
-				
-			btrfs_end_transaction(trans, root);
 		}
 	}
 
-- 
1.8.3.1

