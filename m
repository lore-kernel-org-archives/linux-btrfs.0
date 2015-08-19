Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:26245 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbHSFzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 01:55:40 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0B31EAC014B
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 14:55:38 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id DA6BF8E
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 14:55:37 +0900 (JST)
Message-Id: <201508190555.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Aug 2015 14:55:00 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup: remove unnecessary check before btrfs_free_path is called
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need not check path before btrfs_free_path() is called because
path is checked in btrfs_free_path().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 3 +--
 fs/btrfs/inode.c       | 3 +--
 fs/btrfs/tree-defrag.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 564a7de..e54dd59 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -183,8 +183,7 @@ no_valid_dev_replace_entry_found:
 	}
 
 out:
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e33dff3..21ba036 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6876,8 +6876,7 @@ out:
 
 	trace_btrfs_get_extent(root, em);
 
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	if (trans) {
 		ret = btrfs_end_transaction(trans, root);
 		if (!err)
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index a4b9c8b..f31db43 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -115,8 +115,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		ret = -EAGAIN;
 	}
 out:
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	if (ret == -EAGAIN) {
 		if (root->defrag_max.objectid > root->defrag_progress.objectid)
 			goto done;
-- 
2.4.5



