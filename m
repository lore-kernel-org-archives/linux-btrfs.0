Return-Path: <SRS0=xOGy=CS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F77AC433E2
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Sep 2020 09:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C29A21D7A
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Sep 2020 09:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIIJuC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 05:50:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:54056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgIIJtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Sep 2020 05:49:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D67B6B163;
        Wed,  9 Sep 2020 09:49:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/10] btrfs: Remove mirror_num argument from extent_read_full_page
Date:   Wed,  9 Sep 2020 12:49:10 +0300
Message-Id: <20200909094914.29721-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200909094914.29721-1-nborisov@suse.com>
References: <20200909094914.29721-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's called only from btrfs_readpage which always passes 0 so just sink
the argument into extent_read_full_page.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 6 +++---
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c04d3655538..d2b71e97218c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3383,15 +3383,15 @@ static int __extent_read_full_page(struct page *page, struct bio **bio,
 	return ret;
 }
 
-int extent_read_full_page(struct page *page, int mirror_num)
+int extent_read_full_page(struct page *page)
 {
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 	int ret;
 
-	ret = __extent_read_full_page(page, &bio, mirror_num, &bio_flags, 0);
+	ret = __extent_read_full_page(page, &bio, 0, &bio_flags, 0);
 	if (bio)
-		ret = submit_one_bio(bio, mirror_num, bio_flags);
+		ret = submit_one_bio(bio, 0, bio_flags);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 57786feffdbf..96bc9f0c2981 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -193,7 +193,7 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 
-int extent_read_full_page(struct page *page, int mirror_num);
+int extent_read_full_page(struct page *page);
 int extent_write_full_page(struct page *page, struct writeback_control *wbc);
 int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8d1d935c8c7..3fd73573bbad 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8036,7 +8036,7 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 int btrfs_readpage(struct file *file, struct page *page)
 {
-	return extent_read_full_page(page, 0);
+	return extent_read_full_page(page);
 }
 
 static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
-- 
2.17.1

