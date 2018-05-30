Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64073 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935883AbeE3GnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:43:16 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4C59E4B41E69
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 14:43:06 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: returns -ENOMEM if path allocation failed in btrfs_cross_ref_exist()
Date: Wed, 30 May 2018 14:49:10 +0800
Message-ID: <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
References: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_path() may fail due to no enough memory,
so let the function return -ENOMEM instead of -ENOENT is better.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:
  Add commit message to describe the patch. Thanks Nikolay.
  
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44093f92a532..99df6199dffc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3311,7 +3311,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 
 	path = btrfs_alloc_path();
 	if (!path)
-		return -ENOENT;
+		return -ENOMEM;
 
 	do {
 		ret = check_committed_ref(root, path, objectid,
-- 
2.17.0



