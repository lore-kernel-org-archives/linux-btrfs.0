Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40389 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdBMOau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:30:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF320AD45
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: check quota status earlier and don't do unnecessary frees
Date: Mon, 13 Feb 2017 15:30:20 +0100
Message-Id: <6c2c60a45506bd613251eece654c78a65205ccfc.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Status of quotas should be the first check in
btrfs_qgroup_account_extent and we can return immediatelly, no need to
do no-op ulist frees.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7cc2e2221f55..2b22223c2ad9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1945,13 +1945,14 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 	u64 nr_old_roots = 0;
 	int ret = 0;
 
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+
 	if (new_roots)
 		nr_new_roots = new_roots->nnodes;
 	if (old_roots)
 		nr_old_roots = old_roots->nnodes;
 
-	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
-		goto out_free;
 	BUG_ON(!fs_info->quota_root);
 
 	trace_btrfs_qgroup_account_extent(fs_info, bytenr, num_bytes,
-- 
2.10.1

