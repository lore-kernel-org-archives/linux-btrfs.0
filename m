From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix more ESTALE problems with NFS
Date: Thu, 18 Nov 2010 21:18:02 -0500
Message-ID: <1290133082-3788-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When creating new inodes we don't setup inode->i_generation.  So if we generate
an fh with a newly created inode we save the generation of 0, but if we flush
the inode to disk and have to read it back when getting the inode on the server
we'll have the right i_generation, so gens wont match and we get ESTALE.  This
patch properly sets inode->i_generation when we create the new inode and now I'm
no longer getting ESTALE.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6f08892..3018878 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4502,6 +4502,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->index_cnt = 2;
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
+	inode->i_generation = BTRFS_I(inode)->generation;
 	btrfs_set_inode_space_info(root, inode);
 
 	if (mode & S_IFDIR)
-- 
1.6.6.1

