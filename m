Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:56043 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaF2Snq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 14:43:46 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so7392484wes.12
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 11:43:44 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>
Subject: [PATCH] Btrfs: fix use-after-free when cloning a trailing file hole
Date: Sun, 29 Jun 2014 20:43:24 +0100
Message-Id: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction handle was being used after being freed.

Cc: Chris Mason <clm@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02dc64b..2562dc7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3565,12 +3565,10 @@ process_slot:
 			btrfs_end_transaction(trans, root);
 			goto out;
 		}
-		ret = clone_finish_inode_update(trans, inode, destoff + len,
-						destoff, olen);
-		if (ret)
-			goto out;
 		clone_update_extent_map(inode, trans, path, NULL, last_dest_end,
 					destoff + len - last_dest_end);
+		ret = clone_finish_inode_update(trans, inode, destoff + len,
+						destoff, olen);
 	}
 
 out:
-- 
1.9.1

