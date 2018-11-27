Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B987C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B7B20989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q0rzomaU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7B7B20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbeK1BMw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 20:12:52 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42953 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbeK1BMw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 20:12:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id 64so8423357pfr.9
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 06:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ld3ZaRtuA1WfvLAtswQ1+vh7E6szJa3KMqxFidBdPQw=;
        b=q0rzomaURq5ROkTXhXXloOQiP76+BoTdZMJg5WRt1X/ar88vzg7w8NkXiBHqhCDe86
         NoiuAH12KONi+Y836XRFTPZBenIqCVJC7d5wjxGyWv9APhsw5W6qkYCe23N4rR0tnEZL
         t3V7BMn60gGtcY2nzB/qbwrCAC0suU3WJZ6sODpZg31jlvShw6ej/nAGhf6NFRc5OUIU
         zAqhvnUiI26KxlP23PWyG+377EeqMWmzgfOYPPW7UY9ws7QChQ0YvdGSKbl/MA3yM/Jy
         gCrvNL4eswTWr2jxNAZBoDYUHDbw0kXDSnqoaiG3qha35CwTPlLgjMqp8nuVDSCudTH8
         HEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ld3ZaRtuA1WfvLAtswQ1+vh7E6szJa3KMqxFidBdPQw=;
        b=gXzGTuY9cZIMUrATWMMQhMHsfg08yrj4dhV6+4Jz43LQrUDZFnL3gQg+/NonbqUbgP
         HH4q4O6XsENtNMWEfsm45gEwn+KxxUoloHNC+hQmzXhtRbt87q8crQjSiur5fe+Qvy6P
         4rq+t5otCaH41K3ZYa0MOJo4ZIptTuIvuGKlPNJ6Dy1DHn4srNNXwKXK7qNxlMJ0zIak
         WmuibvEEeUVT4hClGiK/WMzKHPW2ywRUU2ngNaA/HCHG+sGSCAY9j/NWr4cov9Q4URqj
         4dm4nLn/Sw+m3AcpjqqAwMdt6UXKGAOwWTYsf4jpRmrGKSkY0Stmo+Elz7hw6y1HL/Gy
         G3kQ==
X-Gm-Message-State: AA+aEWbgBXxpRa32rZVC8ChPiRAYRNgWclaXGpXvsxhYuRVnBrYv6G5g
        6BD1nF+Znb90CHjBzED5qqqzI+SfBrg=
X-Google-Smtp-Source: AFSGD/VxPSVSDq89GAN/ccZSayaY6qC6KdYOFQe5yCDcLpsaBwMClRMeJBDgGS6rd/381eLlhtXmsg==
X-Received: by 2002:a63:d005:: with SMTP id z5mr29209482pgf.64.1543328088477;
        Tue, 27 Nov 2018 06:14:48 -0800 (PST)
Received: from localhost.localdomain ([185.197.228.4])
        by smtp.gmail.com with ESMTPSA id k14sm12474447pgs.52.2018.11.27.06.14.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 06:14:47 -0800 (PST)
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     linux-btrfs@vger.kernel.org
Cc:     Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Proposal for more detail in scrub doc
Date:   Tue, 27 Nov 2018 15:14:37 +0100
Message-Id: <20181127141437.24744-1-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 2.20.0.rc1.28.g8a4ee09a8a
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Wise words from Qu:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg82557.html
---
 Documentation/btrfs-scrub.asciidoc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index 4c49269..1fc085c 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -16,7 +16,8 @@ and metadata blocks from all devices and verify checksums. Automatically repair
 corrupted blocks if there's a correct copy available.
 
 NOTE: Scrub is not a filesystem checker (fsck) and does not verify nor repair
-structural damage in the filesystem.
+structural damage in the filesystem. It only checks csum of data and tree blocks,
+it doesn't ensure the content of tree blocks are OK.
 
 The user is supposed to run it manually or via a periodic system service. The
 recommended period is a month but could be less. The estimated device bandwidth
-- 
2.20.0.rc1.28.g8a4ee09a8a

