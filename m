Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35178 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFELYX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 07:24:23 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so906192wgh.8
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 04:24:22 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/3] Btrfs: make sure we retry if we couldn't get the page
Date: Thu,  5 Jun 2014 13:22:24 +0100
Message-Id: <1401970946-25269-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In inode.c:btrfs_page_exists_in_range(), if we can't get the page
we need to retry. However we weren't retrying because we weren't
setting page to NULL, which makes the while loop exit immediately
and will make us call page_cache_release after exiting the loop
which is incorrect because our page get didn't succeed. This could
also make us return true when we shouldn't.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 38d1e7b..cdbd20e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6777,8 +6777,10 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 			break; /* TODO: Is this relevant for this use case? */
 		}
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(page)) {
+			page = NULL;
 			continue;
+		}
 
 		/*
 		 * Has the page moved?
-- 
1.9.1

