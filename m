Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59609 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3IXSLu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 14:11:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EBD4C9A06A9
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 12:11:49 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 3JiwFwAZqa25ilEK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 12:11:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do a full search everytime in btrfs_search_old_slot
Date: Tue, 24 Sep 2013 14:11:47 -0400
Message-ID: <1380046307-25615-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running some snashot aware defrag tests I noticed I was panicing every
once and a while in key_search.  This is because of the optimization that says
if we find a key at slot 0 it will be at slot 0 all the way down the rest of the
tree.  This isn't the case for btrfs_search_old_slot since it will likely replay
changes to a buffer if something has changed since we took our sequence number.
So short circuit this optimization by setting prev_cmp to -1 every time we call
key_search so we will do our normal binary search.  With this patch I am no
longer seeing the panics I was seeing before.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c274a75..6932686 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2758,7 +2758,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
-	int prev_cmp;
+	int prev_cmp = -1;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2769,7 +2769,6 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 again:
-	prev_cmp = -1;
 	b = get_old_root(root, time_seq);
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
@@ -2787,6 +2786,11 @@ again:
 		 */
 		btrfs_unlock_up_safe(p, level + 1);
 
+		/*
+		 * Since we can unwind eb's we want to do a real search every
+		 * time.
+		 */
+		prev_cmp = -1;
 		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
-- 
1.8.3.1

