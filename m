Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58983 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755614AbeEJBqR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 21:46:17 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] btrfs: return original error code when failing from option parsing
Date: Thu, 10 May 2018 09:45:55 +0800
Message-Id: <1525916755-141259-1-git-send-email-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no good to overwrite -ENOMEM using -EINVAL when failing
from mount option parsing, so just return original error code.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
v1->v2:
- Remove bracket for single line branch.

 fs/btrfs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0628092..c67fafa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1782,10 +1782,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	ret = btrfs_parse_options(fs_info, data, *flags);
-	if (ret) {
-		ret = -EINVAL;
+	if (ret)
 		goto restore;
-	}
 
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
-- 
1.8.3.1

