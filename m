Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaBCSYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:24:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D4E87AAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:24:21 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] btrfs: send: remove BUG from process_all_refs
Date: Mon,  3 Feb 2014 19:24:19 +0100
Message-Id: <8e818f06cc42796533133bd65194a863291ea744.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are only 2 static callers, the BUG would normally be never
reached, but let's be nice.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4e3a3d413417..b0bf4ff40b5b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3568,7 +3568,10 @@ static int process_all_refs(struct send_ctx *sctx,
 		root = sctx->parent_root;
 		cb = __record_deleted_ref;
 	} else {
-		BUG();
+		btrfs_err(sctx->send_root->fs_info,
+				"Wrong command %d in process_all_refs", cmd);
+		ret = -EINVAL;
+		goto out;
 	}
 
 	key.objectid = sctx->cmp_key->objectid;
-- 
1.7.9

