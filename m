Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750731AbdGLGOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 02:14:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3070ACA4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 06:14:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove never reached code
Date: Wed, 12 Jul 2017 09:13:58 +0300
Message-Id: <1499840038-16089-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/relocation.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65661d1aae4e..1a532bb72eab 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1308,8 +1308,6 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 		btrfs_panic(fs_info, -EEXIST,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
-		kfree(node);
-		return -EEXIST;
 	}
 
 	list_add_tail(&root->root_list, &rc->reloc_roots);
-- 
2.7.4

