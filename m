Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mproxygzc4.163.com ([218.107.63.212]:57087 "EHLO
        mproxygzc4.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbcLCLiZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 06:38:25 -0500
From: Pan Bian <bianpan2016@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] btrfs: volumes: fix improper return value
Date: Sat,  3 Dec 2016 19:01:45 +0800
Message-Id: <1480762905-5163-1-git-send-email-bianpan2016@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable ret takes the errno on failures. However, it directly returns 0.
It may be better to return "ret".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188741

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 71a60cc..32fd903 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4222,7 +4222,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 	else
 		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
 	up(&fs_info->uuid_tree_rescan_sem);
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.9.1


