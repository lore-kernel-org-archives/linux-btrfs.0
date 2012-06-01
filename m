Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950Ab2FAN4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 09:56:02 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q51Du2Vb014591
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:02 -0400
Received: from localhost.localdomain.com (vpn-9-98.rdu.redhat.com [10.11.9.98])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q51Dtwnm031587
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:02 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] Btrfs: fix btrfs_destroy_marked_extents
Date: Fri,  1 Jun 2012 09:55:54 -0400
Message-Id: <1338558955-4944-7-git-send-email-josef@redhat.com>
In-Reply-To: <1338558955-4944-1-git-send-email-josef@redhat.com>
References: <1338558955-4944-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So we're forcing the eb's to have their ref count set to 1 so invalidatepage
works but this breaks lots of things, for example root nodes, and is just
plain wrong, we don't need to just evict all of this stuff.  Also drop the
invalidatepage altogether and add a page_cache_release().  With this patch
we no longer hang when trying to access the root nodes after an aborted
transaction and we no longer leak memory.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 050db9b..ea2b1d2 100644
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
 
@@ -3537,8 +3535,8 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 				spin_unlock_irq(&page->mapping->tree_lock);
 			}
 
-			page->mapping->a_ops->invalidatepage(page, 0);
 			unlock_page(page);
+			page_cache_release(page);
 		}
 	}
 
-- 
1.7.7.6

