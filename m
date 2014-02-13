Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41654 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbaBMDVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:21:36 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1D3LL6f002855
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:21:32 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: skip locking when searching commit root
Date: Thu, 13 Feb 2014 11:19:47 +0800
Message-Id: <1392261587-29035-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We won't change commit root, skip locking dance with commit root
when walking backrefs, this can speed up btrfs send operations.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a88da72..860f4f2 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -873,8 +873,10 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	if (!trans)
+	if (!trans) {
 		path->search_commit_root = 1;
+		path->skip_locking = 1;
+	}
 
 	/*
 	 * grab both a lock on the path and a lock on the delayed ref head.
-- 
1.8.3.1

