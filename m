Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40445 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbdBCQPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 11:15:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5DFFFAC46
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 16:15:42 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: Remove unused function arg in delete_extent_records
Date: Fri,  3 Feb 2017 10:15:32 -0600
Message-Id: <20170203161532.6111-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

new_len is not used in delete_extent_records().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 cmds-check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 84e1d99..9fb85e4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7969,7 +7969,7 @@ out:
 static int delete_extent_records(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
-				 u64 bytenr, u64 new_len)
+				 u64 bytenr)
 {
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -8975,7 +8975,7 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 
 	/* step two, delete all the existing records */
 	ret = delete_extent_records(trans, info->extent_root, &path,
-				    rec->start, rec->max_size);
+				    rec->start);
 
 	if (ret < 0)
 		goto out;
-- 
2.10.2

