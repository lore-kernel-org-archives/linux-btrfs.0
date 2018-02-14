Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967711AbeBNMh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 07:37:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3459BABE9
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 12:37:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Relax memory barrier in btrfs_tree_unlock
Date: Wed, 14 Feb 2018 14:37:26 +0200
Message-Id: <1518611846-26918-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When performing an unlock on an extent buffer we'd like to order the
decrement of extent_buffer::blocking_writers with waking up any
waiters. In such situations it's sufficient to use smp_mb__after_atomic
rather than the heavy smp_mb. On architectures where atomic operations
are fully ordered (such as x86 or s390) unconditionally executing
a heavyweight smp_mb instruction causes a severe hit to performance
while bringin no improvements in terms of correctness.

The better thing is to use the appropriate smp_mb__after_atomic routine
which will do the correct thing (invoke a full smp_mb or in the case
of ordered atomics insert a compiler barrier). Put another way,
an RMW atomic op + smp_load__after_atomic equals, in terms of
semantics, to a full smp_mb. This ensures that none of the problems
described in the accompanying comment of waitqueue_active occur.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/locking.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index d13128c70ddd..621083f8932c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -290,7 +290,7 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 		/*
 		 * Make sure counter is updated before we wake up waiters.
 		 */
-		smp_mb();
+		smp_mb__after_atomic();
 		if (waitqueue_active(&eb->write_lock_wq))
 			wake_up(&eb->write_lock_wq);
 	} else {
-- 
2.7.4

