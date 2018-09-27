Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CEBC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08C5A21708
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="VggOzRkq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08C5A21708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbeI1Ahk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:37:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33666 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbeI1Ahj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id y18-v6so2564635pge.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4GS0rtTAw8MP4uDvktXudPbNVsZwrCDwQldL/U9M54=;
        b=VggOzRkqnjAoxcTrgosJ7WEGAFqFH0snDqnyDhIcppWn+qtwX6981iZlumlrBU65Pn
         +idBw9olDHPvcYryEG4dLrim8b/McRQF6ZckDOfsv0F3Ua21HwkPV99ducvE99NmIba7
         cEuESyueeoYlXsyutl3vrhC/0YlrkW4wf1QkP4y/USOQU+otwVJ19GgBXZRMgz9ty6Tx
         pUe88OlM0Ngc4cTVGtNFs6Sfos+7hCTyIPtS+NfY+IuCft7P3sQreNfoMHMDZbMpHgqV
         ST6U0ypv25SGQs4F7DjXiY5PxdEF4uE7mXG5nKRMS9zzcK8btTSWSTrbj0CLRAmzrg48
         8DlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4GS0rtTAw8MP4uDvktXudPbNVsZwrCDwQldL/U9M54=;
        b=W2Ig+dw+MAkW9UP0DDPKhtzVQjGELe73ZxmIVtz5DyhhbmgfEnkN5/ltF5VOSWhiGH
         H/A09rP5hcw3qFdP0bH2jRix6gPY2TsqoTaqJd1hpcXCUTHEPcqdHumG0V4gM3b5JcTS
         MtVsZlwXu8Jf7KNGpyuMxKyg9RvuLVqvecpSCk8IpOEacb3ClR+kxpPB9gQ7fKXYFFW7
         rFa0V/cM20qXBDd5HH5G7JqlGDXe4r+X3IwRSD+VikFNff2wJaYT7iV5HHSFGK8cjZy3
         heaWzZjiPT0IlweO00HiJgis218m2ayctrPLfuz7Ql4O+gomkOnxgF6rzgglAvrVvrdf
         G5eg==
X-Gm-Message-State: ABuFfoiPa+2uGrbGcrDn0aZgEuHnP9+Fqj9aavRSEkbc3/Mv3rET7Xs9
        a/MBYq2HIEhmg9j3IjD9OTH8OdSRCzw=
X-Google-Smtp-Source: ACcGV605PP43xzxTBdNtYCCeoIvGq/Fty4vz67jZQZ4pVYqsg+Z6Kh9eUn/2ueCVN+HFl1+Bj5LdGg==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11-v6mr12563943pls.12.1538072287902;
        Thu, 27 Sep 2018 11:18:07 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:07 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v9 1/6] mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
Date:   Thu, 27 Sep 2018 11:17:33 -0700
Message-Id: <0f83d16b8f1fe8452a84886b4e206c3146711fe8.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The SWP_FILE flag serves two purposes: to make swap_{read,write}page()
go through the filesystem, and to make swapoff() call
->swap_deactivate(). For Btrfs, we want the latter but not the former,
so split this flag into two. This makes us always call
->swap_deactivate() if ->swap_activate() succeeded, not just if it
didn't add any swap extents itself.

This also resolves the issue of the very misleading name of SWP_FILE,
which is only used for swap files over NFS.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 include/linux/swap.h | 13 +++++++------
 mm/page_io.c         |  6 +++---
 mm/swapfile.c        | 13 ++++++++-----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8e2c11e692ba..0fda0aa743f0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -167,13 +167,14 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
-	SWP_FILE	= (1 << 7),	/* set after swap_activate success */
-	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
-	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
-	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
-	SWP_SYNCHRONOUS_IO = (1 << 11),	/* synchronous IO is efficient */
+	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
+	SWP_FS		= (1 << 8),	/* swap file goes through fs */
+	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
+	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
+	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
+	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 13),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/page_io.c b/mm/page_io.c
index aafd19ec1db4..e8653c368069 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -283,7 +283,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -365,7 +365,7 @@ int swap_readpage(struct page *page, bool synchronous)
 		goto out;
 	}
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -423,7 +423,7 @@ int swap_set_page_dirty(struct page *page)
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d954b71c4f9c..d3f95833d12e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -989,7 +989,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 			goto nextsi;
 		}
 		if (size == SWAPFILE_CLUSTER) {
-			if (!(si->flags & SWP_FILE))
+			if (!(si->flags & SWP_FS))
 				n_ret = swap_alloc_cluster(si, swp_entries);
 		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
@@ -2310,12 +2310,13 @@ static void destroy_swap_extents(struct swap_info_struct *sis)
 		kfree(se);
 	}
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_ACTIVATED) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
-		sis->flags &= ~SWP_FILE;
-		mapping->a_ops->swap_deactivate(swap_file);
+		sis->flags &= ~SWP_ACTIVATED;
+		if (mapping->a_ops->swap_deactivate)
+			mapping->a_ops->swap_deactivate(swap_file);
 	}
 }
 
@@ -2411,8 +2412,10 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 
 	if (mapping->a_ops->swap_activate) {
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
+		if (ret >= 0)
+			sis->flags |= SWP_ACTIVATED;
 		if (!ret) {
-			sis->flags |= SWP_FILE;
+			sis->flags |= SWP_FS;
 			ret = add_swap_extent(sis, 0, sis->max, 0);
 			*span = sis->pages;
 		}
-- 
2.19.0

