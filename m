Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752708AbeB0PhW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 10:37:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC7E5AC69
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 15:37:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Remove redundant comment from btrfs_search_forward
Date: Tue, 27 Feb 2018 17:37:16 +0200
Message-Id: <1519745838-25584-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always sets keep_locks to 1 and saves the old value of
keep_locks which is restored at the end. So there is no way it can be
called without keep_locks being set. Remove comment imposing redundant
requirement on callers.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b88a79e69ddf..a80fcd285b34 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5145,9 +5145,6 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
  * into min_key, so you can call btrfs_search_slot with cow=1 on the
  * key and get a writable path.
  *
- * This does lock as it descends, and path->keep_locks should be set
- * to 1 by the caller.
- *
  * This honors path->lowest_level to prevent descent past a given level
  * of the tree.
  *
-- 
2.7.4

