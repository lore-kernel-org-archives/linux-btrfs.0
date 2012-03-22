From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 24/35] btrfs: Dont BUG_ON errors from update_ref_for_cow()
Date: Wed, 21 Mar 2012 21:11:28 -0400
Message-ID: <20120322011136.358072886@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_cow_block(), the only caller of update_ref_for_cow() will BUG_ON()
any error return.  Instead, we can go read-only fs as update_ref_for_cow()
manipulates disk data in a way which doesn't look like it's easily rolled
back.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3b767d2..36e16bd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -474,7 +474,10 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			    BTRFS_FSID_SIZE);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_std_error(root->fs_info, ret);
+		return ret;
+	}
 
 	if (root->ref_cows)
 		btrfs_reloc_cow_block(trans, root, buf, cow);
-- 
1.7.9



