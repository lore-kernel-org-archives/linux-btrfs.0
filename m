Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3B0XOS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 18:14:18 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C99F5A398E
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 00:14:16 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: remove a printk from scan_one_device
Date: Thu, 28 Feb 2013 00:13:55 +0100
Message-Id: <1362006835-12622-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave pointed out that he saw messages from btrfs although there was no
such filesystem on his computers. The automatic device scan is called on
every new blockdevice if the usual distro udev rule set is used. The
printk introduced in 6f60cbd3ae442c was a remainder from copying
portions of code from btrfs_get_bdev_and_sb which is used under
different conditions and the warning makes sense there.

Reported-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index db72e0c..35bb2d4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -829,7 +829,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
-		printk(KERN_INFO "btrfs: open %s failed\n", path);
 		goto error;
 	}
 
-- 
1.8.1.4

