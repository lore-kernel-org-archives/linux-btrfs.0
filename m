Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52109 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaCaMxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 08:53:33 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so3098198wib.0
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 05:53:32 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: more efficient io tree navigation on wait_extent_bit
Date: Mon, 31 Mar 2014 14:53:25 +0100
Message-Id: <1396274005-16360-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we don't reschedule use rb_next to find the next extent state
instead of a full tree search, which is more efficient and safe
since we didn't release the io tree's lock.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_io.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fd78c84..50a3321 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -749,6 +749,7 @@ again:
 		 * our range starts
 		 */
 		node = tree_search(tree, start);
+process_node:
 		if (!node)
 			break;
 
@@ -769,7 +770,10 @@ again:
 		if (start > end)
 			break;
 
-		cond_resched_lock(&tree->lock);
+		if (!cond_resched_lock(&tree->lock)) {
+			node = rb_next(node);
+			goto process_node;
+		}
 	}
 out:
 	spin_unlock(&tree->lock);
-- 
1.7.10.4

