Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42006 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3BLQ3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 11:29:05 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so157444eek.16
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 08:29:03 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH] Btrfs: allow for selecting only completely empty chunks
Date: Tue, 12 Feb 2013 18:28:59 +0200
Message-Id: <1360686539-22720-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance balance usage filter by making it possible to balance out only
completely empty chunks.  Today, usage filter properly acts on values
from 1 to 99 inclusive, usage=100 selects all chunks, and usage=0
selects no chunks.  This commit changes the usage=0 case: the new
meaning is to restripe only completely empty chunks and nothing else.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15f6efd..7e41619 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2615,7 +2615,7 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	chunk_used = btrfs_block_group_used(&cache->item);
 
 	if (bargs->usage == 0)
-		user_thresh = 0;
+		user_thresh = 1;
 	else if (bargs->usage > 100)
 		user_thresh = cache->key.offset;
 	else
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
