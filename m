Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbdLMLuL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 06:50:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5DE5AAEF
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 11:50:10 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix bio leak
Date: Wed, 13 Dec 2017 13:50:07 +0200
Message-Id: <1513165807-12261-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit e0ae99941423 ("btrfs: preallocate device flush bio") reworked
the way the flush bio is allocated and used. Concretely it allocates
the bio in __alloc_device and then re-uses it multiple times with a
very simple endio routine that just calls complete() without consuming
a reference. Allocated bios by default come with a ref count of 1,
which is then consumed by the endio routine (or not, in which case they
should be bio_put by the caller). The way the impleementation works now
is that the flush bio has a refcount of 2 and we only ever bio_put it
once, leaving it to hang indefinitely. Fix this by removing the extra
bio_get in __alloc_device.

Fixes: e0ae99941423 ("btrfs: preallocate device flush bio")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 132966950f5f..3690822d469a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -312,7 +312,6 @@ static struct btrfs_device *__alloc_device(void)
 		kfree(dev);
 		return ERR_PTR(-ENOMEM);
 	}
-	bio_get(dev->flush_bio);
 
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_alloc_list);
-- 
2.7.4

