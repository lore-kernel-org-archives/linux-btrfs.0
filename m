From: "Yan Zheng" <yanzheng@21cn.com>
Subject: [PATCH] Fix path slots selection in btrfs_search_forward
Date: Tue, 15 Jul 2008 22:26:06 +0800
Message-ID: <3d0408630807150726w5690d2c1va81dc81cada3175d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

We should decrease the found slot by one as btrfs_search_slot does
when bin_search return 1 and node level > 0.

Regards
YZ
---
diff -r 3f0eee804974 ctree.c
--- a/ctree.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/ctree.c	Tue Jul 15 22:05:54 2008 +0800
@@ -2996,6 +2996,7 @@ int btrfs_search_forward(struct btrfs_ro
 	struct extent_buffer *cur;
 	struct btrfs_key found_key;
 	int slot;
+	int sret;
 	u32 nritems;
 	int level;
 	int ret = 1;
@@ -3013,7 +3014,7 @@ again:
 	while(1) {
 		nritems = btrfs_header_nritems(cur);
 		level = btrfs_header_level(cur);
-		bin_search(cur, min_key, level, &slot);
+		sret = bin_search(cur, min_key, level, &slot);

 		/* at level = 0, we're done, setup the path and exit */
 		if (level == 0) {
@@ -3022,6 +3023,8 @@ again:
 			btrfs_item_key_to_cpu(cur, &found_key, slot);
 			goto out;
 		}
+		if (sret && slot > 0)
+			slot--;
 		/*
 		 * check this node pointer against the cache_only and
 		 * min_trans parameters.  If it isn't in cache or is too
