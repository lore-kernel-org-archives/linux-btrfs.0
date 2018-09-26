Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B96C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 100A720779
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xOG6WUhz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 100A720779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbeI0DYB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 23:24:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42152 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbeI0DX7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:23:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id w73-v6so275504qkb.9
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=xOG6WUhzNHnJDZ8nzE96i5QNtT6Li8Q5zD7JZrUCY2qx9cUIzLHEP5+zgNwBSUtFyp
         Vsfjd4p80uZmD0X8I4mjGdoXPyZvnafq7f/RBkRbGjEddLbwCS/WwDEsPVkieZMO3WT7
         9GYB6qMA/ROB+5KW8+jhZX3ScR0o+/oJHMadB8CL19veYAyrsYcy3UDgvQdXAdmVLpkp
         3Lih8/OrYQEWboL0v9vg8SCRCFeaSEwiqoZebAIL5B0MyFM2arHx3endVqpa2rnLVSFF
         n40P6Ou4BESYXohRryM+Ny3UOyY2G+mJqJ3eWtgKvm8hpnmXLoKe2UZSeAxwErLr5ICk
         dqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=Zqbm2jOSDhoiCSoAz8pkPHS6kbkZ2koTk4txSXkNf8CiAKYYfoSM+5JhcX+IVu1Oem
         rRtJcvnb6Yi16u0uH6JV9JG41944BgHcJSFGrQuXoJqCN5SfvFtKTHsGp0scq3k0iuRP
         ddjSNvgo8LMlF/OePu9mksQxrq32m+BzmGLs3oq/wkkXNQ6JHo/q7zwVLCi7CTuO4+hH
         cepxZwgOTYgamEbk7Jn83EJOZZCMaSOAWxmebtFQgkSFBukwruUQ9H7lgjUgGKGrR86v
         UQfVTPT1A+OfpuuJrLnfrfSR97SFBcF6F72WrVGqaLWthtWlii6aREfE+rZoeKnUIeVD
         cfOQ==
X-Gm-Message-State: ABuFfohn7rFWv9OMmrRSFItfO0wX8ZcJijKr6vkF1Y4p1EvI0dTsBQte
        P4sshpDNvEvPrtaP50siyBlWYw==
X-Google-Smtp-Source: ACcGV62wZZcLGsIgIA0AgxrBDu/rXm6AEl8TqHyyC/dL/kabdkKJb3x4NckjbVpljlp6VQXrWxsz0A==
X-Received: by 2002:ae9:e892:: with SMTP id a140-v6mr5494846qkg.242.1537996148385;
        Wed, 26 Sep 2018 14:09:08 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o7-v6sm50246qkc.67.2018.09.26.14.09.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 14:09:07 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] mm: drop the mmap_sem in all read fault cases
Date:   Wed, 26 Sep 2018 17:08:52 -0400
Message-Id: <20180926210856.7895-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180926210856.7895-1-josef@toxicpanda.com>
References: <20180926210856.7895-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Johannes' patches didn't quite cover all of the IO cases that we need to
drop the mmap_sem for, this patch covers the rest of them.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/filemap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1ed35cd99b2c..65395ee132a0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2523,6 +2523,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	int error;
 	struct mm_struct *mm = vmf->vma->vm_mm;
 	struct file *file = vmf->vma->vm_file;
+	struct file *fpin = NULL;
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
@@ -2610,11 +2611,15 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	return ret | VM_FAULT_LOCKED;
 
 no_cached_page:
+	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
+
 	/*
 	 * We're only likely to ever get here if MADV_RANDOM is in
 	 * effect.
 	 */
 	error = page_cache_read(file, offset, vmf->gfp_mask);
+	if (fpin)
+		goto out_retry;
 
 	/*
 	 * The page we want has now been added to the page cache.
@@ -2634,6 +2639,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 
 page_not_uptodate:
+	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
+
 	/*
 	 * Umm, take care of errors if the page isn't up-to-date.
 	 * Try to re-read it _once_. We do this synchronously,
@@ -2647,6 +2654,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		if (!PageUptodate(page))
 			error = -EIO;
 	}
+	if (fpin)
+		goto out_retry;
 	put_page(page);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)
@@ -2665,6 +2674,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	}
 
 out_retry:
+	if (fpin)
+		fput(fpin);
 	if (page)
 		put_page(page);
 	return ret | VM_FAULT_RETRY;
-- 
2.14.3

