Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254Ab2EaUES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 16:04:18 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VK4IoV009412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 16:04:18 -0400
Received: from localhost.localdomain.com (vpn-8-248.rdu.redhat.com [10.11.8.248])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4VK4HA9029039
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 16:04:18 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: do not reset the eb ref count to 1 when aborting the transaction
Date: Thu, 31 May 2012 16:04:15 -0400
Message-Id: <1338494656-12232-3-git-send-email-josef@redhat.com>
In-Reply-To: <1338494656-12232-1-git-send-email-josef@redhat.com>
References: <1338494656-12232-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This screws lots of things up and is just plain unnecessary, everything will
get cleaned up properly on it's own.  Most notably this was causing root
eb's to be evicted forcefully which meant that any readers still doing
anything would block trying to grab the root eb since it had a ref count of
0.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 050db9b..b147a86 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3519,11 +3519,9 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			     &(&BTRFS_I(page->mapping->host)->io_tree)->buffer,
 					       offset >> PAGE_CACHE_SHIFT);
 			spin_unlock(&dirty_pages->buffer_lock);
-			if (eb) {
+			if (eb)
 				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
 							 &eb->bflags);
-				atomic_set(&eb->refs, 1);
-			}
 			if (PageWriteback(page))
 				end_page_writeback(page);
 
-- 
1.7.7.6

