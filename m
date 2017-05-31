Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39481 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750999AbdEaRu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 13:50:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 408C3AAB6
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:50:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/5] btrfs: scrub: add memalloc_nofs protection around init_ipath
Date: Wed, 31 May 2017 19:49:27 +0200
Message-Id: <6174e7ce0e55e54a1a4c3a6be413885495926728.1496252765.git.dsterba@suse.com>
In-Reply-To: <cover.1496252765.git.dsterba@suse.com>
References: <cover.1496252765.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

init_ipath is called from a safe ioctl context and from scrub when
printing an error.  The protection is added for three reasons:

* init_data_container calls vmalloc and this does not work as expected
  in the GFP_NOFS context, so this silently does GFP_KERNEL and might
  deadlock in some cases
* keep the context constraint of GFP_NOFS, used by scrub
* we want to use GFP_KERNEL unconditionally inside init_ipath or its
  callees

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e99be644b19f..096e503e3ddc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -18,6 +18,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "disk-io.h"
@@ -733,6 +734,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	u32 nlink;
 	int ret;
 	int i;
+	unsigned nofs_flag;
 	struct extent_buffer *eb;
 	struct btrfs_inode_item *inode_item;
 	struct scrub_warning *swarn = warn_ctx;
@@ -771,7 +773,14 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	nlink = btrfs_inode_nlink(eb, inode_item);
 	btrfs_release_path(swarn->path);
 
+	/*
+	 * init_path might indirectly call vmalloc, or use GFP_KERNEL. Scrub
+	 * uses GFP_NOFS in this context, so we keep it consistent but it does
+	 * not seem to be strictly necessary.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	ipath = init_ipath(4096, local_root, swarn->path);
+	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(ipath)) {
 		ret = PTR_ERR(ipath);
 		ipath = NULL;
-- 
2.12.0

