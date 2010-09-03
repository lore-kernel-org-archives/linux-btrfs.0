From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 2/2] btrfs: better error handling in xattr.c
Date: Thu, 2 Sep 2010 17:06:42 -0700
Message-ID: <20100903000642.GC4364@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This was quite trivial - there's only 3 places I counted where we weren't
handling errors. None of the sites looked like they needed any additional
unrolling either.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/xattr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 0b4f7e6..109fdc3 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -119,11 +119,10 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		}
 
 		ret = btrfs_delete_one_dir_name(trans, root, path, di);
-		btrfs_fixable_bug_on(ret);
 		btrfs_release_path(root, path);
 
 		/* if we don't have a value then we are removing the xattr */
-		if (!value)
+		if (ret || !value)
 			goto out;
 	} else {
 		btrfs_release_path(root, path);
@@ -138,7 +137,6 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	/* ok we have to create a completely new xattr */
 	ret = btrfs_insert_xattr_item(trans, root, path, inode->i_ino,
 				      name, name_len, value, size);
-	btrfs_fixable_bug_on(ret);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -166,7 +164,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 
 	inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, inode);
-	btrfs_fixable_bug_on(ret);
+
 out:
 	btrfs_end_transaction_throttle(trans, root);
 	return ret;
-- 
1.6.4.2

