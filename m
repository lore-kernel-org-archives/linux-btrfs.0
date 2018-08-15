Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729464AbeHOSTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 72686AD6A
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/7] btrfs: Remove special handling of EXTENT_BUFFER_UNMAPPED while freeing
Date: Wed, 15 Aug 2018 18:26:57 +0300
Message-Id: <1534346817-9108-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that the whole of btrfs code has been audited for eb reference
count management it's time to remove the hunk in free_extent_buffer
that essentially considered the condition "eb->ref == 2 &&
EXTENT_BUFFER_DUMMY" to equal eb->ref = 1. Also remove the last
location which takes an extra reference count in
alloc_test_extent_buffer.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c         | 11 -----------
 fs/btrfs/tests/btrfs-tests.c |  6 +++++-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 628f1aef34b0..aed4119ffb99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4908,13 +4908,6 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	check_buffer_tree_ref(eb);
 	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
 
-	/*
-	 * We will free dummy extent buffer's if they come into
-	 * free_extent_buffer with a ref count of 2, but if we are using this we
-	 * want the buffers to stay in memory until we're done with them, so
-	 * bump the ref count again.
-	 */
-	atomic_inc(&eb->refs);
 	return eb;
 free_eb:
 	btrfs_release_extent_buffer(eb);
@@ -5105,10 +5098,6 @@ void free_extent_buffer(struct extent_buffer *eb)
 
 	spin_lock(&eb->refs_lock);
 	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags))
-		atomic_dec(&eb->refs);
-
-	if (atomic_read(&eb->refs) == 2 &&
 	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
 	    !extent_buffer_under_io(eb) &&
 	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index db72b3b6209e..4cb8fcfd3ec4 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -174,8 +174,12 @@ void btrfs_free_dummy_root(struct btrfs_root *root)
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))
 		return;
-	if (root->node)
+	if (root->node) {
+		/* One for allocate_extent_buffer */
 		free_extent_buffer(root->node);
+		/* One for get_exent_buffer */
+		free_extent_buffer(root->node);
+	}
 	kfree(root);
 }
 
-- 
2.7.4
