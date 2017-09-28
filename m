Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33053 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751345AbdI1QQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 12:16:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 743CEAAD0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 16:16:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use DIV_ROUND_UP rathen than opencoding it
Date: Thu, 28 Sep 2017 16:48:19 +0300
Message-Id: <1506606499-15127-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2d7e86b51d1..9e67616892cd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,9 +2896,8 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
 	num_csums_per_leaf = div64_u64(csum_size,
 			(u64)btrfs_super_csum_size(fs_info->super_copy));
 	num_csums = div64_u64(csum_bytes, fs_info->sectorsize);
-	num_csums += num_csums_per_leaf - 1;
-	num_csums = div64_u64(num_csums, num_csums_per_leaf);
-	return num_csums;
+
+	return DIV_ROUND_UP(num_csums, num_csums_per_leaf);
 }
 
 int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
-- 
2.7.4

