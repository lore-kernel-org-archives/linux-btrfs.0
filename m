From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 11/20] btrfs: Go readonly on bad extent refs in update_ref_for_cow()
Date: Thu, 15 Sep 2011 10:34:50 -0700
Message-ID: <1316108099-5099-12-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

update_ref_for_cow() will BUG_ON() after it's call to
btrfs_lookup_extent_info() if no existing references are found.  Since refs
are computed directly from disk, this should be treated as a corruption
instead of a logic error.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5064930..8d8182f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -333,7 +333,11 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 					       buf->len, &refs, &flags);
 		if (ret)
 			return ret;
-		BUG_ON(refs == 0);
+		if (refs == 0) {
+			ret = -EROFS;
+			btrfs_std_error(root->fs_info, ret);
+			return ret;
+		}
 	} else {
 		refs = 1;
 		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
-- 
1.7.6

