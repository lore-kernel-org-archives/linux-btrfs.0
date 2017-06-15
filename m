Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49650 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752409AbdFOPQY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 11:16:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9703BAB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 15:16:23 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use GFP_KERNEL in btrfs_init_dev_replace_tgtdev
Date: Thu, 15 Jun 2017 17:15:10 +0200
Message-Id: <20170615151510.2781-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is called from ioctl context and we don't hold any locks
that take part in writeback. Right now it's only fs_info::volume_mutex.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c6cd1d599c36..f7df85509125 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -242,7 +242,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		goto error;
 	}
 
-	name = rcu_string_strdup(device_path, GFP_NOFS);
+	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
 		kfree(device);
 		ret = -ENOMEM;
-- 
2.13.0

