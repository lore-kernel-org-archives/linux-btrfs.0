Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42318 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3JAPLa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 11:11:30 -0400
Received: by mail-wi0-f177.google.com with SMTP id cb5so5747908wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 08:11:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove unnecessary tree search when logging inode
Date: Tue,  1 Oct 2013 16:09:23 +0100
Message-Id: <1380640163-12098-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In tree-log.c:btrfs_log_inode(), we keep calling btrfs_search_forward()
until it returns a key whose objectid is higher than our inode or until
the key's type is higher than our maximum allowed type.

At the end of the loop, we increment our mininum search key's objectid
and type regardless of our desired target objectid and maximum desired
type, which causes another loop iteration that will call again
btrfs_search_forward() just to figure out we've gone beyond our maximum
key and exit the loop. Therefore while incrementing our minimum key,
don't do it blindly and exit the loop immiediately if the next search
key's objectid or type is beyond what we seek.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..cbc8156 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3771,10 +3771,8 @@ next_slot:
 
 		if (min_key.offset < (u64)-1)
 			min_key.offset++;
-		else if (min_key.type < (u8)-1)
+		else if (min_key.type < max_key.type)
 			min_key.type++;
-		else if (min_key.objectid < (u64)-1)
-			min_key.objectid++;
 		else
 			break;
 	}
-- 
1.7.9.5

