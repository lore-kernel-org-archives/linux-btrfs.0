Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59172 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeEDHrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 03:47:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 805A6ACDD
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 07:47:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs-progs: Remove objectid argument from alloc_cache_extent
Date: Fri,  4 May 2018 10:47:27 +0300
Message-Id: <1525420047-17397-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1525420047-17397-1-git-send-email-nborisov@suse.com>
References: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with objectid set to 0. So remove the
parameter and statically set the ->objectid to 0 when allocating a new
extent.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-cache.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/extent-cache.c b/extent-cache.c
index 662c801e6760..f458de261293 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -93,15 +93,14 @@ void cache_tree_init(struct cache_tree *tree)
 	tree->root = RB_ROOT;
 }
 
-static struct cache_extent *
-alloc_cache_extent(u64 objectid, u64 start, u64 size)
+static struct cache_extent *alloc_cache_extent(u64 start, u64 size)
 {
 	struct cache_extent *pe = malloc(sizeof(*pe));
 
 	if (!pe)
 		return pe;
 
-	pe->objectid = objectid;
+	pe->objectid = 0;
 	pe->start = start;
 	pe->size = size;
 	return pe;
@@ -109,7 +108,7 @@ alloc_cache_extent(u64 objectid, u64 start, u64 size)
 
 int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
 {
-	struct cache_extent *pe = alloc_cache_extent(0, start, size);
+	struct cache_extent *pe = alloc_cache_extent(start, size);
 	int ret;
 
 	if (!pe) {
-- 
2.7.4

