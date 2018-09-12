Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45207 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id x26-v6so885923pge.12
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:15 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 2/6] btrfs-progs: make btrfs_unlink() lookup inode_extref
Date: Wed, 12 Sep 2018 19:20:39 +0000
Message-Id: <20180912192046.5861-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

btrfs_unlink() uses btrfs_lookup_inode_ref() to look up inode_ref
but forget inode_extref case.

Let btrfs_unlink() call btrfs_lookup_inode_extref() if inode_ref is
found and EXTENDED_IREF feature is enabled.

Fixes: 0cc75eddd093 ("btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 inode.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/inode.c b/inode.c
index 2398bca4a109..598ad0ab6b4c 100644
--- a/inode.c
+++ b/inode.c
@@ -277,6 +277,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct btrfs_key key;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_inode_ref *inode_ref;
+	struct btrfs_inode_extref *inode_extref = NULL;
 	struct btrfs_dir_item *dir_item;
 	u64 inode_size;
 	u32 nlinks;
@@ -296,7 +297,18 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		ret = PTR_ERR(inode_ref);
 		goto out;
 	}
-	if (inode_ref)
+
+	if (!inode_ref && btrfs_fs_incompat(root->fs_info, EXTENDED_IREF)) {
+		btrfs_release_path(path);
+		inode_extref = btrfs_lookup_inode_extref(trans, root, path,
+					 name, namelen, ino, parent_ino, 0);
+		if (IS_ERR(inode_extref)) {
+			ret = PTR_ERR(inode_extref);
+			goto out;
+		}
+	}
+
+	if (inode_ref || inode_extref)
 		del_inode_ref = 1;
 	btrfs_release_path(path);
 
-- 
2.18.0
