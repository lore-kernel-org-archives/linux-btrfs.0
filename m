From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] btrfs: return inode to fs when btrfs_new_inode fails
Date: Wed, 25 Feb 2009 12:10:17 +0800
Message-ID: <49A4C4A9.6050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


btrfs_new_inode doesn't call iput to return inode to fs
when it fails.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3cee77a..2cae014 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3443,8 +3443,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	if (dir) {
 		ret = btrfs_set_inode_index(dir, index);
-		if (ret)
+		if (ret) {
+			iput(inode);
 			return ERR_PTR(ret);
+		}
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
@@ -3525,6 +3527,7 @@ fail:
 	if (dir)
 		BTRFS_I(dir)->index_cnt--;
 	btrfs_free_path(path);
+	iput(inode);
 	return ERR_PTR(ret);
 }
 
-- 
1.6.0.6

