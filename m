Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45331 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3F3DRf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 23:17:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 727479A0402
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 21:17:34 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 8CnjcjNlvrNoeEf8 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 21:17:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
Date: Sat, 29 Jun 2013 23:17:31 -0400
Message-ID: <1372562251-27123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
forward in the tree mod entries, otherwise we'll end up with random entries and
trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
people were seeing when running

find /whatever -type f -exec btrfs fi defrag {} \;

Thansk,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c32d03d..7921e1d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1161,8 +1161,8 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
  * time_seq).
  */
 static void
-__tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
-		      struct tree_mod_elem *first_tm)
+__tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
+		      u64 time_seq, struct tree_mod_elem *first_tm)
 {
 	u32 n;
 	struct rb_node *next;
@@ -1172,6 +1172,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
+	tree_mod_log_read_lock(fs_info);
 	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
@@ -1226,6 +1227,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		if (tm->index != first_tm->index)
 			break;
 	}
+	tree_mod_log_read_unlock(fs_info);
 	btrfs_set_header_nritems(eb, n);
 }
 
@@ -1274,7 +1276,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 
 	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
-	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
+	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
 
@@ -1350,7 +1352,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_set_header_generation(eb, old_generation);
 	}
 	if (tm)
-		__tree_mod_log_rewind(eb, time_seq, tm);
+		__tree_mod_log_rewind(root->fs_info, eb, time_seq, tm);
 	else
 		WARN_ON(btrfs_header_level(eb) != 0);
 	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
-- 
1.7.7.6

