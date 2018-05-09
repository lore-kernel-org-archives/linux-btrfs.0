Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60689 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934912AbeEINJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:09:12 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] btrfs: return original error code when failing from option parsing
Date: Wed,  9 May 2018 21:08:23 +0800
Message-Id: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no good to overwrite -ENOMEM using -EINVAL when failing
from mount option parsing, so just return original error code.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/btrfs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0628092..ae6447d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1783,7 +1783,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 	ret = btrfs_parse_options(fs_info, data, *flags);
 	if (ret) {
-		ret = -EINVAL;
 		goto restore;
 	}
 
-- 
1.8.3.1

