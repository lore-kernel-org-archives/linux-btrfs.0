Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36327 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFELY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 07:24:29 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3251361wib.13
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 04:24:28 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/3] Btrfs: don't release invalid page in btrfs_page_exists_in_range()
Date: Thu,  5 Jun 2014 13:22:26 +0100
Message-Id: <1401970946-25269-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401970946-25269-1-git-send-email-fdmanana@gmail.com>
References: <1401970946-25269-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In inode.c:btrfs_page_exists_in_range(), if the page we got from
the radix tree is an exception entry, which can't be retried, we
exit the loop with a non-NULL page and then call page_cache_release
against it, which is not ok since it's not a valid page. This could
also make us return true when we shouldn't.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f265f41..477e64a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6776,6 +6776,7 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 			 * here as an exceptional entry: so return it without
 			 * attempting to raise page count.
 			 */
+			page = NULL;
 			break; /* TODO: Is this relevant for this use case? */
 		}
 
-- 
1.9.1

