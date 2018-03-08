Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755565AbeCHOgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:08 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6338DAE22
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:07 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 18/22] btrfs: move allocation after simple tests in tree_mod_log_insert_key
Date: Thu,  8 Mar 2018 15:33:47 +0100
Message-Id: <0792f4331c42c57426d02f897bc68b7c7820219a.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The allocation of tree_mod_elem can be delayed after tree_mod_dont_log.
In case it causes the function to return, the allocation would be
redundant. Otherwise it could cause unnecessary failure if there's not
enough memory.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 30950439731e..da6e2c3ca2d0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -521,15 +521,13 @@ static noinline int tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
 	if (!tree_mod_need_log(eb->fs_info, eb))
 		return 0;
 
+	if (tree_mod_dont_log(eb->fs_info, eb))
+		return 0;
+
 	tm = alloc_tree_mod_elem(eb, slot, op, flags);
 	if (!tm)
 		return -ENOMEM;
 
-	if (tree_mod_dont_log(eb->fs_info, eb)) {
-		kfree(tm);
-		return 0;
-	}
-
 	ret = __tree_mod_log_insert(eb->fs_info, tm);
 	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	if (ret)
-- 
2.16.2

