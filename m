From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 19/35] btrfs: Dont BUG_ON errors from btrfs_create_subvol_root()
Date: Wed, 21 Mar 2012 21:11:23 -0400
Message-ID: <20120322011135.665837219@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is called from only one place - create_subvol() which passes errors
safely back out to it's caller, btrfs_mksubvol where they are handled.

Additionally, btrfs_create_subvol_root() itself bug's needlessly from error
return of btrfs_update_inode(). Since create_subvol() was fixed to catch
errors we can bubble this one up too.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |    3 +--
 fs/btrfs/ioctl.c |    5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 593a2c3..4113233 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6734,10 +6734,9 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(inode, 0);
 
 	err = btrfs_update_inode(trans, new_root, inode);
-	BUG_ON(err);
 
 	iput(inode);
-	return 0;
+	return err;
 }
 
 struct inode *btrfs_alloc_inode(struct super_block *sb)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4e51494..de25e42 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -430,6 +430,11 @@ static noinline int create_subvol(struct btrfs_root *root,
 	btrfs_record_root_in_trans(trans, new_root);
 
 	ret = btrfs_create_subvol_root(trans, new_root, new_dirid);
+	if (ret) {
+		/* We potentially lose an unused inode item here */
+		goto fail;
+	}
+
 	/*
 	 * insert the directory item
 	 */
-- 
1.7.9



