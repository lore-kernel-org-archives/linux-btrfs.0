Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760001Ab2EQMAZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 08:00:25 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4HC0LYg006047
	for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 20:00:23 +0800
Message-ID: <4FB4E7FD.8050108@cn.fujitsu.com>
Date: Thu, 17 May 2012 19:58:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs: fix memory leak in btrfs_pause_balance()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to free fs_info->balance_ctl in the btrfs_pause_balance()
when umounting the fs.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c536d52..fd7fe80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2937,6 +2937,9 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
 		ret = -ENOTCONN;
 	}
 
+	if (btrfs_fs_closing(fs_info) && fs_info->balance_ctl)
+		unset_balance_control(fs_info);
+
 	mutex_unlock(&fs_info->balance_mutex);
 	return ret;
 }
-- 
1.7.6.5
