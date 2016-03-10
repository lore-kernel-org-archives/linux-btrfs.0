Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993AbcCJEt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 23:49:26 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: rename btrfs_print_info to btrfs_print_mod_info
Date: Thu, 10 Mar 2016 12:49:14 +0800
Message-Id: <1457585354-6419-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that it indicates what it does.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 29836ca..3b5b192 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2171,7 +2171,7 @@ static void btrfs_interface_exit(void)
 	misc_deregister(&btrfs_misc);
 }
 
-static void btrfs_print_info(void)
+static void btrfs_print_mod_info(void)
 {
 	printk(KERN_INFO "Btrfs loaded"
 #ifdef CONFIG_BTRFS_DEBUG
@@ -2270,7 +2270,7 @@ static int __init init_btrfs_fs(void)
 
 	btrfs_init_lockdep();
 
-	btrfs_print_info();
+	btrfs_print_mod_info();
 
 	err = btrfs_run_sanity_tests();
 	if (err)
-- 
2.6.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
