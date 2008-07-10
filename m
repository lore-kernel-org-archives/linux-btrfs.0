From: "Yan Zheng" <yanzheng@21cn.com>
Subject: [Btrfs-devel][PATCH] Properly release lock in pin_down_bytes
Date: Fri, 11 Jul 2008 03:20:51 +0800
Message-ID: <3d0408630807101220l562b23caxe08afbaff27c1913@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When buffer isn't uptodate, pin_down_bytes may leave the tree locked
after it returns.

Regards
YZ
---
diff -r 3f0eee804974 extent-tree.c
--- a/extent-tree.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/extent-tree.c	Fri Jul 11 03:20:00 2008 +0800
@@ -1441,8 +1441,8 @@ static int pin_down_bytes(struct btrfs_r
 		struct extent_buffer *buf;
 		buf = btrfs_find_tree_block(root, bytenr, num_bytes);
 		if (buf) {
-			if (!btrfs_try_tree_lock(buf) &&
-			    btrfs_buffer_uptodate(buf, 0)) {
+			if (btrfs_buffer_uptodate(buf, 0) &&
+			    !btrfs_try_tree_lock(buf)) {
 				u64 transid =
 				    root->fs_info->running_transaction->transid;
 				u64 header_transid =
