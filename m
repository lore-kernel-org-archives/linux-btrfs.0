From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix stat blocks accounting
Date: Wed, 16 Nov 2011 16:35:08 +0100
Message-ID: <1321457708-14582-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Round inode bytes and delalloc bytes up to real blocksize before
converting to sector size. Otherwise eg. files smaller than 512
are reported with zero blocks due to incorrect rounding.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e16215f..8ad26b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6794,11 +6794,13 @@ static int btrfs_getattr(struct vfsmount *mnt,
 			 struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
+	u32 blocksize = inode->i_sb->s_blocksize;
+
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
 	stat->blksize = PAGE_CACHE_SIZE;
-	stat->blocks = (inode_get_bytes(inode) +
-			BTRFS_I(inode)->delalloc_bytes) >> 9;
+	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
+		ALIGN(BTRFS_I(inode)->delalloc_bytes, blocksize)) >> 9;
 	return 0;
 }
 
-- 
1.7.6

