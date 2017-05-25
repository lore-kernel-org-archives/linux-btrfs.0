Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65110 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755084AbdEYCHX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 22:07:23 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 4347F47C6D2C
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 10:07:13 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs: Introduce btrfs_check_namelen to avoid reading beyond boundary
Date: Thu, 25 May 2017 10:09:06 +0800
Message-ID: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading out name from inode_ref, dir_item, it's possible that
corrupted name_len lead to read beyond boundary.

Since there are already patches for btrfs-progs, this is for btrfs.

Introduce function btrfs_check_namelen, it should be called before reading
name from extent_buffer.
The function compares arg @namelen with boundary then returns 'proper'
namelen.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |  2 ++
 fs/btrfs/dir-item.c | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d2b2e6..f49e04e7612b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3074,6 +3074,8 @@ int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 				   int name_len,
 				   struct btrfs_inode_extref **extref_ret);
 
+u16 btrfs_check_namelen(struct extent_buffer *leaf, int slot,
+			unsigned long start, u32 namelen);
 /* file-item.c */
 struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c24d615e3d7f..7af5ad8e9a3c 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -484,3 +484,25 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 
 	return 0;
 }
+
+/*
+ * Returns >0: the value @namelen after cut according item boundary
+ * Returns  0: on error
+ */
+u16 btrfs_check_namelen(struct extent_buffer *leaf, int slot,
+			unsigned long start, u32 namelen)
+{
+	u32 end;
+	u64 ret = namelen;
+
+	end = btrfs_leaf_data(leaf) + btrfs_item_end_nr(leaf, slot);
+
+	if (start > end)
+		return 0;
+	if (start + namelen > end) {
+		ret = end - start;
+		if (ret > U16_MAX)
+			ret = 0;
+	}
+	return ret;
+}
-- 
2.13.0



