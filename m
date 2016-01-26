Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33690 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcAZHNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 02:13:24 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so93857628pac.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 23:13:23 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs: simplify expression in btrfs_csum_bytes_to_leaves()
Date: Tue, 26 Jan 2016 16:13:17 +0900
Message-Id: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplify expression in btrfs_csum_bytes_to_leaves().

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/ctree.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a9496644f47d..3ab8026280a2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3448,8 +3448,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
 						 unsigned num_items)
 {
-	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
-		2 * num_items;
+	return root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
 }
 
 /*
-- 
2.7.0

