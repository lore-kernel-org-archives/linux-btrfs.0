From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix not enough reserved space
Date: Fri, 18 Feb 2011 17:21:17 +0800
Message-ID: <4D5E3A0D.3070101@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_link() will insert 3 items(inode ref, dir name item and dir index item)
into the b+ tree and update 2 items(its inode, and parent's inode) in the b+
tree. So we should reserve space for these 5 items, not 3 items.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8d392ed..d692df9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4823,10 +4823,11 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 
 	/*
-	 * 1 item for inode ref
+	 * 2 items for inode and inode ref
 	 * 2 items for dir items
+	 * 1 item for parent inode
 	 */
-	trans = btrfs_start_transaction(root, 3);
+	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		goto fail;
-- 
1.7.3.1
