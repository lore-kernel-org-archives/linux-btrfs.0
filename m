Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbeDEHkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 03:40:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 56A05AB3A
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 07:40:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix possible softlock on single core machines
Date: Thu,  5 Apr 2018 10:40:15 +0300
Message-Id: <1522914015-32534-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

do_chunk_alloc implements a loop checking whether there is a pending
chunk allocation and if so causes the caller do loop. Generally this
loop is executed only once, however testing with btrfs/072 on a
single core vm machines uncovered an extreme case where the system
could loop indefinitely. This is due to a missing cond_resched when
loop which doesn't give a chance to the previous chunk allocator finish
its job.

The fix is to simply add the missing cond_resched.

Fixes: 6d74119f1a3e ("Btrfs: avoid taking the chunk_mutex in do_chunk_alloc")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0cf1d4c518e9..070227b78d4e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4645,6 +4645,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	if (wait_for_alloc) {
 		mutex_unlock(&fs_info->chunk_mutex);
 		wait_for_alloc = 0;
+		cond_resched();
 		goto again;
 	}
 
-- 
2.7.4

