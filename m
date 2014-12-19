Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10372 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbaLSGPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6EoKI027646
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs-progs: Remove a unused function root_gtp_mask().
Date: Fri, 19 Dec 2014 14:13:10 +0800
Message-ID: <1418969592-21278-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following clang warning when compiling btrfs-progs:

radix-tree.c:78:21: warning: unused function 'root_gfp_mask'
[-Wunused-function]
static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
                    ^
1 warning generated.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 radix-tree.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/radix-tree.c b/radix-tree.c
index 7457944..f259ab5 100644
--- a/radix-tree.c
+++ b/radix-tree.c
@@ -75,11 +75,6 @@ struct radix_tree_preload {
 };
 static struct radix_tree_preload radix_tree_preloads = { 0, };
 
-static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
-{
-	return root->gfp_mask & __GFP_BITS_MASK;
-}
-
 static int internal_nodes = 0;
 /*
  * This assumes that the caller has performed appropriate preallocation, and
-- 
2.1.3

