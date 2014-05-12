Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaELErq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 00:47:46 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4C4lj2c023399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 May 2014 04:47:46 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4C4liYX027650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 May 2014 04:47:45 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4C4linl007053
	for <linux-btrfs@vger.kernel.org>; Mon, 12 May 2014 04:47:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: mark mapping with error flag to report errors to userspace
Date: Mon, 12 May 2014 12:47:36 +0800
Message-Id: <1399870056-29030-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to commit 865ffef3797da2cac85b3354b5b6050dc9660978
(fs: fix fsync() error reporting),
it's not stable to just check error pages because pages can be
truncated or invalidated, we should also mark mapping with error
flag so that a later fsync can catch the error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 80be17c..d7c7813 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2367,6 +2367,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	if (!uptodate) {
 		ClearPageUptodate(page);
 		SetPageError(page);
+		mapping_set_error(page->mapping, ret);
 	}
 	return 0;
 }
@@ -3368,6 +3369,8 @@ done:
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
+	if (PageError(page))
+		mapping_set_error(page->mapping, ret);
 	unlock_page(page);
 
 done_unlocked:
-- 
1.8.1.4

