From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 5/7] btrfs: Don't BUG_ON alloc_path errors in btrfs_balance()
Date: Thu, 14 Jul 2011 15:15:00 -0700
Message-ID: <1310681702-13922-6-git-send-email-mfasheh@suse.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com>
 <1310681702-13922-2-git-send-email-mfasheh@suse.com>
 <1310681702-13922-3-git-send-email-mfasheh@suse.com>
 <1310681702-13922-4-git-send-email-mfasheh@suse.com>
 <1310681702-13922-5-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-5-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dealing with this seems trivial - the only caller of btrfs_balance() is
btrfs_ioctl() which passes the error code directly back to userspace. There
also isn't much state to unwind (if I'm wrong about this point, we can
always safely move the allocation to the top of btrfs_balance() anyway).

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..530a2fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2061,8 +2061,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
 
 	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
+	if (!path) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
-- 
1.7.5.3

