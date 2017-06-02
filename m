Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ7e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 837C5ABB1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/8] btrfs: btrfs_bio_alloc never fails, skip error handling
Date: Fri,  2 Jun 2017 18:58:33 +0200
Message-Id: <a77256a3af2055537dc0eb7b15995fc673a4c0cc.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update direct callers of btrfs_bio_alloc that do error handling, that we
can now remove.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 78a787c36a35..17f80a18e787 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2807,9 +2807,6 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 
 	bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
 			GFP_NOFS | __GFP_HIGH);
-	if (!bio)
-		return -ENOMEM;
-
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
-- 
2.12.0

