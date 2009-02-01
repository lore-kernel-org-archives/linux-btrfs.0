From: Chris Ball <cjb@laptop.org>
Subject: [PATCH] btrfs: Handle SGID bit when creating inodes
Date: Sat, 31 Jan 2009 22:48:54 -0500
Message-ID: <m363ju3jh5.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, new files/dirs would ignore the SGID bit on their
parent directory and always be owned by the creating user's uid/gid.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 fs/btrfs/inode.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ebd7d6c..ce25bb3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3470,7 +3470,14 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		root->highest_inode = objectid;
 
 	inode->i_uid = current_fsuid();
-	inode->i_gid = current_fsgid();
+
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode->i_gid = current_fsgid();
+
 	inode->i_mode = mode;
 	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
-- 
1.6.1.2

-- 
Chris Ball   <cjb@laptop.org>
