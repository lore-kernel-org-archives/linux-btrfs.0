Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40437 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbbI3KaL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:30:11 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:30:09 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 8C1BB2CE8052
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:30:06 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UATwhr54853786
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:30:06 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UATXtB024045
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:34 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V5 12/13] Btrfs: prepare_pages: Retry adding a page to the page cache
Date: Wed, 30 Sep 2015 15:58:31 +0530
Message-Id: <1443608912-31667-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading the page from the disk, we can race with Direct I/O which can get
the page lock (before prepare_uptodate_page() gets it) and can go ahead and
invalidate the page. Hence if the page is not found in the inode's address
space, retry the operation of getting a page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5715e29..76db77c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1316,6 +1316,7 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 	int faili;
 
 	for (i = 0; i < num_pages; i++) {
+again:
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
 					       mask | __GFP_WRITE);
 		if (!pages[i]) {
@@ -1330,6 +1331,21 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 		if (i == num_pages - 1)
 			err = prepare_uptodate_page(pages[i],
 						    pos + write_bytes, false);
+
+		/*
+		 * When reading the page from the disk, we can race
+		 * with direct i/o which can get the page lock (before
+		 * prepare_uptodate_page() gets it) and can go ahead
+		 * and invalidate the page. Hence if the page is found
+		 * to be not belonging to the inode's address space,
+		 * retry the operation of getting a page.
+		 */
+		if (unlikely(pages[i]->mapping != inode->i_mapping)) {
+			unlock_page(pages[i]);
+			page_cache_release(pages[i]);
+			goto again;
+		}
+
 		if (err) {
 			page_cache_release(pages[i]);
 			faili = i - 1;
-- 
2.1.0

