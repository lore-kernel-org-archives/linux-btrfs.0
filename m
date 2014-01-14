Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANMiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 07:38:06 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECbrbi015995
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:37:53 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't miss roots in deletion during walking backrefs
Date: Tue, 14 Jan 2014 20:36:48 +0800
Message-Id: <1389703008-1781-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_fs_root_no_name() will check its root refs, and will
return us ENOENT if this root in deletion.

However, in some case, for example qgroup, we still need to track
those roots, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 835b6c9..ec4a1d2 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -303,7 +303,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	root_key.objectid = ref->root_id;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root_key.offset = (u64)-1;
-	root = btrfs_read_fs_root_no_name(fs_info, &root_key);
+	root = btrfs_get_fs_root(fs_info, &root_key, false);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
 		goto out;
-- 
1.8.3.1

