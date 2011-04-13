From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/4] Btrfs: Fix incorrect inode nlink in btrfs_link()
Date: Wed, 13 Apr 2011 15:43:00 +0800
Message-ID: <4DA55404.4060702@cn.fujitsu.com>
References: <4DA553C9.2040807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA553C9.2040807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Link count of the inode is not decreased if btrfs_set_inode_index()
fails.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Singed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b9f7f52..a4157cf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4846,9 +4846,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink == ~0U)
 		return -EMLINK;
 
-	btrfs_inc_nlink(inode);
-	inode->i_ctime = CURRENT_TIME;
-
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
@@ -4864,6 +4861,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 	}
 
+	btrfs_inc_nlink(inode);
+	inode->i_ctime = CURRENT_TIME;
+
 	btrfs_set_trans_block_group(trans, dir);
 	ihold(inode);
 
-- 
1.7.3.1
