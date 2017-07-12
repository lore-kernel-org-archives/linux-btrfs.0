Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36413 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750766AbdGLGcU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 02:32:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE62EACBF
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 06:32:18 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant code
Date: Wed, 12 Jul 2017 09:32:15 +0300
Message-Id: <1499841135-18251-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

insert_into_bitmap has only one caller which always allocates the info struct
passed. As such remove the any NULL checks for info and also remove code
to allocate info in case it was NULL.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-cache.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c5e6180cdb8c..fd24fb99d6dc 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2101,7 +2101,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 		goto again;
 
 new_bitmap:
-	if (info && info->bitmap) {
+	if (info->bitmap) {
 		add_new_bitmap(ctl, info, offset);
 		added = 1;
 		info = NULL;
@@ -2109,17 +2109,6 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 	} else {
 		spin_unlock(&ctl->tree_lock);
 
-		/* no pre-allocated info, allocate a new one */
-		if (!info) {
-			info = kmem_cache_zalloc(btrfs_free_space_cachep,
-						 GFP_NOFS);
-			if (!info) {
-				spin_lock(&ctl->tree_lock);
-				ret = -ENOMEM;
-				goto out;
-			}
-		}
-
 		/* allocate the bitmap */
 		info->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
 		spin_lock(&ctl->tree_lock);
-- 
2.7.4

