Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947175Ab3BHV2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 16:28:20 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 3A045A3A49
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 22:28:19 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: put some enospc messages under enospc_debug
Date: Fri,  8 Feb 2013 22:28:17 +0100
Message-Id: <1360358897-1743-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The warning in use_block_rsv is not useful for users and may fill
the logs unnecessarily.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

on top of for-linus 1a65e24b0bb7

 fs/btrfs/extent-tree.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a3327b..b0f3399 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6329,12 +6329,14 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	if (!ret)
 		return block_rsv;
 	if (ret && !block_rsv->failfast) {
-		static DEFINE_RATELIMIT_STATE(_rs,
-				DEFAULT_RATELIMIT_INTERVAL,
-				/*DEFAULT_RATELIMIT_BURST*/ 2);
-		if (__ratelimit(&_rs))
-			WARN(1, KERN_DEBUG "btrfs: block rsv returned %d\n",
-			     ret);
+		if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
+			static DEFINE_RATELIMIT_STATE(_rs,
+					DEFAULT_RATELIMIT_INTERVAL * 10,
+					/*DEFAULT_RATELIMIT_BURST*/ 1);
+			if (__ratelimit(&_rs))
+				WARN(1, KERN_DEBUG
+					"btrfs: block rsv returned %d\n", ret);
+		}
 		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
 					     BTRFS_RESERVE_NO_FLUSH);
 		if (!ret) {
@@ -7651,11 +7653,13 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
-		if (space_info->bytes_pinned > 0 ||
-		    space_info->bytes_reserved > 0 ||
-		    space_info->bytes_may_use > 0) {
-			WARN_ON(1);
-			dump_space_info(space_info, 0, 0);
+		if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
+			if (space_info->bytes_pinned > 0 ||
+			    space_info->bytes_reserved > 0 ||
+			    space_info->bytes_may_use > 0) {
+				WARN_ON(1);
+				dump_space_info(space_info, 0, 0);
+			}
 		}
 		list_del(&space_info->list);
 		kfree(space_info);
-- 
1.8.0.2

