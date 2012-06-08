Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab2FHT0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:26:38 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q58JQb5O002861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Jun 2012 15:26:37 -0400
Received: from localhost.localdomain.com (vpn-8-48.rdu.redhat.com [10.11.8.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q58JQaEv030551
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Jun 2012 15:26:37 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: keep inode pinned when compressing writes
Date: Fri,  8 Jun 2012 15:26:36 -0400
Message-Id: <1339183596-14065-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported lots of problems using compression on the new code and it
turns out part of the problem was that igrab() was failing when we added a
new ordered extent.  This is because when writing out an inode under
compression we immediately return without actually doing anything to the
pages, and then in another thread at some point down the line actually do
the ordered dance.  The problem is between the point that we start writeback
and we actually add the ordered extent we could be trying to reclaim the
inode, which makes igrab() return NULL.  So we need to do an igrab() when we
create the async extent and then drop it when we are done with it.  This
makes sure we stay pinned in memory until the ordered extent can get a
reference on it and we are good to go.  With this patch we no longer panic
in btrfs_finish_ordered_io().  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 51b9971..293c018 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -986,8 +986,10 @@ static noinline void async_cow_start(struct btrfs_work *work)
 	compress_file_range(async_cow->inode, async_cow->locked_page,
 			    async_cow->start, async_cow->end, async_cow,
 			    &num_added);
-	if (num_added == 0)
+	if (num_added == 0) {
+		iput(async_cow->inode);
 		async_cow->inode = NULL;
+	}
 }
 
 /*
@@ -1020,6 +1022,8 @@ static noinline void async_cow_free(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
+	if (async_cow->inode)
+		iput(async_cow->inode);
 	kfree(async_cow);
 }
 
@@ -1038,7 +1042,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow); /* -ENOMEM */
-		async_cow->inode = inode;
+		async_cow->inode = igrab(inode);
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
-- 
1.7.7.6

