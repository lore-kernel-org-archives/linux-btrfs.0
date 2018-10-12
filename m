Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CC3C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D469A2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WJbSrUR0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D469A2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbeJMDHZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33482 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id q40-v6so15083925qte.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=PXodpEXCKEY9gKL1VbyQfz/+OWJov9JEkUK4lJNrhOs=;
        b=WJbSrUR069pa+1pwBlv0QiVg2G4G02o12/TKTQ6uHM1K2SwSyoymUNr8CZgn0lIlz/
         +DhuOqXTDKN72d0hr42clHg0fDXRB7m/tNkuCD7nj/L9nPEcEKsycnCiM//vdd6X6A6x
         kKGZ5jsIkMNxPzb00iyUe0N4oHVtxBC2zGFJELIx5KL83XWLov94MD8/cOcvJYlkP7DL
         KgV068OcHFCL2zTAmvR9xzc7xyNdNnwTcWj214qmDqmUOFLVXT7ixuLYjmGf5hS+9ZGn
         /lOVHhmjDURqO3dmKtIPa/0etTzhE/N/hZm3gTUL37b8UAQrIEVJUR2qQS2Dm3+WMAMi
         IppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=PXodpEXCKEY9gKL1VbyQfz/+OWJov9JEkUK4lJNrhOs=;
        b=ZTB/c1sXp7kIO1C0LrCPIZIuzLKmiIKkv9HjIb4pU3zF0rHxo35f0L5uJyKYOLBtgq
         tRWvCEcneSesDsTzeDlLcVbR5x1MDYWAzqWW+i5024TyaCLGWUY7jT9WDaDd7OTH9IsK
         yWFfB1Yv0qzz8B0qph05lT84HRx2bQDlg/j7crpUO67CS3soO+fEaJ8TVsovARhQ09U4
         IEsNmfL13sKKjFHuNSBhcJe2Bz6h9x9c/bnfWmXhk6zIHz1AvqhwaYd2k+TH51kOitJM
         OCpdt0yY5hnhg/nPw39oiaaISPUXGRf+VKknpEQY1962dGOsYMDTj3QPbAksvzzW59v8
         /h1g==
X-Gm-Message-State: ABuFfogqtSiJf84prtAcMDVgNFA2fOdo5I2ylCI5nSIAyKnm52TzmtSA
        tuGZgD22FHJIvHOQzmzkwRh4tpwQwZo=
X-Google-Smtp-Source: ACcGV61U9dz/1XkxYb9I+163Akl2vqfKIxlY/c7e7nA+jveCRuu33AwgDhHUuXhjwS3UB0YbHp0kTw==
X-Received: by 2002:aed:2747:: with SMTP id n65-v6mr7205513qtd.103.1539372804359;
        Fri, 12 Oct 2018 12:33:24 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x68-v6sm966630qkd.50.2018.10.12.12.33.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 12/42] btrfs: don't use global rsv for chunk allocation
Date:   Fri, 12 Oct 2018 15:32:26 -0400
Message-Id: <20181012193256.13735-13-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've done this forever because of the voodoo around knowing how much
space we have.  However we have better ways of doing this now, and on
normal file systems we'll easily have a global reserve of 512MiB, and
since metadata chunks are usually 1GiB that means we'll allocate
metadata chunks more readily.  Instead use the actual used amount when
determining if we need to allocate a chunk or not.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b00c658deb3..828b82db439c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4374,21 +4374,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 			      struct btrfs_space_info *sinfo, int force)
 {
-	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 bytes_used = btrfs_space_info_used(sinfo, false);
 	u64 thresh;
 
 	if (force == CHUNK_ALLOC_FORCE)
 		return 1;
 
-	/*
-	 * We need to take into account the global rsv because for all intents
-	 * and purposes it's used space.  Don't worry about locking the
-	 * global_rsv, it doesn't change except when the transaction commits.
-	 */
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
-		bytes_used += calc_global_rsv_need_space(global_rsv);
-
 	/*
 	 * in limited mode, we want to have some free space up to
 	 * about 1% of the FS size.
-- 
2.14.3

