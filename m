From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix error handling of btrfs_iget()
Date: Thu, 23 Feb 2012 16:15:25 +0900
Message-ID: <201202230715.AA00045@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_iget() never return NULL. So, NULL check is unnecessary.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/relocation.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8c1aae2..be1caf4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3240,8 +3240,8 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
-	if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
-		if (inode && !IS_ERR(inode))
+	if (IS_ERR(inode) || is_bad_inode(inode)) {
+		if (!IS_ERR(inode))
 			iput(inode);
 		return -ENOENT;
 	}

