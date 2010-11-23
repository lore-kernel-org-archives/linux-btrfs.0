From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: update inode ctime when using links
Date: Tue, 23 Nov 2010 14:50:59 -0500
Message-ID: <1290541859-25296-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently we fail xfstest 236 because we're not updating the inode ctime on
link.  This is a simple fix, and makes it so we pass 236 now.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 25a8fa2..476f3b7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4785,6 +4785,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -EPERM;
 
 	btrfs_inc_nlink(inode);
+	inode->i_ctime = CURRENT_TIME;
 
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
-- 
1.6.6.1

