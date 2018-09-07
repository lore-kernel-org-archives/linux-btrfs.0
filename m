Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:50 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB49DACBB
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/11] btrfs: dev-replace: remove pointless assert in write unlock
Date: Fri,  7 Sep 2018 16:55:15 +0200
Message-Id: <3fb761b6e09ab5a5d5d23ab146c0981b5519b2ec.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of blocking_readers is increased only when the lock is taken
for read, no way we can fail the condition with the write lock.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c0e9b2c229d5..ba1cbedaa422 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -977,7 +977,6 @@ void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
 
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	ASSERT(atomic_read(&dev_replace->blocking_readers) == 0);
 	write_unlock(&dev_replace->lock);
 }
 
-- 
2.18.0
