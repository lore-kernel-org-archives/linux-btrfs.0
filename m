Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9C3C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DF920657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2DF920657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbeKAVMj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:45986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728369AbeKAVMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89DC4AC8C
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:56 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/8] btrfs: Remove extent_io_ops::writepage_start_hook
Date:   Thu,  1 Nov 2018 14:09:47 +0200
Message-Id: <1541074194-22227-3-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This hook is called only from __extent_writepage_io which is already
called only from the data page writeout path. So there is no need to
make an indirect call via extent_io_ops. This patch just removes the
callback definition, exports the callback function and calls it
directly at the only call site. Also give the function a more descriptive
name. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     |  1 +
 fs/btrfs/extent_io.c | 23 ++++++++++-------------
 fs/btrfs/extent_io.h |  1 -
 fs/btrfs/inode.c     |  3 +--
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dbeb5b2486d5..8e73301eaa65 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3189,6 +3189,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 int run_delalloc_range(void *private_data, struct page *locked_page, u64 start,
 		       u64 end, int *page_started, unsigned long *nr_written,
 		       struct writeback_control *wbc);
+int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e6191aa25f3..c5c713ebb9b1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3321,20 +3321,17 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	int nr = 0;
 	bool compressed;
 
-	if (tree->ops && tree->ops->writepage_start_hook) {
-		ret = tree->ops->writepage_start_hook(page, start,
-						      page_end);
-		if (ret) {
-			/* Fixup worker will requeue */
-			if (ret == -EBUSY)
-				wbc->pages_skipped++;
-			else
-				redirty_page_for_writepage(wbc, page);
+	ret = btrfs_writepage_cow_fixup(page, start, page_end);
+	if (ret) {
+		/* Fixup worker will requeue */
+		if (ret == -EBUSY)
+			wbc->pages_skipped++;
+		else
+			redirty_page_for_writepage(wbc, page);
 
-			update_nr_written(wbc, nr_written);
-			unlock_page(page);
-			return 1;
-		}
+		update_nr_written(wbc, nr_written);
+		unlock_page(page);
+		return 1;
 	}
 
 	/*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ca48187b86ba..4275a1061f5a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,7 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(void *private_data, struct extent_state *state,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aa6d6b64a70a..5c07c6f9f7db 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2154,7 +2154,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
  * to fix it up.  The async helper will wait for ordered extents, set
  * the delalloc bit and make it safe to write the page.
  */
-static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
+int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -10523,7 +10523,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 
 	/* optional callbacks */
 	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
-	.writepage_start_hook = btrfs_writepage_start_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
-- 
2.7.4

