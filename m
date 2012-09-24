Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48360 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2IXT53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 15:57:29 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id jHPm7zen169MBvsJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 13:57:28 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
Date: Mon, 24 Sep 2012 16:02:59 -0400
Message-ID: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Things like btrfs_drop_extents call btrfs_next_leaf to see if there is
anything else they need on the next leaf.  This will result in a re-search,
but if we are already at the last leaf in the tree or if the first item in
the next leaf doesn't match the objectid of the one we want we can just
return without doing the search at all.  This helps in things like fsync()
where our tree is pretty shallow and we're likely to be on the last leaf
often.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   27 +++++++++++++++++++++++++++
 fs/btrfs/ctree.h |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d183f6..64ea61c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2441,6 +2441,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
+	p->shecantgoanyfarthercapt = 1;
 
 	if (ins_len < 0) {
 		lowest_unlock = 2;
@@ -2568,6 +2569,13 @@ cow_done:
 
 		if (level != 0) {
 			int dec = 0;
+
+			/*
+			 * Slot is not the last in the node, we can go farther
+			 * capt.
+			 */
+			if (slot < btrfs_header_nritems(b))
+				p->shecantgoanyfarthercapt = 0;
 			if (ret && slot > 0) {
 				dec = 1;
 				slot -= 1;
@@ -5612,8 +5620,27 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	if (nritems == 0)
 		return 1;
+	if (path->shecantgoanyfarthercapt)
+		return 1;
+	if (!path->nodes[1])
+		return 1;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, nritems - 1);
+
+	/*
+	 * If we have the level above us locked already just check and see if
+	 * the key in the next leaf even has the same objectid, and if not
+	 * return 1 and avoid the search.
+	 */
+	if (path->locks[1] &&
+	    path->slots[1] + 1 < btrfs_header_nritems(path->nodes[1])) {
+		struct btrfs_key tmp;
+
+		btrfs_node_key_to_cpu(path->nodes[1], &tmp,
+				      path->slots[1] + 1);
+		if (key.objectid != tmp.objectid)
+			return 1;
+	}
 again:
 	level = 1;
 	next = NULL;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6f2e7e6..2e5c6c5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -571,6 +571,7 @@ struct btrfs_path {
 	unsigned int skip_locking:1;
 	unsigned int leave_spinning:1;
 	unsigned int search_commit_root:1;
+	unsigned int shecantgoanyfarthercapt:1;
 };
 
 /*
-- 
1.7.7.6

