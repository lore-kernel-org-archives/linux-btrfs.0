From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: [PATCH] Btrfs: fix missing printk priority level
Date: Sun, 13 Feb 2011 10:07:28 +0900
Message-ID: <1297559248-18636-1-git-send-email-yoshinori.sano@gmail.com>
Cc: Yoshinori Sano <yoshinori.sano@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a trivial fix that sets priority level of printk.

Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0209b5f..f6ce38c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -577,7 +577,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	tree_root = open_ctree(sb, fs_devices, (char *)data);
 
 	if (IS_ERR(tree_root)) {
-		printk("btrfs: open_ctree failed\n");
+		printk(KERN_CRIT "btrfs: open_ctree failed\n");
 		return PTR_ERR(tree_root);
 	}
 	sb->s_fs_info = tree_root;
-- 
1.7.1

