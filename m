Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48184 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJFUOw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 6 Oct 2014 16:14:52 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 4/5] Btrfs: process all async extents on compressed write failure
Date: Mon,  6 Oct 2014 22:14:25 +0100
Message-Id: <1412630066-21746-5-git-send-email-fdmanana@suse.com>
In-Reply-To: <1412630066-21746-1-git-send-email-fdmanana@suse.com>
References: <1412630066-21746-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we had an error when processing one of the async extents from our list,
we were not processing the remaining async extents, meaning we would leak
those async_extent structs, never release the pages with the compressed
data and never unlock and clear the dirty flag from the inode's pages (those
that correspond to the uncompressed content).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a3e2330..8636499 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -839,13 +839,9 @@ retry:
 		}
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
-		if (ret)
-			goto out;
 		cond_resched();
 	}
-	ret = 0;
-out:
-	return ret;
+	return 0;
 out_free_reserve:
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 out_free:
-- 
1.9.1

