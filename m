Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55581 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab3AaTZy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:25:54 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id A3vsMPRynFkiJuo3 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 12:25:53 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix how we discard outstanding ordered extents on abort
Date: Thu, 31 Jan 2013 14:32:40 -0500
Message-ID: <1359660760-3137-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we abort we've been just free'ing up all the ordered extents and
hoping for the best.  This results in lots of warnings from various places,
warnings from btrfs_destroy_inode() because it's ENOSPC accounting isn't
fixed.  It will also screw up lots of pages who have been set private but
never get cleared because the ordered extents are never allowed to be
submitted.  This patch fixes those warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42f83aa..63adf80 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3565,35 +3565,17 @@ static void btrfs_destroy_ordered_operations(struct btrfs_root *root)
 
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
 {
-	struct list_head splice;
 	struct btrfs_ordered_extent *ordered;
 	struct inode *inode;
 
-	INIT_LIST_HEAD(&splice);
-
 	spin_lock(&root->fs_info->ordered_extent_lock);
-
-	list_splice_init(&root->fs_info->ordered_extents, &splice);
-	while (!list_empty(&splice)) {
-		ordered = list_entry(splice.next, struct btrfs_ordered_extent,
-				     root_extent_list);
-
-		list_del_init(&ordered->root_extent_list);
-		atomic_inc(&ordered->refs);
-
-		/* the inode may be getting freed (in sys_unlink path). */
-		inode = igrab(ordered->inode);
-
-		spin_unlock(&root->fs_info->ordered_extent_lock);
-		if (inode)
-			iput(inode);
-
-		atomic_set(&ordered->refs, 1);
-		btrfs_put_ordered_extent(ordered);
-
-		spin_lock(&root->fs_info->ordered_extent_lock);
-	}
-
+	/*
+	 * This will just short circuit the ordered completion stuff which will
+	 * make sure the ordered extent gets properly cleaned up.
+	 */
+	list_for_each_entry(ordered, &root->fs_info->ordered_extents,
+			    root_extent_list)
+		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 }
 
-- 
1.7.7.6

