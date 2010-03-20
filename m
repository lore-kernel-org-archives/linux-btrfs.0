From: Dan Carpenter <error27@gmail.com>
Subject: [patch 3/3] btrfs cleanup: unneeded null check
Date: Sat, 20 Mar 2010 14:37:52 +0300
Message-ID: <20100320113752.GA5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Yan Zheng <zheng.yan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

old_inode cannot be null here so I removed the check.
This fixes a smatch warning:
fs/btrfs/inode.c +5545 btrfs_rename(88) warn: variable dereferenced 
	before check 'old_inode'

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
linux-next material

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02bb099..647ce41 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5541,10 +5541,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
 	 */
-	if (new_inode && new_inode->i_size &&
-	    old_inode && S_ISREG(old_inode->i_mode)) {
+	if (new_inode && new_inode->i_size && S_ISREG(old_inode->i_mode))
 		btrfs_add_ordered_operation(trans, root, old_inode);
-	}
 
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
