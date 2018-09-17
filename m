Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17617 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727099AbeIQMsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 08:48:14 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id CBC394B6EC8D
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 15:21:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 2/7] btrfs-progs: make btrfs_unlink() lookup inode_extref
Date: Mon, 17 Sep 2018 15:28:47 +0800
Message-ID: <20180917072852.25831-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_unlink() uses btrfs_lookup_inode_ref() to look up inode_ref
but forget inode_extref case.

Let btrfs_unlink() call btrfs_lookup_inode_extref() if inode_ref is
found and EXTENDED_IREF feature is enabled.

Fixes: 0cc75eddd093 ("btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
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
2.17.1
