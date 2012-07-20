Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:50960 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab2GTUQH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 16:16:07 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id dgZwQp2RAP1ICwuE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 14:16:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix potential race in extent buffer freeing
Date: Fri, 20 Jul 2012 16:21:04 -0400
Message-ID: <1342815664-9594-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This sounds sort of impossible but it is the only thing I can think of and
at the very least it is theoretically possible so here it goes.

If we are in try_release_extent_buffer we will check that the ref count on
the extent buffer is 1 and not under IO, and then go down and clear the tree
ref.  If between this check and clearing the tree ref somebody else comes in
and grabs a ref on the eb and the marks it dirty before
try_release_extent_buffer() does it's tree ref clear we can end up with a
dirty eb that will be freed while it is still dirty which will result in a
panic.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b778fc2..20440ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4142,11 +4142,10 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 	 * So bump the ref count first, then set the bit.  If someone
 	 * beat us to it, drop the ref we added.
 	 */
-	if (!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
+	spin_lock(&eb->refs_lock);
+	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
 		atomic_inc(&eb->refs);
-		if (test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-			atomic_dec(&eb->refs);
-	}
+	spin_unlock(&eb->refs_lock);
 }
 
 static void mark_extent_buffer_accessed(struct extent_buffer *eb)
@@ -4258,9 +4257,7 @@ again:
 		goto free_eb;
 	}
 	/* add one reference for the tree */
-	spin_lock(&eb->refs_lock);
 	check_buffer_tree_ref(eb);
-	spin_unlock(&eb->refs_lock);
 	spin_unlock(&tree->buffer_lock);
 	radix_tree_preload_end();
 
-- 
1.7.7.6

