Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab3KRNYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 08:24:23 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 80E74A7B44
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2013 14:24:22 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: reserve no transaction units in btrfs_feature_attr_store
Date: Mon, 18 Nov 2013 14:24:20 +0100
Message-Id: <1384781060-12353-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added in patch "btrfs: add ability to change features via sysfs",
modifications to superblock don't need to reserve metadata blocks when
starting a transaction.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 669fdf777b6c..8fdc0520e298 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -150,7 +150,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
-	trans = btrfs_start_transaction(fs_info->fs_root, 1);
+	trans = btrfs_start_transaction(fs_info->fs_root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-- 
1.8.4.2

