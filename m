Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56585 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbbJ1IKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 04:10:48 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 28 Oct 2015 13:40:45 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id A00E01258061
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:37 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9S8AeC451183638
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:40 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9S8Ab0g003611
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:40 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V8 12/13] Btrfs: prepare_pages: Retry adding a page to the page cache
Date: Wed, 28 Oct 2015 13:40:26 +0530
Message-Id: <1446019827-685-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading the page from the disk, we can race with Direct I/O which can get
the page lock (before prepare_uptodate_page() gets it) and can go ahead and
invalidate the page. Hence if the page is not found in the inode's address
space, retry the operation of getting a page.

Reported-by: Jakub Palider <jpa@semihalf.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5a7551c..0e54a53 100644
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

