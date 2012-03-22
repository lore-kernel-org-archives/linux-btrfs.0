From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 20/35] btrfs: Dont BUG_ON() errors in update_ref_for_cow()
Date: Wed, 21 Mar 2012 21:11:24 -0400
Message-ID: <20120322011135.806502244@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The only caller of update_ref_for_cow() is __btrfs_cow_block() which was
originally ignoring any return values. update_ref_for_cow() however doesn't
look like a candidate to become a void function - there are a few places
where errors can occur.

So instead I changed update_ref_for_cow() to bubble all errors up (instead
of BUG_ON). __btrfs_cow_block() was then updated to catch and BUG_ON() any
errors from update_ref_for_cow(). The end effect is that we have no change
in behavior, but about 8 different places where a BUG_ON(ret) was removed.

Obviously a future patch will have to address the BUG_ON() in
__btrfs_cow_block().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9d472c2..e2e43c0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -331,7 +331,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	if (btrfs_block_can_be_shared(root, buf)) {
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
 					       buf->len, &refs, &flags);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		BUG_ON(refs == 0);
 	} else {
 		refs = 1;
@@ -375,7 +376,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 							  buf->start,
 							  buf->len,
 							  new_flags, 0);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 		}
 	} else {
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
@@ -415,7 +417,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *cow;
-	int level;
+	int level, ret;
 	int last_ref = 0;
 	int unlock_orig = 0;
 	u64 parent_start;
@@ -467,7 +469,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	update_ref_for_cow(trans, root, buf, cow, &last_ref);
+	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
+	BUG_ON(ret);
 
 	if (root->ref_cows)
 		btrfs_reloc_cow_block(trans, root, buf, cow);
-- 
1.7.9



