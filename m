Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37187 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3LKXk4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:40:56 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:40:55 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 6234719D803E
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:47 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLcj7Y5571046
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:38:45 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNerre031452
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:53 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 4/7] btrfs: subpagesize-blocksize: Handle iosize properly in submit_extent_page()
Date: Wed, 11 Dec 2013 17:38:39 -0600
Message-Id: <1386805122-23972-5-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpagesize-blocksize case make sure that the IO submitted through
submit_extent_page() is at least of PAGE_CACHE_SIZE

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/extent_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e1992ed..2cf2a3b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2647,6 +2647,9 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	int old_compressed = prev_bio_flags & EXTENT_BIO_COMPRESSED;
 	size_t page_size = min_t(size_t, size, PAGE_CACHE_SIZE);
 
+	if (page->mapping->host->i_sb->s_blocksize < PAGE_CACHE_SIZE)
+		page_size = PAGE_CACHE_SIZE;
+
 	if (bio_ret && *bio_ret) {
 		bio = *bio_ret;
 		if (old_compressed)
-- 
1.7.12.4

