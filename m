From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 15/20] btrfs: Go readonly on missing ref in btrfs_get_parent()
Date: Thu, 15 Sep 2011 10:34:54 -0700
Message-ID: <1316108099-5099-16-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

btrfs_get_parent() searches the btree for a ref to the current object. From
there it can compute the parent objectid from which it can return a dentry.
if the reference is not found in the tree however, we BUG(). I believe a
more appropriate response would be to go read-only as this seems like a
corruption.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/export.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1b8dc33..a335169 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -193,7 +193,13 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	if (ret < 0)
 		goto fail;
 
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/* Missing ref, should go readonly. */
+		ret = -ENOENT;
+		btrfs_std_error(root->fs_info, ret);
+		goto fail;
+	}
+
 	if (path->slots[0] == 0) {
 		ret = -ENOENT;
 		goto fail;
-- 
1.7.6

