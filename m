From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 4/7] btrfs: Don't BUG_ON alloc_path errors in btrfs_read_locked_inode
Date: Thu, 21 Jul 2011 12:48:30 -0700
Message-ID: <1311277713-7747-5-git-send-email-mfasheh@suse.com>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com>
 <1311277713-7747-2-git-send-email-mfasheh@suse.com>
 <1311277713-7747-3-git-send-email-mfasheh@suse.com>
 <1311277713-7747-4-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311277713-7747-4-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_iget() also needed an update so that errors from btrfs_locked_inode()
are caught and bubbled back up.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0faf7d..8882999 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2518,7 +2518,9 @@ static void btrfs_read_locked_inode(struct inode *inode)
 		filled = true;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		goto make_bad;
+
 	path->leave_spinning = 1;
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
@@ -3973,6 +3975,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *new)
 {
 	struct inode *inode;
+	int bad_inode = 0;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
@@ -3982,10 +3985,19 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 		BTRFS_I(inode)->root = root;
 		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
 		btrfs_read_locked_inode(inode);
-		inode_tree_add(inode);
-		unlock_new_inode(inode);
-		if (new)
-			*new = 1;
+		if (!is_bad_inode(inode)) {
+			inode_tree_add(inode);
+			unlock_new_inode(inode);
+			if (new)
+				*new = 1;
+		} else {
+			bad_inode = 1;
+		}
+	}
+
+	if (bad_inode) {
+		iput(inode);
+		inode = ERR_PTR(-ESTALE);
 	}
 
 	return inode;
-- 
1.7.5.3

