Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65116 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750983AbeFVHrk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 03:47:40 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id EE2E84B34D54
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2018 15:47:34 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: return EUCLEAN if extent_inline_ref type is invalid
Date: Fri, 22 Jun 2018 15:53:49 +0800
Message-ID: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If type of extent_inline_ref found is not expected, filesystem may have
been corrupted, should return EUCLEAN instead of EINVAL.
No functional changes.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/relocation.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..05d50c3a594e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1727,7 +1727,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_get_extent_inline_ref_type(leaf, iref, needed);
 		if (type == BTRFS_REF_TYPE_INVALID) {
-			err = -EINVAL;
+			err = -EUCLEAN;
 			goto out;
 		}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..7c9855e8ae6f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3801,7 +3801,7 @@ int add_data_references(struct reloc_control *rc,
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
 		} else {
-			ret = -EINVAL;
+			ret = -EUCLEAN;
 			btrfs_err(rc->extent_root->fs_info,
 		     "extent %llu slot %d has an invalid inline ref type",
 			     eb->start, path->slots[0]);
-- 
2.17.1



