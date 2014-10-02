Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaJBQuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 17E6AAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:24 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 09/14] btrfs: let merge_reloc_roots return void
Date: Thu,  2 Oct 2014 18:50:23 +0200
Message-Id: <94404e82e5f5452a13ef580b6d3df1483671dff9.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2d221c46180c..f39abe690bb2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2316,7 +2316,7 @@ void free_reloc_roots(struct list_head *list)
 }
 
 static noinline_for_stack
-int merge_reloc_roots(struct reloc_control *rc)
+void merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
@@ -2397,7 +2397,6 @@ out:
 	}
 
 	BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
-	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
-- 
1.8.4.5

