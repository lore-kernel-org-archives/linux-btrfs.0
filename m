From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: join the transaction in __btrfs_setxattr
Date: Thu, 29 Jan 2009 17:05:28 -0500
Message-ID: <1233266728-9855-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

With selinux on we end up calling __btrfs_setxattr when we create an inode,
which calls btrfs_start_transaction().  The problem is we've already called that
in btrfs_new_inode, and in btrfs_start_transaction we end up doing a
wait_current_trans().  If btrfs-transaction has started committing it will wait
for all handles to finish, while the other process is waiting for the
transaction to commit.  This is fixed by using btrfs_join_transaction, which
won't wait for the transaction to commit.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 312b943..a9d3bf4 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -98,7 +98,7 @@ int __btrfs_setxattr(struct inode *inode, const char *name,
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
 
 	/* first lets see if we already have this xattr */
-- 
1.5.4.3

