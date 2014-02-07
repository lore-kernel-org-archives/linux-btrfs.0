Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaBGNeH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 08:34:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 647A4ABA6
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2014 13:34:07 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs: reserve no transaction units in btrfs_ioctl_set_features
Date: Fri,  7 Feb 2014 14:34:04 +0100
Message-Id: <c9aedf549bbff4c568e6e5e9f5d7c1be55bcc219.1391779611.git.dsterba@suse.cz>
In-Reply-To: <cover.1391779611.git.dsterba@suse.cz>
References: <cover.1391779611.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added in patch "btrfs: add ioctls to query/change feature bits online"
modifications to superblock don't need to reserve metadata blocks when
starting a transaction.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8e48b81e1515..383ab455bfa7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4668,7 +4668,7 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-- 
1.8.5.2

