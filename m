Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdBTSZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:25:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 564EFAAB2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:25:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: handle allocation error in update_dev_stat_item
Date: Mon, 20 Feb 2017 19:25:04 +0100
Message-Id: <b5cd1b62a67b7ee96ae495628aef097294f7797d.1487614974.git.dsterba@suse.com>
In-Reply-To: <cover.1487614974.git.dsterba@suse.com>
References: <cover.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1fac98728814..64d6665f6eda 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6954,7 +6954,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 	key.offset = device->devid;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
 	if (ret < 0) {
 		btrfs_warn_in_rcu(fs_info,
-- 
2.10.1

