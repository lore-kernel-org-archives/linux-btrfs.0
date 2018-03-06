Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:18912 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeCFIef (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:34:35 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DAE48AC0093
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:34:28 +0900 (JST)
Received: from g01jpexchyt35.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 0B5976D6724
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:34:28 +0900 (JST)
Subject: [RFC PATCH 2/7] btrfs-progs: sub list: Add helper function which
 checks the permission for tree search ioctl
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <cadac9ab-0ed1-968c-26b4-2a231864c506@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:34:25 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparetion work to allow normal user to call "subvolume list".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c | 30 ++++++++++++++++++++++++++++++
 btrfs-list.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index e01c5899..aea917c5 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -958,6 +958,36 @@ out:
 	return 0;
 }
 
+/*
+ * Check the permission for tree search ioctl by searching a key
+ * which alwasys exists
+ */
+int check_perm_for_tree_search(int fd)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	int ret;
+
+	memset(&args, 0, sizeof(args));
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->max_objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+
+	if (ret == -EPERM)
+		return 0;
+	if (ret)
+		return ret;
+	return 1;
+}
+
 static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 {
 	int ret;
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..6225311d 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -176,5 +176,6 @@ char *btrfs_list_path_for_root(int fd, u64 root);
 int btrfs_list_get_path_rootid(int fd, u64 *treeid);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
 int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
+int check_perm_for_tree_search(int fd);
 
 #endif
-- 
2.14.3

