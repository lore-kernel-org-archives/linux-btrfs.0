Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdBMNuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 08:50:51 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A6C14AD55
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 13:50:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: use GFP_KERNEL in btrfs_add/del_qgroup_relation
Date: Mon, 13 Feb 2017 14:50:16 +0100
Message-Id: <8d310939a7d232fc71524fdf83f5a8fdbd5eb31c.1486993643.git.dsterba@suse.com>
In-Reply-To: <cover.1486993643.git.dsterba@suse.com>
References: <cover.1486993643.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qgroup relations are added/deleted from ioctl, we hold the high level
qgroup lock, no deadlocks or recursion from the allocation possible
here.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4759fd46cfb5..d97353440a70 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1174,7 +1174,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
 		return -EINVAL;
 
-	tmp = ulist_alloc(GFP_NOFS);
+	tmp = ulist_alloc(GFP_KERNEL);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1234,7 +1234,7 @@ int __del_qgroup_relation(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int err;
 
-	tmp = ulist_alloc(GFP_NOFS);
+	tmp = ulist_alloc(GFP_KERNEL);
 	if (!tmp)
 		return -ENOMEM;
 
-- 
2.10.1

