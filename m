Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbcENAF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:26 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05OsE028129
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u4E05Ogi020387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u4E05OgT008379
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] Btrfs: fix eb memory leak due to readpage failure
Date: Fri, 13 May 2016 17:07:01 -0700
Message-Id: <1463184422-13584-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

eb->io_pages is set in read_extent_buffer_pages().

In case of readpage failure, for pages that have been added to bio,
it calls bio_endio and later readpage_io_failed_hook() does the work.

When this eb's page (couldn't be the 1st page) fails to add itself to bio
due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
 and ends up with a memory leak eventually.

This adds the 'atomic_dec(&eb->io_pages)' to the readpage error handling.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 99286d1..2327200 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3069,6 +3069,30 @@ static int __do_readpage(struct extent_io_tree *tree,
 			*bio_flags = this_bio_flag;
 		} else {
 			SetPageError(page);
+			/*
+			 * Only metadata io request has this issue, for data it
+			 * just unlocks extent and releases page's lock.
+			 *
+			 * eb->io_pages is set in read_extent_buffer_pages().
+			 *
+			 * When this eb's page fails to add itself to bio,
+			 * it cannot decrease eb->io_pages via bio_endio, and
+			 * ends up with extent_buffer_under_io() always being
+			 * true, because of that, eb won't be freed and we have
+			 * a memory leak eventually.
+			 *
+			 * Here we still hold this page's lock, and other tasks
+			 * who're also reading this eb are blocked.
+			 */
+			if (rw & REQ_META) {
+				struct extent_buffer *eb;
+
+				WARN_ON_ONCE(!PagePrivate(page));
+				eb = (struct extent_buffer *)page->private;
+
+				WARN_ON_ONCE(atomic_read(&eb->io_pages) < 1);
+				atomic_dec(&eb->io_pages);
+			}
 			unlock_extent(tree, cur, cur + iosize - 1);
 		}
 		cur = cur + iosize;
-- 
2.5.5

