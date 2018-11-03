Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8FBC6786F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 08:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FA7F2081B
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 08:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6A35Quw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FA7F2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbeKCRsA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 13:48:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39748 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbeKCRr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 13:47:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id n11-v6so2087440pfb.6;
        Sat, 03 Nov 2018 01:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8h3CNTWPb6Lvcnin7naV/pZKs8madyTgpUWU5jCTMvY=;
        b=k6A35QuwuUANaP/GQh4gfcj0qbVQQhwfiLyLXGFJ3/rXBqWY9SzEZN+SZb/xjdL7nd
         yvzHYuCnMF4VDmrF4VYhtgLz0PUcSCpyozUF/ozYBS7sN2/oNCmGBO8dzTw/5llzHge0
         g+zs/tTgJudZlZLTSSbca2yHxzWwxAYHlEqmZRII+xXznlq6wuGMv2wh2Aart1fhYWH2
         9KlAKLVwrRg+WZbUhr/ZRqYeP5GJFyMFANlMnp1t586dckNDF74yxUuO2u9CRjtknENM
         CzN9WEOq1fSLBLFnmOx8CXOElUbRPuoM1PlJhMweyUUmQgBDAdL1SoTOmTyGHwt1GEH/
         pjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8h3CNTWPb6Lvcnin7naV/pZKs8madyTgpUWU5jCTMvY=;
        b=ov6vceyAT0VN7wSZuIww0KWjpDmi3ZBZsb8rbmg6gUGLQEd8kn/9HAZglCPaUVMCU+
         EqJH6bw2hpSvcEn6PeRg/TGlUR1GBswJZwHCwPMkwmJAJXVlqCZuMHoBm2RDfbIOWN6g
         EAHlUKSQVj4pS2D6AIdYBW4jsYWxhZyWCiUtzFXwM48Lwb3im+IKUBGij4rSZ0NnLb4L
         0nNPkZDQVuaadI7BdZjJR73EXt3t70bWyhFis3MzlOpPzFxvS39bq/KyhQ2I/tkloyy5
         6//cuuoEPfDRSumKUSzOU8kPtCO7riXVIfrES51UxBY0JKZAr8latwTmiGCfqHPDlfvG
         lnNg==
X-Gm-Message-State: AGRZ1gKU/EBiE5+40zdAu2kU6KauFSozehvapapZSq/jgyoiv54AIdSa
        cJF9F2IxVIhquMb703HP4nuPiqZWH+I=
X-Google-Smtp-Source: AJdET5f8PKqu9MmtVC1Jel/xCenFpQwgYs1ipE5KSrPVFviGzB0Cl3s8Xzmy48qrPd/To4PKA9KmEw==
X-Received: by 2002:a63:1342:: with SMTP id 2-v6mr13435345pgt.19.1541234246249;
        Sat, 03 Nov 2018 01:37:26 -0700 (PDT)
Received: from localhost.localdomain ([45.56.155.205])
        by smtp.gmail.com with ESMTPSA id t4-v6sm38185543pfh.45.2018.11.03.01.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Nov 2018 01:37:25 -0700 (PDT)
From:   hmsjwzb <weizhefix@gmail.com>
Cc:     clm@fb.com, hmsjwzb <weizhefix@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Change the total_dirty from SZ_256M to SZ_64M.
Date:   Sat,  3 Nov 2018 16:36:53 +0800
Message-Id: <20181103083654.655-1-weizhefix@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The SZ_256M will cause trouble in platform with less than 256M memory.
For example, a qemu virtual machine.

Signed-off-by: hmsjwzb <weizhefix@gmail.com>
---
 fs/btrfs/tests/extent-io-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 9e0f4a01be14..cb23dce96a2d 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -62,7 +62,7 @@ static int test_find_delalloc(u32 sectorsize)
 	struct page *page;
 	struct page *locked_page = NULL;
 	unsigned long index = 0;
-	u64 total_dirty = SZ_256M;
+	u64 total_dirty = SZ_64M;
 	u64 max_bytes = SZ_128M;
 	u64 start, end, test_start;
 	u64 found;
-- 
2.17.1

