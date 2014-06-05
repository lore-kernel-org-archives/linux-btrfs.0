Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57141 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFELY1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 07:24:27 -0400
Received: by mail-we0-f180.google.com with SMTP id q58so927726wes.11
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 04:24:25 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/3] Btrfs: make sure we retry if page is a retriable exception
Date: Thu,  5 Jun 2014 13:22:25 +0100
Message-Id: <1401970946-25269-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401970946-25269-1-git-send-email-fdmanana@gmail.com>
References: <1401970946-25269-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In inode.c:btrfs_page_exists_in_range(), if the page we get from the
radix tree is an exception which should make us retry, set page to
NULL in order to really retry, because otherwise we don't get another
loop iteration executed (page != NULL makes the while loop exit).
This also was making us call page_cache_release after exiting the loop,
which isn't correct because page doesn't point to a valid page, and
possibly return true from the function when we shouldn't.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cdbd20e..f265f41 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6767,8 +6767,10 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 			break;
 
 		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
+			if (radix_tree_deref_retry(page)) {
+				page = NULL;
 				continue;
+			}
 			/*
 			 * Otherwise, shmem/tmpfs must be storing a swap entry
 			 * here as an exceptional entry: so return it without
-- 
1.9.1

