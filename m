Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaAWGAC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 01:00:02 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0N5nMxb002339
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 13:49:33 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix to catch all errors when resolving indirect ref
Date: Thu, 23 Jan 2014 13:47:49 +0800
Message-Id: <1390456069-5577-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390456069-5577-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390456069-5577-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can only tolerate ENOENT here, for other errors, we should
return directly.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index fd9ae72..3512437 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -387,10 +387,16 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			continue;
 		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
 					     parents, extent_item_pos);
-		if (err == -ENOMEM)
-			goto out;
-		if (err)
+		/*
+		 * we can only tolerate ENOENT,otherwise,we should catch error
+		 * and return directly.
+		 */
+		if (err == -ENOENT) {
 			continue;
+		} else if (err) {
+			ret = err;
+			goto out;
+		}
 
 		/* we put the first parent into the ref at hand */
 		ULIST_ITER_INIT(&uiter);
-- 
1.8.3.1

