Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42537 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3G3Uei (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 16:34:38 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C0A449A0693
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 14:34:37 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 4X6m4Akha08Y2tJC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 14:34:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: change how we queue blocks for backref checking
Date: Tue, 30 Jul 2013 16:34:35 -0400
Message-ID: <1375216475-31796-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously we only added blocks to the list to have their backrefs checked if
the level of the block is right above the one we are searching for.  This is
because we want to make sure we don't add the entire path up to the root to the
lists to make sure we process things one at a time.  This assumes that if any
blocks in the path to the root are going to be not checked (shared in other
words) then they will be in the level right above the current block on up.  This
isn't quite right though since we can have blocks higher up the list that are
shared because they are attached to a reloc root.  But we won't add this block
to be checked and then later on we will BUG_ON(!upper->checked).  So instead
keep track of wether or not we've queued a block to be checked in this current
search, and if we haven't go ahead and queue it to be checked.  This patch fixed
the panic I was seeing where we BUG_ON(!upper->checked).  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/relocation.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8168fb3..2ec59c4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -696,6 +696,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 	int cowonly;
 	int ret;
 	int err = 0;
+	bool need_check = true;
 
 	path1 = btrfs_alloc_path();
 	path2 = btrfs_alloc_path();
@@ -919,6 +920,7 @@ again:
 			cur->bytenr);
 
 		lower = cur;
+		need_check = true;
 		for (; level < BTRFS_MAX_LEVEL; level++) {
 			if (!path2->nodes[level]) {
 				BUG_ON(btrfs_root_bytenr(&root->root_item) !=
@@ -962,14 +964,12 @@ again:
 
 				/*
 				 * add the block to pending list if we
-				 * need check its backrefs. only block
-				 * at 'cur->level + 1' is added to the
-				 * tail of pending list. this guarantees
-				 * we check backrefs from lower level
-				 * blocks to upper level blocks.
+				 * need check its backrefs, we only do this once
+				 * while walking up a tree as we will catch
+				 * anything else later on.
 				 */
-				if (!upper->checked &&
-				    level == cur->level + 1) {
+				if (!upper->checked && need_check) {
+					need_check = false;
 					list_add_tail(&edge->list[UPPER],
 						      &list);
 				} else
-- 
1.7.7.6

