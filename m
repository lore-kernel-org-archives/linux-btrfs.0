Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752034AbeCOMgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DD156AD3C
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:35 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/8] btrfs: Remove unused length var from scrub_handle_errored_block
Date: Thu, 15 Mar 2018 14:36:23 +0200
Message-Id: <1521117389-13712-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added in b5d67f64f9bc ("Btrfs: change scrub to support big blocks") but
rendered redundant by be50a8ddaae1 ("Btrfs: Simplify
scrub_setup_recheck_block()'s argument")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/scrub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 629313732521..4ab4a68dbc06 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1111,7 +1111,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	struct scrub_ctx *sctx = sblock_to_check->sctx;
 	struct btrfs_device *dev;
 	struct btrfs_fs_info *fs_info;
-	u64 length;
 	u64 logical;
 	unsigned int failed_mirror_index;
 	unsigned int is_metadata;
@@ -1139,7 +1138,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		spin_unlock(&sctx->stat_lock);
 		return 0;
 	}
-	length = sblock_to_check->page_count * PAGE_SIZE;
 	logical = sblock_to_check->pagev[0]->logical;
 	BUG_ON(sblock_to_check->pagev[0]->mirror_num < 1);
 	failed_mirror_index = sblock_to_check->pagev[0]->mirror_num - 1;
-- 
2.7.4

