Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54320 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab3KNJcY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 04:32:24 -0500
From: Miao Xie <miaox@cn.fujitsu.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix list delete warning when removing ordered root from the list
Date: Thu, 14 Nov 2013 17:33:21 +0800
Message-Id: <1384421601-3295-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit b02441999efcc6152b87cd58e7970bb7843f76cf "Btrfs: don't wait for
the completion of all the ordered extents" introduced a bug that broke
the ordered root list:
 WARNING: CPU: 1 PID: 7119 at lib/list_debug.c:59 __list_del_entry+0x5a/0x98()

It is because we forgot to return the roots in the splice list to the
ordered list of the fs. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 19484b1..201e2a7 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -654,6 +654,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			WARN_ON(nr < 0);
 		}
 	}
+	list_splice_tail(&splice, &fs_info->ordered_roots);
 	spin_unlock(&fs_info->ordered_root_lock);
 }
 
-- 
1.8.3.1

