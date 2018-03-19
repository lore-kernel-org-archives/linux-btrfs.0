Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:60258 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754894AbeCSHbC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:31:02 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 21268AC0118
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:30:59 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 50AED32861A
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:30:58 +0900 (JST)
Subject: [RFC PATCH v3 1/7] btrfs-progs: sub list: Call rb_free_nodes() in
 error path
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Message-ID: <0191e52b-b266-54cc-5fcf-f8e05f3a7ef6@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:30:54 +0900
MIME-Version: 1.0
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After btrfs_list_subvols() is called, root_lookup may hold some allocated
memory area even if the function fails.
Therefore rb_free_nodes() should be called.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e01c5899..50e5ce5f 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1523,8 +1523,10 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		return ret;
 
 	ret = btrfs_list_subvols(fd, &root_lookup);
-	if (ret)
+	if (ret) {
+		rb_free_nodes(&root_lookup.root, free_root_info);
 		return ret;
+	}
 	filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, top_id);
 
@@ -1554,14 +1556,18 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 		return ret;
 
 	ret = btrfs_list_subvols(fd, &rl);
-	if (ret)
+	if (ret) {
+		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
+	}
 
 	rbn = rb_first(&rl.root);
 	ri = rb_entry(rbn, struct root_info, rb_node);
 
-	if (ri->root_id != BTRFS_FS_TREE_OBJECTID)
+	if (ri->root_id != BTRFS_FS_TREE_OBJECTID) {
+		rb_free_nodes(&rl.root, free_root_info);
 		return -ENOENT;
+	}
 
 	memcpy(the_ri, ri, offsetof(struct root_info, path));
 	the_ri->path = strdup_or_null("/");
@@ -1585,8 +1591,10 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 		return ret;
 
 	ret = btrfs_list_subvols(fd, &rl);
-	if (ret)
+	if (ret) {
+		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
+	}
 
 	rbn = rb_first(&rl.root);
 	while(rbn) {
-- 
2.14.3

