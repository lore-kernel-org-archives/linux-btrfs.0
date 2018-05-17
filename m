Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbeEQLQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 07:16:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DD3B9AC94
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 11:16:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove stale comment about select_delayed_ref
Date: Thu, 17 May 2018 14:16:29 +0300
Message-Id: <1526555789-14161-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

select_delayed_ref really just gets the next delayed ref which has to
be processed - either an add ref or drop ref. We never go back for
anything. So the comment is actually bogus, just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 795dc533856f..cae33c531a3c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2705,10 +2705,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		spin_lock(&locked_ref->lock);
 		btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref);
 
-		/*
-		 * locked_ref is the head node, so we have to go one
-		 * node back for any delayed ref updates
-		 */
 		ref = select_delayed_ref(locked_ref);
 
 		if (ref && ref->seq &&
-- 
2.7.4

