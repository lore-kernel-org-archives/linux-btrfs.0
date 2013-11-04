Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51294 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3KDN1z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 08:27:55 -0500
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] FS: BTRFS: fixed coding style issues
Date: Mon,  4 Nov 2013 15:27:38 +0200
Message-Id: <1383571658-7440-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixed three coding style issues. Replaced spaces with tabs.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/dev-replace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9efb94e..b2fe609 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -377,7 +377,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	printk_in_rcu(KERN_INFO
 		      "btrfs: dev_replace from %s (devid %llu) to %s) started\n",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+			rcu_str_deref(src_device->name),
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 
@@ -500,7 +500,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		printk_in_rcu(KERN_ERR
 			      "btrfs: btrfs_scrub_dev(%s, %llu, %s) failed %d\n",
 			      src_device->missing ? "<missing disk>" :
-			        rcu_str_deref(src_device->name),
+				rcu_str_deref(src_device->name),
 			      src_device->devid,
 			      rcu_str_deref(tgt_device->name), scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace);
@@ -515,7 +515,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	printk_in_rcu(KERN_INFO
 		      "btrfs: dev_replace from %s (devid %llu) to %s) finished\n",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+			rcu_str_deref(src_device->name),
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 	tgt_device->is_tgtdev_for_dev_replace = 0;
-- 
1.8.3.2

