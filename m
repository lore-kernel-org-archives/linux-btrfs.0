Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42868 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbbJVTFQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 15:05:16 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t9MJ28x6020597
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 12:05:15 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1xkj521n7j-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 12:05:15 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: igrab inode in writepage
Date: Thu, 22 Oct 2015 15:05:09 -0400
Message-ID: <1445540709-26995-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We hit this panic on a few of our boxes this week where we have an
ordered_extent with an NULL inode.  We do an igrab() of the inode in writepages,
but weren't doing it in writepage which can be called directly from the VM on
dirty pages.  If the inode has been unlinked then we could have I_FREEING set
which means igrab() would return NULL and we get this panic.  Fix this by trying
to igrab in btrfs_writepage, and if it returns NULL then just redirty the page
and return AOP_WRITEPAGE_ACTIVATE; so the VM knows it wasn't successful.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0fa725..4d1fdc2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8438,15 +8438,28 @@ int btrfs_readpage(struct file *file, struct page *page)
 static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree;
-
+	struct inode *inode = page->mapping->host;
+	int ret;
 
 	if (current->flags & PF_MEMALLOC) {
 		redirty_page_for_writepage(wbc, page);
 		unlock_page(page);
 		return 0;
 	}
+
+	/*
+	 * If we are under memory pressure we will call this directly from the
+	 * VM, we need to make sure we have the inode referenced for the ordered
+	 * extent.  If not just return like we didn't do anything.
+	 */
+	if (!igrab(inode)) {
+		redirty_page_for_writepage(wbc, page);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
+	ret = extent_write_full_page(tree, page, btrfs_get_extent, wbc);
+	btrfs_add_delayed_iput(inode);
+	return ret;
 }
 
 static int btrfs_writepages(struct address_space *mapping,
-- 
2.1.0

