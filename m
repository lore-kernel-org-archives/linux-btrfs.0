Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6F2C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 07:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39CCC21850
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 07:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbeLSHuY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:50:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:33876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727252AbeLSHuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 02:50:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B44BAFB4
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2018 07:50:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Make first argument of btrfs_run_delalloc_range directly an inode
Date:   Wed, 19 Dec 2018 09:50:20 +0200
Message-Id: <20181219075020.18748-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since this function is no longer a callback there is no need to have
its first argument obfuscated with a void *. Change it directly to a
pointer to an inode. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
David, 

This little fixlet could be folded in
6907b1c2ac72 ("btrfs: Remove extent_io_ops::fill_delalloc") if it's not too 
late. 


This could be folded to 
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2dc94698c2fa..f681c49a46b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3256,7 +3256,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    struct btrfs_trans_handle *trans, int mode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
-int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+int btrfs_run_delalloc_rangei(struct inode *inode, struct page *locked_page,
 		u64 start, u64 end, int *page_started, unsigned long *nr_written,
 		struct writeback_control *wbc);
 int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0b9855c2df21..63ad72c48ace 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1586,11 +1586,10 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
  * Function to process delayed allocation (create CoW) for ranges which are
  * being touched for the first time.
  */
-int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+int btrfs_run_delalloc_range(struct inode *inode, struct page *locked_page,
 		u64 start, u64 end, int *page_started, unsigned long *nr_written,
 		struct writeback_control *wbc)
 {
-	struct inode *inode = private_data;
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	unsigned int write_flags = wbc_to_write_flags(wbc);
-- 
2.17.1

