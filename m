Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaJBQuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9ADE1AB1D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:19 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 08/14] btrfs: remove unused members from struct scrub_warning
Date: Thu,  2 Oct 2014 18:50:19 +0200
Message-Id: <8b9456da037ab53428d6347fa2fa088933da1424.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/scrub.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b9c37ac9ed1b..efa083113827 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -177,17 +177,12 @@ struct scrub_copy_nocow_ctx {
 struct scrub_warning {
 	struct btrfs_path	*path;
 	u64			extent_item_size;
-	char			*scratch_buf;
-	char			*msg_buf;
 	const char		*errstr;
 	sector_t		sector;
 	u64			logical;
 	struct btrfs_device	*dev;
-	int			msg_bufsize;
-	int			scratch_bufsize;
 };
 
-
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx);
 static void scrub_pending_bio_dec(struct scrub_ctx *sctx);
 static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx);
@@ -551,7 +546,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	u64 ref_root;
 	u32 item_size;
 	u8 ref_level;
-	const int bufsize = 4096;
 	int ret;
 
 	WARN_ON(sblock->page_count < 1);
@@ -559,18 +553,13 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	fs_info = sblock->sctx->dev_root->fs_info;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return;
 
-	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
-	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
 	swarn.sector = (sblock->pagev[0]->physical) >> 9;
 	swarn.logical = sblock->pagev[0]->logical;
 	swarn.errstr = errstr;
 	swarn.dev = NULL;
-	swarn.msg_bufsize = bufsize;
-	swarn.scratch_bufsize = bufsize;
-
-	if (!path || !swarn.scratch_buf || !swarn.msg_buf)
-		goto out;
 
 	ret = extent_from_logical(fs_info, swarn.logical, path, &found_key,
 				  &flags);
@@ -611,8 +600,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 
 out:
 	btrfs_free_path(path);
-	kfree(swarn.scratch_buf);
-	kfree(swarn.msg_buf);
 }
 
 static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
-- 
1.8.4.5

