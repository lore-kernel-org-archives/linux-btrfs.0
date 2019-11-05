Return-Path: <SRS0=ssiY=Y5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB66C1747C
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 13:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF9F21D71
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 13:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbfKENvb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:51:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:38352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389364AbfKENvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Nov 2019 08:51:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9100B23B;
        Tue,  5 Nov 2019 13:51:29 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs: remove unneeded check for btrfs_free_space_info in insert_into_bitmap()
Date:   Tue,  5 Nov 2019 14:51:27 +0100
Message-Id: <20191105135127.17357-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only caller for insert_into_bitmap() is __btrfs_add_free_space() and
it takes care that the btrfs_free_space_info pointer passed to
insert_into_bitmap() is allocated.

Inside insert_into_bitmap() we're not freeing or NULLing this pointer
anywhere, so checking if it is pre-allocated inside 'new_bitmap' label is
pointless, so remove this check.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/free-space-cache.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 279c41c4ba50..02f680be8999 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2121,7 +2121,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 		goto again;
 
 new_bitmap:
-	if (info && info->bitmap) {
+	if (info->bitmap) {
 		add_new_bitmap(ctl, info, offset);
 		added = 1;
 		info = NULL;
@@ -2129,17 +2129,6 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
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
 		info->bitmap = kmem_cache_zalloc(btrfs_free_space_bitmap_cachep,
 						 GFP_NOFS);
@@ -2152,12 +2141,10 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 	}
 
 out:
-	if (info) {
-		if (info->bitmap)
-			kmem_cache_free(btrfs_free_space_bitmap_cachep,
-					info->bitmap);
-		kmem_cache_free(btrfs_free_space_cachep, info);
-	}
+	if (info->bitmap)
+		kmem_cache_free(btrfs_free_space_bitmap_cachep,
+				info->bitmap);
+	kmem_cache_free(btrfs_free_space_cachep, info);
 
 	return ret;
 }
-- 
2.16.4

