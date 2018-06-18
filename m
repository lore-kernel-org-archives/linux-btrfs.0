Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933134AbeFRL7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:59:33 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E3ACAE64
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 11:59:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Fix comment in lookup_inline_extent_backref
Date: Mon, 18 Jun 2018 14:59:26 +0300
Message-Id: <1529323166-29931-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1529323166-29931-1-git-send-email-nborisov@suse.com>
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The comment wrongfully states that the owner parameter is the level of
the parent block. In fact owner is the level of the current block and
by adding 1 to it we can eventually get to the parent/root.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 39d0652bf3f3..a470a07d4f2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1635,7 +1635,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		extra_size = -1;
 
 	/*
-	 * Owner is our parent level, so we can just add one to get the level
+	 * Owner is our level, so we can just add one to get the level
 	 * for the block we are interested in.
 	 */
 	if (skinny_metadata && owner < BTRFS_FIRST_FREE_OBJECTID) {
-- 
2.7.4

