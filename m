From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/8] btrfs: Don't BUG_ON errors from btrfs_create_subvol_root()
Date: Thu, 18 Aug 2011 14:56:54 -0700
Message-ID: <1313704621-15219-2-git-send-email-mfasheh@suse.de>
References: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This is called from only one place - create_subvol() which passes errors
safely back out to it's caller, btrfs_mksubvol where they are handled.

Additionally, btrfs_create_subvol_root() itself bug's needlessly from error
return of btrfs_update_inode(). Since create_subvol() was fixed to catch
errors we can bubble this one up too.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |    3 +--
 fs/btrfs/ioctl.c |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15fceef..7028c0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6722,10 +6722,9 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(inode, 0);
 
 	err = btrfs_update_inode(trans, new_root, inode);
-	BUG_ON(err);
 
 	iput(inode);
-	return 0;
+	return err;
 }
 
 struct inode *btrfs_alloc_inode(struct super_block *sb)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cf0133..b3440f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -411,6 +411,8 @@ static noinline int create_subvol(struct btrfs_root *root,
 	btrfs_record_root_in_trans(trans, new_root);
 
 	ret = btrfs_create_subvol_root(trans, new_root, new_dirid);
+	if (ret)
+		goto fail;
 	/*
 	 * insert the directory item
 	 */
-- 
1.7.6

