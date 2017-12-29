Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754628AbdL2JBs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 04:01:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 47A9BAAEF
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 09:01:47 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] bytrfs-progs: Print error on invalid extent item format during check
Date: Fri, 29 Dec 2017 11:01:44 +0200
Message-Id: <1514538104-20005-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While performing normal mode check if the code comes across an invalid
extent format it will just BUG() and exit without printing any useful
information for debugging. Improve the situation by outputting the
key/leaf bytenr/slot which will enable to quickly inspect the tree and
see what the corruption is.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-check.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c88a38..371516709ed8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8362,7 +8362,12 @@ static int process_extent_item(struct btrfs_root *root,
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		struct btrfs_extent_item_v0 *ei0;
-		BUG_ON(item_size != sizeof(*ei0));
+		if (item_size != sizeof(*ei0)) {
+			error("invalid extent item format: ITEM[%llu %u %llu] leaf: %llu slot: %d",
+			      key.objectid, key.type, key.offset,
+			      btrfs_header_bytenr(eb), slot);
+			BUG();
+		}
 		ei0 = btrfs_item_ptr(eb, slot, struct btrfs_extent_item_v0);
 		refs = btrfs_extent_refs_v0(eb, ei0);
 #else
-- 
2.7.4

