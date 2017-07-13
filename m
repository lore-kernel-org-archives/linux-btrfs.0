Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44119 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751145AbdGMLLO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 07:11:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA223AC03
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 11:11:12 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove never reached error handling code in __add_reloc_root
Date: Thu, 13 Jul 2017 14:11:07 +0300
Message-Id: <1499944267-31130-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170712145000.GD2866@twin.jikos.cz>
References: <20170712145000.GD2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of the error handling paths in __add_reloc_root contains btrfs_panic()
followed by some other code. As the name implies what it does is print
some error message and call BUG, naturally what follow afterwards is not
invoked. So remove this extra code.

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

