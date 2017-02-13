Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdBMNuo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 08:50:44 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C0E0AD55
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 13:50:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: use GFP_KERNEL in btrfs_quota_enable
Date: Mon, 13 Feb 2017 14:50:13 +0100
Message-Id: <d542e28eef76e5f524675d94671da77e43d6bb21.1486993643.git.dsterba@suse.com>
In-Reply-To: <cover.1486993643.git.dsterba@suse.com>
References: <cover.1486993643.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to use GFP_NOFS here as this is called from ioctls an the
only lock held is the subvol_sem, which is of a high level and protects
creation/renames/deletion and is never held in the writeout paths.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cdd0a16bf469..4759fd46cfb5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -876,7 +876,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	fs_info->qgroup_ulist = ulist_alloc(GFP_NOFS);
+	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.10.1

