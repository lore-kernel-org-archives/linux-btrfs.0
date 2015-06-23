Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34201 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbFWF7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 01:59:34 -0400
From: Maninder Singh <maninder1.s@samsung.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] Btrfs: Remove redundant NULL check before kfree
Date: Tue, 23 Jun 2015 11:28:00 +0530
Message-id: <1435039080-2952-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need of NULL check before kfree,
removing the same

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
---
 fs/btrfs/free-space-cache.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 9dbe5b5..88f1e16 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2101,8 +2101,7 @@ new_bitmap:
 
 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -3561,8 +3560,7 @@ again:
 
 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
-	if (map)
-		kfree(map);
+	kfree(map);
 	return 0;
 }
 
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
