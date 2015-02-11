Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63474 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbBKJRT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 04:17:19 -0500
From: Bas Peters <baspeters93@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz
Cc: Bas Peters <baspeters93@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs: btrfs: free-space-cache.c: remove two unnecessary checks before calling kfree()
Date: Wed, 11 Feb 2015 10:17:13 +0100
Message-Id: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kfree checks whether the pointer it is passed is NULL. The two foregoing
checks are therefore unnecessary.

This issue was detected using Coccinelle.

Signed-off-by: Bas Peters <baspeters93@gmail.com>
---
 fs/btrfs/free-space-cache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c03f7..7d2d817 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1976,8 +1976,7 @@ new_bitmap:
 
 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -3427,8 +3426,7 @@ again:
 
 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
-	if (map)
-		kfree(map);
+	kfree(map);
 	return 0;
 }
 
-- 
2.1.0

