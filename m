Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37293 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbKPHHb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:07:31 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 17:07:29 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id D2E822CE8052
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:26 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG773ir27590730
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:11 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG76rFQ031059
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:54 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V9 12/12] Btrfs: prepare_pages: Retry adding a page to the page cache
Date: Mon, 16 Nov 2015 12:35:32 +0530
Message-Id: <1447657532-9393-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 7c97c78..f0f3a189 100644
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

