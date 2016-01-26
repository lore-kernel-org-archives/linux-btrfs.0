Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35215 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966504AbcAZQdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 11:33:21 -0500
Received: by mail-pf0-f196.google.com with SMTP id q63so1132477pfb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 08:33:21 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2] btrfs: simplify expression in btrfs_calc_trans_metadata_size()
Date: Wed, 27 Jan 2016 01:33:04 +0900
Message-Id: <1453825984-12100-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplify expression in btrfs_calc_trans_metadata_size().

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
v2:
  Fix wrong function's name in commit log.
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

