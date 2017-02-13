Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdBMNup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 08:50:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D11AAD51
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 13:50:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: use GFP_KERNEL in btrfs_read_qgroup_config
Date: Mon, 13 Feb 2017 14:50:10 +0100
Message-Id: <908441dd1cc1b194326dae35c36715fc27d86bdf.1486993643.git.dsterba@suse.com>
In-Reply-To: <cover.1486993643.git.dsterba@suse.com>
References: <cover.1486993643.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The qgroup config is read during mount, we do not have to use NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8496dbf3f38b..cdd0a16bf469 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -319,7 +319,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return 0;
 
-	fs_info->qgroup_ulist = ulist_alloc(GFP_NOFS);
+	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.10.1

