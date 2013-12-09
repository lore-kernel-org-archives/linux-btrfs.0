Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37665 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab3LIQOk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 11:14:40 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so5692345pbc.34
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Dec 2013 08:14:39 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH 2/2] Btrfs: skip building backref tree for uuid and quota tree when doing balance relocation
Date: Tue, 10 Dec 2013 00:14:34 +0800
Message-Id: <1386605674-3320-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
References: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Quota tree and UUID Tree is only cowed, they can not be snapshoted.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4dc7f26..df6e18e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -571,7 +571,9 @@ static int is_cowonly_root(u64 root_objectid)
 	    root_objectid == BTRFS_CHUNK_TREE_OBJECTID ||
 	    root_objectid == BTRFS_DEV_TREE_OBJECTID ||
 	    root_objectid == BTRFS_TREE_LOG_OBJECTID ||
-	    root_objectid == BTRFS_CSUM_TREE_OBJECTID)
+	    root_objectid == BTRFS_CSUM_TREE_OBJECTID ||
+	    root_objectid == BTRFS_UUID_TREE_OBJECTID ||
+	    root_objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return 1;
 	return 0;
 }
-- 
1.8.4

