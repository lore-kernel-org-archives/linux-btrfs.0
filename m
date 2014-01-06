Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaAFJ0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 04:26:07 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/4] Btrfs: fix wrong send_in_progress accounting
Date: Mon, 6 Jan 2014 17:25:06 +0800
Message-Id: <1389000306-15320-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:

 # mkfs.btrfs -f /dev/sda8
 # mount /dev/sda8 /mnt
 # btrfs sub snapshot -r /mnt /mnt/snap1
 # btrfs sub snapshot -r /mnt /mnt/snap2
 # btrfs send /mnt/snap2 -p /mnt/snap1

As @send_root will also add into clone_sources, and we should
take care not to decrease its count twice.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Hi david, i am ok to fold this patch into your previous patch
or as a seperated patch.
---
 fs/btrfs/send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bff0b1a..076b066 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4908,6 +4908,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			spin_unlock(&clone_root->root_item_lock);
 			sctx->clone_roots[i].root = clone_root;
 		}
+		clone_sources_to_rollback--;
 		vfree(clone_sources_tmp);
 		clone_sources_tmp = NULL;
 	}
-- 
1.8.3.1

