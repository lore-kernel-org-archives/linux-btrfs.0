Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5E4C67863
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926D22098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CsGd4MKY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 926D22098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbeJSE0P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42630 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbeJSE0O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id j46-v6so35856991qtc.9
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=CsGd4MKY/m+BPmdLJs1XHbIfFvNHSiitKVVvPPLGWo5GU4tkWD2chfSUrV5zjUnnpd
         MEUkQhixYy33qgfBuHB19UlLntUG7w/9YmUYulSdDJbj9IDIkEvv27avzNxO+ld+Rpcb
         1ujI9o6Iwu5OcYN1l13rg0lrebrNiNCw/UqOPQOsCT68Lv0v1fdwV0hUAAYn6XNSfJ4N
         P5pZU2FQGAX3Trf0a/N1E5HQlDnUmAPue33l0Pp0OwRsnHUU0XbNvmOCnCcNBJWK4HWB
         z9TPDqwvl3zC3f308y+eCt9LAclba0uYOz3mN0EnOEzR/QNHs1iqquFfov2zw8VvRWqJ
         po3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=GFxITkOG5e15+HmVoL2HU3KXD+kLUtwbkYdbzcyCAVyqH6Ssxwihu0zwWxDi8z9V7V
         IlKAri6KxmSXeLVfPa301S2mITg5Qt1i38qobw/5H/PxF9UPlokDt2b4/divnb40yrX/
         JBHTNum1CnOZ64Z8y8ENmKFqrOGwCo+Uce3UH37mhCk+2GEM054J1c3PGOwmwvYRWI4H
         i9YkNmEf3UD2OyIvvkYJ43a78B2kKqcFrUVstnDQfftBn3Yvd50HMO7DHZ5GGs0DmtZq
         2mVKSq2nnugPNDhsa1U9yvLgdH7Ibvfld9crqKts7KZagMuE7wF/AuihyK/Xp9Z0MTan
         Jfbw==
X-Gm-Message-State: ABuFfoj8hMCM4nkuPtCBdIAjL9VsKSmkYHnjej3P+BoLtVxNlseFPL5n
        Qh9M2YhQOnmQZGv+K9WarWmmdQ==
X-Google-Smtp-Source: ACcGV630Z4wH07uH115hll3vDXkYV06Zr9DVywG5L0C4yssKYm3wAfDGCW8PcK+V6OEPe9bJVZ2VLQ==
X-Received: by 2002:aed:2791:: with SMTP id a17-v6mr30183020qtd.303.1539894212661;
        Thu, 18 Oct 2018 13:23:32 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n3-v6sm13614949qkc.48.2018.10.18.13.23.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:31 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 3/7] mm: drop the mmap_sem in all read fault cases
Date:   Thu, 18 Oct 2018 16:23:14 -0400
Message-Id: <20181018202318.9131-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181018202318.9131-1-josef@toxicpanda.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
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

