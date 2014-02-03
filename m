Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaBCSYl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:24:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CA5BEAAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:24:40 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] btrfs: send: remove BUG_ON from name_cache_delete
Date: Mon,  3 Feb 2014 19:24:40 +0100
Message-Id: <53d81c36c0cffde8dd11199986eebae576a0f6be.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If cleaning the name cache fails, we could try to proceed at the cost of
some memory leak. This is not expected to happen often.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b0bf4ff40b5b..7b17b778eaf7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1849,13 +1849,20 @@ static void name_cache_delete(struct send_ctx *sctx,
 
 	nce_head = radix_tree_lookup(&sctx->name_cache,
 			(unsigned long)nce->ino);
-	BUG_ON(!nce_head);
+	if (!nce_head) {
+		btrfs_err(sctx->send_root->fs_info,
+	      "name_cache_delete lookup failed ino %llu cache size %d, leaking memory",
+			nce->ino, sctx->name_cache_size);
+	}
 
 	list_del(&nce->radix_list);
 	list_del(&nce->list);
 	sctx->name_cache_size--;
 
-	if (list_empty(nce_head)) {
+	/*
+	 * We may not get to the final release of nce_head if the lookup fails
+	 */
+	if (nce_head && list_empty(nce_head)) {
 		radix_tree_delete(&sctx->name_cache, (unsigned long)nce->ino);
 		kfree(nce_head);
 	}
-- 
1.7.9

