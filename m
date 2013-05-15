Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab3EOHsj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:39 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 03/17] Btrfs: pause the space balance when remounting to R/O
Date: Wed, 15 May 2013 15:48:17 +0800
Message-Id: <1368604111-25073-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a4807ce..f0857e0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1263,6 +1263,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		btrfs_dev_replace_suspend_for_unmount(fs_info);
 		btrfs_scrub_cancel(fs_info);
+		btrfs_pause_balance(fs_info);
 
 		ret = btrfs_commit_super(root);
 		if (ret)
-- 
1.8.1.4

