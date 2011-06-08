From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: use join_transaction in btrfs_evict_inode()
Date: Wed, 08 Jun 2011 11:56:44 +0800
Message-ID: <4DEEF2FC.9060209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The WARN_ON() in start_transaction() was triggered while balancing.

The cause is btrfs_relocate_chunk() started a transaction and
then called iput() on the inode that stores free space cache,
and iput() called btrfs_start_transaction() again.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02ff4a1..4e9aa28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3646,7 +3646,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_i_size_write(inode, 0);
 
 	while (1) {
-		trans = btrfs_start_transaction(root, 0);
+		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		trans->block_rsv = root->orphan_block_rsv;
 
-- 1.7.3.1 
