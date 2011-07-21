From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Thu, 21 Jul 2011 12:48:33 -0700
Message-ID: <1311277713-7747-8-git-send-email-mfasheh@suse.com>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com>
 <1311277713-7747-2-git-send-email-mfasheh@suse.com>
 <1311277713-7747-3-git-send-email-mfasheh@suse.com>
 <1311277713-7747-4-git-send-email-mfasheh@suse.com>
 <1311277713-7747-5-git-send-email-mfasheh@suse.com>
 <1311277713-7747-6-git-send-email-mfasheh@suse.com>
 <1311277713-7747-7-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311277713-7747-7-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

In addition to properly handling allocation failure from btrfs_alloc_path, I
also fixed up the kzalloc error handling code immediately below it.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent-tree.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ff339b2..4cf5257 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6271,10 +6271,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BUG_ON(!wc);
+	if (!wc) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	trans = btrfs_start_transaction(tree_root, 0);
 	BUG_ON(IS_ERR(trans));
-- 
1.7.5.3

