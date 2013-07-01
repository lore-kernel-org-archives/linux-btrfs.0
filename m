Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43362 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3GANaq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 09:30:46 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9589C7C0434
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 07:30:46 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id W8Gevw5DmQx8Q8aK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 07:30:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make tree_mod_alloc return the struct its allocating
Date: Mon, 1 Jul 2013 09:30:43 -0400
Message-ID: <1372685443-32665-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lets try and be consistent with every other alloc() type function.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7921e1d..32e30ad 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -544,8 +544,8 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
  * Returns <0 on error.
  * Returns >0 (the added sequence number) on success.
  */
-static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
-				 struct tree_mod_elem **tm_ret)
+static inline struct tree_mod_elem *
+tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags)
 {
 	struct tree_mod_elem *tm;
 
@@ -555,13 +555,13 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
 	 */
 	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
 	if (!tm)
-		return -ENOMEM;
+		return NULL;
 
 	spin_lock(&fs_info->tree_mod_seq_lock);
 	tm->seq = btrfs_inc_tree_mod_seq_minor(fs_info);
 	spin_unlock(&fs_info->tree_mod_seq_lock);
 
-	return tm->seq;
+	return tm;
 }
 
 static inline int
@@ -572,9 +572,9 @@ __tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
 	int ret;
 	struct tree_mod_elem *tm;
 
-	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret < 0)
-		return ret;
+	tm = tree_mod_alloc(fs_info, flags);
+	if (!tm)
+		return -ENOMEM;
 
 	tm->index = eb->start >> PAGE_CACHE_SHIFT;
 	if (op != MOD_LOG_KEY_ADD) {
@@ -642,9 +642,11 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		BUG_ON(ret < 0);
 	}
 
-	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret < 0)
+	tm = tree_mod_alloc(fs_info, flags);
+	if (!tm) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	tm->index = eb->start >> PAGE_CACHE_SHIFT;
 	tm->slot = src_slot;
@@ -691,9 +693,11 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (log_removal)
 		__tree_mod_log_free_eb(fs_info, old_root);
 
-	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret < 0)
+	tm = tree_mod_alloc(fs_info, flags);
+	if (!tm) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	tm->index = new_root->start >> PAGE_CACHE_SHIFT;
 	tm->old_root.logical = old_root->start;
-- 
1.7.7.6

