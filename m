Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5478 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759483AbdEXB3q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 21:29:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1E51847C6523
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 09:29:37 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: tree-log.c: Wrong printk information about namelen
Date: Wed, 24 May 2017 09:31:32 +0800
Message-ID: <20170524013132.7521-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In verify_dir_item, it wants to printk name_len of dir_item but
printk data_len acutally.

Fix it by calling btrfs_dir_name_len instead of btrfs_dir_data_len.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/dir-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 60a750678a82..c24d615e3d7f 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -468,7 +468,7 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
 		btrfs_crit(fs_info, "invalid dir item name len: %u",
-		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		       (unsigned)btrfs_dir_name_len(leaf, dir_item));
 		return 1;
 	}
 
-- 
2.13.0



