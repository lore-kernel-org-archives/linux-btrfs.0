Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45195 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdBTScI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:32:08 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 835A9ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:32:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: drop checks for mandatory extent_io_ops callbacks
Date: Mon, 20 Feb 2017 19:31:30 +0100
Message-Id: <593119cff0ed8a8e04b0edc668648a95796e1032.1487615195.git.dsterba@suse.com>
In-Reply-To: <cover.1487615195.git.dsterba@suse.com>
References: <cover.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We know that eadpage_end_io_hook, submit_bio_hook and merge_bio_hook are
always defined so we can drop the checks before we call them.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8de29aa4d1a2..f5cff93ab152 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2565,8 +2565,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		len = bvec->bv_len;
 
 		mirror = io_bio->mirror_num;
-		if (likely(uptodate && tree->ops &&
-			   tree->ops->readpage_end_io_hook)) {
+		if (likely(uptodate && tree->ops)) {
 			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
 							      page, start, end,
 							      mirror);
@@ -2728,7 +2727,7 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	bio->bi_private = NULL;
 	bio_get(bio);
 
-	if (tree->ops && tree->ops->submit_bio_hook)
+	if (tree->ops)
 		ret = tree->ops->submit_bio_hook(page->mapping->host, bio,
 					   mirror_num, bio_flags, start);
 	else
@@ -2743,7 +2742,7 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
 		     unsigned long bio_flags)
 {
 	int ret = 0;
-	if (tree->ops && tree->ops->merge_bio_hook)
+	if (tree->ops)
 		ret = tree->ops->merge_bio_hook(page, offset, size, bio,
 						bio_flags);
 	return ret;
-- 
2.10.1

