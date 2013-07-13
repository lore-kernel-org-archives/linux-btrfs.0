Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37053 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3GMNDL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 09:03:11 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so9771231pad.2
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jul 2013 06:03:10 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: set qgroup_ulist to be null after calling ulist_free()
Date: Sat, 13 Jul 2013 21:02:54 +0800
Message-Id: <1373720574-23388-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

We call ulist_free(qgroup_ulist) in btrfs_free_qgroup_config(),
and btrfs_free_qgroup_config() may be called in two cases:

(1)umount filesystem
(2)disabling quota

However, if we firstly disable quota and then umount filesystem,
a double free happens. Fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1280eff..64a9e3c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -460,7 +460,13 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 		}
 		kfree(qgroup);
 	}
+	/*
+	 * we call btrfs_free_qgroup_config() when umounting
+	 * filesystem and disabling quota, so we set qgroup_ulit
+	 * to be null here to avoid double free.
+	 */
 	ulist_free(fs_info->qgroup_ulist);
+	fs_info->qgroup_ulist = NULL;
 }
 
 static int add_qgroup_relation_item(struct btrfs_trans_handle *trans,
-- 
1.7.11.7

