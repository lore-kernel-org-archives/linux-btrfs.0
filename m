Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49151 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751082AbdEaPmn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 11:42:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95205AC29
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 15:42:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: switch kmallocs to GFP_KERNEL in lzo/zlib alloc_workspace
Date: Wed, 31 May 2017 17:41:35 +0200
Message-Id: <b00f101454e17051d005f9fb28224b665c339cf1.1496245064.git.dsterba@suse.com>
In-Reply-To: <cover.1496245064.git.dsterba@suse.com>
References: <cover.1496245064.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As alloc_workspace is now protected by memalloc_nofs where needed,
we can switch the kmalloc to use GFP_KERNEL.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/lzo.c  | 2 +-
 fs/btrfs/zlib.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index a554856a5f8a..c556f3f3fbf0 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -51,7 +51,7 @@ static struct list_head *lzo_alloc_workspace(void)
 {
 	struct workspace *workspace;
 
-	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
+	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index d5446e18bb59..c1db7572283b 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -53,14 +53,14 @@ static struct list_head *zlib_alloc_workspace(void)
 	struct workspace *workspace;
 	int workspacesize;
 
-	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
+	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
 	workspace->strm.workspace = vmalloc(workspacesize);
-	workspace->buf = kmalloc(PAGE_SIZE, GFP_NOFS);
+	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!workspace->strm.workspace || !workspace->buf)
 		goto fail;
 
-- 
2.12.0

