Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39417 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966073AbcIVTLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 15:11:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 005F3ABCA
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 19:11:54 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] Do not reassign count in btrfs_run_delayed_refs
Date: Thu, 22 Sep 2016 14:11:47 -0500
Message-Id: <1474571507-5375-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Code cleanup. count is already (unsgined long)-1. That is the reason
run_all was set. Do not reassign it (unsigned long)-1.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/extent-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 38c2df8..23b3b9f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2971,7 +2971,6 @@ again:
 			spin_unlock(&delayed_refs->lock);
 			goto out;
 		}
-		count = (unsigned long)-1;
 
 		while (node) {
 			head = rb_entry(node, struct btrfs_delayed_ref_head,
-- 
2.6.6

