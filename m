From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 12/20] btrfs: Don't BUG_ON errors from update_ref_for_cow()
Date: Thu, 15 Sep 2011 10:34:51 -0700
Message-ID: <1316108099-5099-13-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

__btrfs_cow_block(), the only caller of update_ref_for_cow() will BUG_ON()
any error return.  Instead, we can go read-only fs as update_ref_for_cow()
manipulates disk data in a way which doesn't look like it's easily rolled
back.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8d8182f..31fdadf 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -482,7 +482,10 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
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
1.7.6

