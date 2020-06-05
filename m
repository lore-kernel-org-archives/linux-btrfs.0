Return-Path: <SRS0=RMw4=7S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7A4C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 07:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59049207D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 07:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFEHmN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 03:42:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFEHmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jun 2020 03:42:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B086CAC40;
        Fri,  5 Jun 2020 07:42:15 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 34/46] btrfs: Make writepage_delalloc take btrfs_inode
Date:   Fri,  5 Jun 2020 10:42:10 +0300
Message-Id: <20200605074210.13611-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603055546.3889-35-nborisov@suse.com>
References: <20200603055546.3889-35-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Only find_lock_delalloc_range uses vfs_inode so let's take the btrfs_inode
as a parameter.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
V3:
 * Added extra newline between changelog and SOB line

 fs/btrfs/extent_io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 58a07587efcd..2068a2c38e0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3424,7 +3424,7 @@ static void update_nr_written(struct writeback_control *wbc,
  * This returns 0 if all went well (page still locked)
  * This returns < 0 if there were errors (page still locked)
  */
-static noinline_for_stack int writepage_delalloc(struct inode *inode,
+static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		struct page *page, struct writeback_control *wbc,
 		u64 delalloc_start, unsigned long *nr_written)
 {
@@ -3437,15 +3437,14 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,


 	while (delalloc_end < page_end) {
-		found = find_lock_delalloc_range(inode, page,
+		found = find_lock_delalloc_range(&inode->vfs_inode, page,
 					       &delalloc_start,
 					       &delalloc_end);
 		if (!found) {
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		ret = btrfs_run_delalloc_range(BTRFS_I(inode), page,
-					       delalloc_start,
+		ret = btrfs_run_delalloc_range(inode, page, delalloc_start,
 					       delalloc_end, &page_started,
 					       nr_written, wbc);
 		if (ret) {
@@ -3664,7 +3663,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	set_page_extent_mapped(page);

 	if (!epd->extent_locked) {
-		ret = writepage_delalloc(inode, page, wbc, start, &nr_written);
+		ret = writepage_delalloc(BTRFS_I(inode), page, wbc, start,
+					 &nr_written);
 		if (ret == 1)
 			return 0;
 		if (ret)
--
2.17.1

