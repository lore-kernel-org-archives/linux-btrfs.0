Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:37405 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeCOIOB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:14:01 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E1894AC0173
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:13:56 +0900 (JST)
Received: from G01JPEXCHYT17.g01.fujitsu.local (G01JPEXCHYT17.g01.fujitsu.local [10.128.194.56])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 251936D64CD
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:13:56 +0900 (JST)
Subject: [RFC PATCH v2 3/8] btrfs-progs: sub list: Add helper function which
 checks the permission for tree search ioctl
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Message-ID: <d5bbc64b-0b04-b223-bf84-de9f3bcb86e0@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:13:53 +0900
MIME-Version: 1.0
In-Reply-To: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparetion work to allow normal user to call
"subvolume list/show".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c | 33 +++++++++++++++++++++++++++++++++
 btrfs-list.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index 50e5ce5f..88689a9d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -958,6 +958,39 @@ out:
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
+	if (!ret)
+		ret = 1;
+	else if (ret < 0 && errno == EPERM)
+		ret = 0;
+	else
+		ret = -errno;
+
+	return ret;
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

