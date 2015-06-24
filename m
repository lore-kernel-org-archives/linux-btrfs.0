Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbFXOc4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 10:32:56 -0400
Date: Wed, 24 Jun 2015 17:32:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: delayed-ref: double free in
 btrfs_add_delayed_tree_ref()
Message-ID: <20150624143233.GF1702@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a cut and paste error so instead of freeing "head_ref", we free
"ref" twice.

Fixes: 3368d001ba5d ('btrfs: qgroup: Record possible quota-related extent for qgroup.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index fd64fd0..ac3e81d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -650,18 +650,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 
 	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
-	if (!head_ref) {
-		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
-		return -ENOMEM;
-	}
+	if (!head_ref)
+		goto free_ref;
 
 	if (fs_info->quota_enabled && is_fstree(ref_root)) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
-		if (!record) {
-			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
-			kmem_cache_free(btrfs_delayed_ref_head_cachep, ref);
-			return -ENOMEM;
-		}
+		if (!record)
+			goto free_head_ref;
 	}
 
 	head_ref->extent_op = extent_op;
@@ -682,6 +677,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	spin_unlock(&delayed_refs->lock);
 
 	return 0;
+
+free_head_ref:
+	kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
+free_ref:
+	kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+
+	return -ENOMEM;
 }
 
 /*
