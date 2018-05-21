Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:35857 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbeEUE5t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 00:57:49 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 8C98AAC0132
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 13:57:43 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id BEFDA328618
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 13:57:42 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: Fix to use original error code of
 btrfs_read_fs_root_no_name()
References: <cover.1526878216.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
Date: Mon, 21 May 2018 13:57:27 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1526878216.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_fs_root_no_name() may return ERR_PTR(-ENOENT) or
ERR_PTR(-ENOMEM) and therefore search_ioctl() and
btrfs_search_path_in_tree() should use PTR_ERR() instead of -ENOENT,
which all other callers of btrfs_read_fs_root_no_name() does.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8f7c1b9a2db7..0f90e68ca512 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2155,7 +2155,7 @@ static noinline int search_ioctl(struct inode *inode,
 		root = btrfs_read_fs_root_no_name(info, &key);
 		if (IS_ERR(root)) {
 			btrfs_free_path(path);
-			return -ENOENT;
+			return PTR_ERR(root);
 		}
 	}
 
@@ -2290,7 +2290,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	root = btrfs_read_fs_root_no_name(info, &key);
 	if (IS_ERR(root)) {
 		btrfs_err(info, "could not find root %llu", tree_id);
-		ret = -ENOENT;
+		ret = PTR_ERR(root);
 		goto out;
 	}
 
-- 
2.14.3


