From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfsck: Remove superfluous WARN_ON
Date: Mon, 01 Feb 2010 11:08:46 +0800
Message-ID: <4B6645BE.4060903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs-2/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2009-09-28 15:54:55.980479398 +0800
+++ btrfs-progs-2/btrfsck.c	2010-01-31 09:46:24.645485459 +0800
@@ -581,7 +581,6 @@ again:
 		}
 		ret = insert_existing_cache_extent(dst, &ins->cache);
 		if (ret == -EEXIST) {
-			WARN_ON(src == &src_node->root_cache);
 			conflict = get_inode_rec(dst, rec->ino, 1);
 			merge_inode_recs(rec, conflict, dst);
 			if (rec->checked) {
