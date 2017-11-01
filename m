Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50493 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753908AbdKAJcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 05:32:22 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D4BA7AAB2
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Nov 2017 09:32:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Move loop termination condition in while()
Date: Wed,  1 Nov 2017 11:32:18 +0200
Message-Id: <1509528738-4387-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fallocating a file in btrfs goes through several stages. The one before actually
inserting the fallocated extents is to create a qgroup reservation, covering
the desired range. To this end there is a loop in btrfs_fallocate which checks
to see if there are holes in the fallocated range or !PREALLOC extents past EOF
and if so create qgroup reservations for them. Unfortunately, the main condition
of the loop is burried right at the end of its body rather than in the actual
while statement which makes it non-obvious. Fix this by moving the condition
in the while statement where it belongs. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e0d15c0d1641..ecbe186cb5da 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3168,7 +3168,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 
 	/* First, check if we exceed the qgroup limit */
 	INIT_LIST_HEAD(&reserve_list);
-	while (1) {
+	while (cur_offset < alloc_end) {
 		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
 		if (IS_ERR(em)) {
@@ -3204,8 +3204,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 		}
 		free_extent_map(em);
 		cur_offset = last_byte;
-		if (cur_offset >= alloc_end)
-			break;
 	}
 
 	/*
-- 
2.7.4

