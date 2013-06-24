Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55171 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FXG0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 02:26:54 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so10407587pab.8
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Jun 2013 23:26:54 -0700 (PDT)
Message-ID: <51C7E688.2020903@gmail.com>
Date: Mon, 24 Jun 2013 14:26:16 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: remove unused var *prev in extent-cache.c/find_cache_extent
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

var *prev is not used in function find_cache_extent. Remove it.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  extent-cache.c |    3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..6d86c33 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -117,10 +117,9 @@ int insert_cache_extent(struct cache_tree *tree, u64 start, u64 size)
  struct cache_extent *find_cache_extent(struct cache_tree *tree,
  					   u64 start, u64 size)
  {
-	struct rb_node *prev;
  	struct rb_node *ret;
  	struct cache_extent *entry;
-	ret = __tree_search(&tree->root, start, size, &prev);
+	ret = __tree_search(&tree->root, start, size, NULL);
  	if (!ret)
  		return NULL;

-- 
1.7.10.4
