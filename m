Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752140AbeDKIV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:21:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A2EAAF8E
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:21:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Rewrite retry logic in do_chunk_alloc
Date: Wed, 11 Apr 2018 11:21:20 +0300
Message-Id: <1523434880-7799-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1523434880-7799-1-git-send-email-nborisov@suse.com>
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

do_chunk_alloc implements logic to detect whether there is currently
pending chunk allocation  (by means of space_info->chunk_alloc being
set) and if so it loops around to the 'again' label. Additionally,
based on the state of the space_info (e.g. whether it's full or not)
and the return value of should_alloc_chunk() it decides whether this
is a "hard" error (ENOSPC) or we can just return 0.

This patch refactors all of this:

1. Put order to the scattered ifs handling the various cases in an
easy-to-read if {} else if{} branches. This makes clear the various
cases we are interested in handling.

2. Call should_alloc_chunk only once and use the result in the
if/else if constructs. All of this is done under space_info->lock, so
even before multiple calls of should_alloc_chunk were unnecessary.

3. Rewrite the "do {} while()" loop currently implemented via label
into an explicit loop construct.

4. Move the mutex locking outside of the while loop and remove the
comment. The comment in fact was misleading since in the old code if the
mutex is acquired and we don't need to loop again (wait_for_alloc) is
0 then we don't recheck if we need to allocate (the comment was stating
the opposite).

5. Switch local vars to bool type where pertinent.

All in all this shouldn't introduce any functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 65 ++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index facc5248d500..9a05e5b5089f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4601,7 +4601,8 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info, u64 flags, int force)
 {
 	struct btrfs_space_info *space_info;
-	int wait_for_alloc = 0;
+	bool wait_for_alloc = false;
+	bool should_alloc = false;
 	int ret = 0;
 
 	/* Don't re-enter if we're already allocating a chunk */
@@ -4611,45 +4612,35 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	space_info = __find_space_info(fs_info, flags);
 	ASSERT(space_info);
 
-again:
-	spin_lock(&space_info->lock);
-	if (force < space_info->force_alloc)
-		force = space_info->force_alloc;
-	if (space_info->full) {
-		if (should_alloc_chunk(fs_info, space_info, force))
-			ret = -ENOSPC;
-		else
-			ret = 0;
-		spin_unlock(&space_info->lock);
-		return ret;
-	}
-
-	if (!should_alloc_chunk(fs_info, space_info, force)) {
+	do {
+		spin_lock(&space_info->lock);
+		if (force < space_info->force_alloc)
+			force = space_info->force_alloc;
+		should_alloc = should_alloc_chunk(fs_info, space_info, force);
+		if (space_info->full) {
+			/* No more free physical space */
+			if (should_alloc)
+				ret = -ENOSPC;
+			else
+				ret = 0;
+			spin_unlock(&space_info->lock);
+			return ret;
+		} else if (!should_alloc) {
+			spin_unlock(&space_info->lock);
+			return 0;
+		} else if (space_info->chunk_alloc) {
+			/* Someone is already allocating, we need to loop */
+			wait_for_alloc = true;
+		} else {
+			/* Proceed with allocation */
+			space_info->chunk_alloc = 1;
+			wait_for_alloc = false;
+		}
 		spin_unlock(&space_info->lock);
-		return 0;
-	} else if (space_info->chunk_alloc) {
-		wait_for_alloc = 1;
-	} else {
-		space_info->chunk_alloc = 1;
-	}
-
-	spin_unlock(&space_info->lock);
-
-	mutex_lock(&fs_info->chunk_mutex);
-
-	/*
-	 * The chunk_mutex is held throughout the entirety of a chunk
-	 * allocation, so once we've acquired the chunk_mutex we know that the
-	 * other guy is done and we need to recheck and see if we should
-	 * allocate.
-	 */
-	if (wait_for_alloc) {
-		mutex_unlock(&fs_info->chunk_mutex);
-		wait_for_alloc = 0;
 		cond_resched();
-		goto again;
-	}
+	} while (wait_for_alloc);
 
+	mutex_lock(&fs_info->chunk_mutex);
 	trans->allocating_chunk = true;
 
 	/*
-- 
2.7.4

