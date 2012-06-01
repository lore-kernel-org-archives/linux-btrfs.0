Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759913Ab2FAN4A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 09:56:00 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q51DtxTL032257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:55:59 -0400
Received: from localhost.localdomain.com (vpn-9-98.rdu.redhat.com [10.11.9.98])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q51Dtwnh031587
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:55:59 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] Btrfs: pass locked_page into extent_clear_unlock_delalloc if theres an error
Date: Fri,  1 Jun 2012 09:55:49 -0400
Message-Id: <1338558955-4944-2-git-send-email-josef@redhat.com>
In-Reply-To: <1338558955-4944-1-git-send-email-josef@redhat.com>
References: <1338558955-4944-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing my enospc work I got a transaction abortion that resulted in a
panic when we tried to unlock_page() an already unlocked page.  This is
because we aren't calling extent_clear_unlock_delalloc with the locked page
so it was unlocking all the pages in the range.  This is wrong since
__extent_writepage expects to have the page locked still unless we return
*page_started as 1.  This should keep us from panicing.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46d8732..e91f985 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -830,7 +830,7 @@ static noinline int cow_file_range(struct inode *inode,
 	if (IS_ERR(trans)) {
 		extent_clear_unlock_delalloc(inode,
 			     &BTRFS_I(inode)->io_tree,
-			     start, end, NULL,
+			     start, end, locked_page,
 			     EXTENT_CLEAR_UNLOCK_PAGE |
 			     EXTENT_CLEAR_UNLOCK |
 			     EXTENT_CLEAR_DELALLOC |
@@ -963,7 +963,7 @@ out:
 out_unlock:
 	extent_clear_unlock_delalloc(inode,
 		     &BTRFS_I(inode)->io_tree,
-		     start, end, NULL,
+		     start, end, locked_page,
 		     EXTENT_CLEAR_UNLOCK_PAGE |
 		     EXTENT_CLEAR_UNLOCK |
 		     EXTENT_CLEAR_DELALLOC |
-- 
1.7.7.6

