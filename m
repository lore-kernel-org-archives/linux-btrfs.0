Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48CFC43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE1720C0A
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DEmAPLzk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FE1720C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbeIYVi0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:38:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36988 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbeIYViZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:38:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id n6-v6so13785705qtl.4
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 08:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=DEmAPLzkrPKAHv0xbTFGpZ6jamzlToLR/cRumBykBnmJoZyUpkUvG6gNwTXEEEvyo9
         FzeLKBbs0BBVsDOCDYe7Z+Kt3M7PelIG7cQnsJ+iLSS0Q0hbOoLbqqKjMD25QmSZj3z5
         6K56i3YJEvNJ7B6CpBPv1+KXW2xSGvgAYAbgPmw5fsr4RGI9WsKfIyWFaBWMxqTcB0OR
         40CUFcmwjK6YV/Uz6Lh4a6RxyGCPOE7GNqcdPm7xXuxJ5VknZBe8xNgSQakCklIAM9Y9
         M/tXW7YerwILLQKONWAtGoKLqcTvBtzmBwY/IzR3jcvURZQglkbsM/g/KgB2NiS5a0ov
         vVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=fxF9egp/0MfNC6eP3oXuHL949t8miVwsCl5P35THCQ0=;
        b=OSM+0ZSExmeNi7/C54X8LaxIjdDECF1L0oCsEjCKFrQePaNAyWY4TYJJNGn3ijZGqI
         qV4vTZsU9lggauZ+nJne/ByvWq7Qkp3JaPAA6Q9kvXVYwmKn8f8i8GZxCMUhbiX1cnc2
         hksaX1dO8GhnwqN16/RkZCjtyt3zIxmR/iCtkV2Y5O4sLt5hAzIOL8yAvaTKj0+ucYE/
         UPUYcGyYYk2S1WztvWwmIszHJW1pKA3vGnX4tPapu+rrO/MScJFltXJHtWTs7tvRh3Ye
         bc5tpYL6vV7MZ/6f3OpdCjfHAuNQPfi51KtKY3/IcXflPMj27ItbYuGwIV+MhgUtNZ5T
         7UwA==
X-Gm-Message-State: ABuFfohxqq9X4wtCK5lduA5SVZ0YpeVZv6u2rB/cDXdaQlHiNw6j/QNR
        taFBB/bTIUXnta0h2iZJE10h5w==
X-Google-Smtp-Source: ACcGV636ILuqRfdWOg/6E/YNgwltlS2o+vJZwooGLdmWZ+ffN3YpnBW1fp9l4X+RFEOUrIOJ5hu2bA==
X-Received: by 2002:a0c:acad:: with SMTP id m42-v6mr1166622qvc.27.1537889423820;
        Tue, 25 Sep 2018 08:30:23 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o2-v6sm1965827qkl.63.2018.09.25.08.30.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 08:30:22 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/8] mm: drop the mmap_sem in all read fault cases
Date:   Tue, 25 Sep 2018 11:30:08 -0400
Message-Id: <20180925153011.15311-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180925153011.15311-1-josef@toxicpanda.com>
References: <20180925153011.15311-1-josef@toxicpanda.com>
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

