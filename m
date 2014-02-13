Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaBMDUU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:20:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1D3K49e002790
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:20:09 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: cleanup nonsense ret value assignment
Date: Thu, 13 Feb 2014 11:16:37 +0800
Message-Id: <1392261398-6197-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The "ret" will be soon used to hold the return value of another function,
assign -1 to it before is nonsense.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 free-space-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 55d7318..bddde24 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -291,8 +291,6 @@ static int __load_free_space_cache(struct btrfs_root *root,
 		return 0;
 	}
 
-	ret = -1;
-
 	leaf = path->nodes[0];
 	header = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_free_space_header);
-- 
1.8.1.4

