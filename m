From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 23/35] btrfs: Go readonly on bad extent refs in update_ref_for_cow()
Date: Wed, 21 Mar 2012 21:11:27 -0400
Message-ID: <20120322011136.214275632@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

update_ref_for_cow() will BUG_ON() after it's call to
btrfs_lookup_extent_info() if no existing references are found.  Since refs
are computed directly from disk, this should be treated as a corruption
instead of a logic error.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e2e43c0..3b767d2 100644
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
1.7.9



