Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751080AbdLMIZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 03:25:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 634DDAD6D
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 08:25:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Remove redundan bio_get/bio_set pair from submit_one_bio
Date: Wed, 13 Dec 2017 10:25:39 +0200
Message-Id: <1513153540-10737-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1513153540-10737-1-git-send-email-nborisov@suse.com>
References: <1513153540-10737-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bio is never referenced after it has been submitted so there is no
point in getting an extra reference.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 16ae832bdb5d..c2fe059f9c92 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2732,7 +2732,6 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	start = page_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
-	bio_get(bio);
 
 	if (tree->ops)
 		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
@@ -2740,7 +2739,6 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	else
 		btrfsic_submit_bio(bio);
 
-	bio_put(bio);
 	return blk_status_to_errno(ret);
 }
 
-- 
2.7.4

