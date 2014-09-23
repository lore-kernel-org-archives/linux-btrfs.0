Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31185 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaIWOWq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 10:22:46 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8NEMjU7012997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 14:22:46 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8NEMibi001460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 14:22:44 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s8NEMhC0004573
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 14:22:43 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix crash of btrfs_release_extent_buffer_page
Date: Tue, 23 Sep 2014 22:22:33 +0800
Message-Id: <1411482153-14416-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is actually inspired by Filipe's patch.  When write_one_eb() fails on
submit_extent_page(), it'll give up writing this eb and mark it with
EXTENT_BUFFER_IOERR.  So if it's not the last page that encounter the failure,
there are some left pages which remain DIRTY, and if a later COW on this eb
happens, ie. eb is COWed and freed, it'd run into BUG_ON in
btrfs_release_extent_buffer_page() for the DIRTY page, ie. BUG_ON(PageDirty(page));

This adds the missing clear_page_dirty_for_io() for the rest pages of eb.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index af0359d..e68a1d9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3597,6 +3597,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	if (unlikely(ret)) {
 		for (; i < num_pages; i++) {
 			struct page *p = extent_buffer_page(eb, i);
+			clear_page_dirty_for_io(p);
 			unlock_page(p);
 		}
 	}
-- 
1.8.1.4

