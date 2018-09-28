Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68244C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21547215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zaZsb4n+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21547215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbeI1Rms (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33158 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbeI1Rms (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id i10-v6so6194616qtp.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=zaZsb4n+orpW4Yu7Z22PhRRjFpeRt2pXSJlIdXo2VHDrxjIVFQH37h6TW+5GnXn87Y
         xP7dgM3hQWufP+z5OW2M2aVC2migqv8/4GFzf8cVEp/Fx69rh/Xlq9XCKEngfTjWL3PY
         EjGKiJVwg4Dc+aVRhXDp+CcRHW5A/Wxep38st1VkpLmaGh4TrfILByhtaB2fXasY48Yw
         fgWDGG+f3jzlxAvY1b9nvLV/mXUN+/pK6QY5NTSZyMbYdswllwbfYY7SMvRUEImz3hpR
         +pSiAkq73oID+gPBxDaONVFJ/cQsVC2+inQMVS1/JRSdjti650HVlRTuSigCvZtMAwRJ
         Aiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=SMY+ZsFfs4r2VxgMzSWJcf99Svzv8a4/EvkHYvFC0Mfh0mswH9A8ly5xtX4w8+EvZv
         d6I3EAx4Mz152zGNjTT9qiS5hq/K2wEvREGQUjGC5d/R6z5WOTm5BKPXpfLnonwwAvQ4
         z3tW4jWiDoGsxnRd6WkM6kfeSkcbHv+dwktlaDuRcm5fwqZ1JUgxw38FYoMXevv3V+kh
         zl268roQ2vXorUUuuGhhRnfuzQ+HFF8pu6P/RG+wIm+VOhcs3Ubb/eK5RjpCexJ0GpVv
         VFhzB2QEbhPo6eYROocr+RcmTgMYcRTx5u80+VJZ3AL6t4Qyr5VRlQKniHxwWGGnfxMl
         8SAA==
X-Gm-Message-State: ABuFfogxLjV28Dut5EczFQRp8CpIRqCp4EZIN7NN6MFoenh+S0tiLrak
        0UZ2E0qqOMBoPH5gl9UzzYrOP5uORTQ=
X-Google-Smtp-Source: ACcGV63Gr/06adrxpVKqPZIiHGG+Dcpo/IpRjjWPSmX/VLrPDF4sRf4P+SU3DHj8hSqFwHoRwEA8Xg==
X-Received: by 2002:aed:2807:: with SMTP id r7-v6mr11887644qtd.68.1538133569946;
        Fri, 28 Sep 2018 04:19:29 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b9-v6sm2416296qtp.79.2018.09.28.04.19.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:28 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 35/42] MAINTAINERS: update my email address for btrfs
Date:   Fri, 28 Sep 2018 07:18:14 -0400
Message-Id: <20180928111821.24376-36-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

My work email is completely useless, switch it to my personal address so
I get emails on a account I actually pay attention to.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 32fbc6f732d4..7723dc958e99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3095,7 +3095,7 @@ F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
 M:	Chris Mason <clm@fb.com>
-M:	Josef Bacik <jbacik@fb.com>
+M:	Josef Bacik <josef@toxicpanda.com>
 M:	David Sterba <dsterba@suse.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
-- 
2.14.3

