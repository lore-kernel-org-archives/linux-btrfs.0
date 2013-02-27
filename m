Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904Ab3B0NaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:30:00 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1RDTvfu005090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:30:00 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1RDTuvD014505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:29:57 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1RDTuI4016600
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 07:29:56 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix memory leak of log roots
Date: Wed, 27 Feb 2013 21:28:24 +0800
Message-Id: <1361971705-8933-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1361971705-8933-1-git-send-email-bo.li.liu@oracle.com>
References: <1361971705-8933-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we abort a transaction while fsyncing, we'll skip freeing log roots
part of committing a transaction, which leads to memory leak.

This adds a 'free log roots' in putting super when no more users hold
references on log roots, so it's safe and clean.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c  |    5 +++++
 fs/btrfs/tree-log.c |    6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65f0367..1ce5611 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3195,6 +3195,11 @@ void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	if (btrfs_root_refs(&root->root_item) == 0)
 		synchronize_srcu(&fs_info->subvol_srcu);
 
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		btrfs_free_log(NULL, root);
+		btrfs_free_log_root_tree(NULL, fs_info);
+	}
+
 	__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9027bb1..a74d2fc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2461,8 +2461,10 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 		.process_func = process_one_buffer
 	};
 
-	ret = walk_log_tree(trans, log, &wc);
-	BUG_ON(ret);
+	if (trans) {
+		ret = walk_log_tree(trans, log, &wc);
+		BUG_ON(ret);
+	}
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
-- 
1.7.7

