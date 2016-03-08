Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32893 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbcCHAyI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 19:54:08 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Holger=20Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: [PATCH 2/2] Btrfs: cleanup error handling in extent_write_cached_pages
Date: Mon,  7 Mar 2016 16:56:22 -0800
Message-Id: <1457398582-12606-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1457398582-12606-1-git-send-email-bo.li.liu@oracle.com>
References: <1457398582-12606-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we bail out immediately if ->writepage() returns an error,
we don't need an extra error to retain the error code.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1dfcffe..08282ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3922,7 +3922,6 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	struct inode *inode = mapping->host;
 	int ret = 0;
 	int done = 0;
-	int err = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
 	int nr_pages;
@@ -4015,8 +4014,6 @@ retry:
 				unlock_page(page);
 				ret = 0;
 			}
-			if (!err && ret < 0)
-				err = ret;
 			if (ret < 0) {
 				/*
 				 * done_index is set past this page,
@@ -4042,7 +4039,7 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done && !err) {
+	if (!scanned && !done) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
@@ -4056,7 +4053,7 @@ retry:
 		mapping->writeback_index = done_index;
 
 	btrfs_add_delayed_iput(inode);
-	return err;
+	return ret;
 }
 
 static void flush_epd_write_bio(struct extent_page_data *epd)
-- 
2.5.0

