Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbcEEQgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:36:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4E5DEAD89
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:36:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: preallocate compression workspaces
Date: Thu,  5 May 2016 18:36:17 +0200
Message-Id: <3853368b95f27d9bdaf9e15bc1e11753f11e3c43.1462460924.git.dsterba@suse.com>
In-Reply-To: <cover.1462460924.git.dsterba@suse.com>
References: <cover.1462460924.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preallocate one workspace for each compression type so we can guarantee
forward progress in the worst case. A failure cannot be a hard error as
we might not use compression at all on the filesystem. If we can't
allocate the workspaces later when need them, it might actually
deadlock, but in such situation the system has effectively not enough
memory to operate properly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4d5cd9624bb3..38c058bcf359 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -761,10 +761,26 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+		struct list_head *workspace;
+
 		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
 		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
 		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
 		init_waitqueue_head(&btrfs_comp_ws[i].ws_wait);
+
+		/*
+		 * Preallocate one workspace for each compression type so
+		 * we can guarantee forward progress in the worst case
+		 */
+		workspace = btrfs_compress_op[i]->alloc_workspace();
+		if (IS_ERR(workspace)) {
+			printk(KERN_WARNING
+	"BTRFS: cannot preallocate compression workspace, will try later");
+		} else {
+			atomic_set(&btrfs_comp_ws[i].total_ws, 1);
+			btrfs_comp_ws[i].free_ws = 1;
+			list_add(workspace, &btrfs_comp_ws[i].idle_ws);
+		}
 	}
 }
 
-- 
2.7.1

