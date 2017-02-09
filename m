Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752098AbdBIPsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Feb 2017 10:48:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ADCACADA7
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Feb 2017 15:48:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove unused ulist members
Date: Thu,  9 Feb 2017 16:47:43 +0100
Message-Id: <20170209154743.11186-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit "btrfs: ulist: Add ulist_del() function" (d4b804045924d7f8)
removed some debugging code but left the structure defintions.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ulist.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index a01a2c45825f..007b22fff3f9 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -19,9 +19,6 @@
  *
  */
 struct ulist_iterator {
-#ifdef CONFIG_BTRFS_DEBUG
-	int i;
-#endif
 	struct list_head *cur_list;  /* hint to start search */
 };
 
@@ -32,10 +29,6 @@ struct ulist_node {
 	u64 val;		/* value to store */
 	u64 aux;		/* auxiliary value saved along with the val */
 
-#ifdef CONFIG_BTRFS_DEBUG
-	int seqnum;		/* sequence number this node is added */
-#endif
-
 	struct list_head list;  /* used to link node */
 	struct rb_node rb_node;	/* used to speed up search */
 };
-- 
2.10.1

