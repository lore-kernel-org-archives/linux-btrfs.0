Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752030AbeGACpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 22:45:31 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA27DAE9A
        for <linux-btrfs@vger.kernel.org>; Sun,  1 Jul 2018 02:45:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: free-space-cache: Don't panic when free space cache is corrupted
Date: Sun,  1 Jul 2018 10:45:26 +0800
Message-Id: <20180701024526.25740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_add_free_space(), if the free space to be added is already
here, we trigger ASSERT() which is just another BUG_ON().

Let's remove such BUG_ON() at all.

Reported-by: Lewis Diamond <me@lewisdiamond.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 free-space-cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 9b83a71ca59a..2ef2d307cc5d 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -838,10 +838,8 @@ int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
 	try_merge_free_space(ctl, info);
 
 	ret = link_free_space(ctl, info);
-	if (ret) {
+	if (ret)
 		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
-		BUG_ON(ret == -EEXIST);
-	}
 
 	return ret;
 }
-- 
2.18.0

