Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985F6C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 13:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B2120870
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 13:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="DtzrIPdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfA2NB5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:01:57 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:47001 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfA2NB4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 08:01:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id f5so14503742lfc.13
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 05:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptpn3ooISk+hbFBLcoiG4r9S5KcxBa6gl30Hi3aaOSA=;
        b=DtzrIPdrwzNCvJTkAlDg+esBhfR6wT+6BmY7B/Dk47Ve4iJQxHsbc08iYO0fToIPei
         9DXs+HO/GPR0adLGeFj634r1xIKP787DaT2NTSX1++rLXKWonQwE7lW73MEkGw1nPi3x
         pTeYQDY+Ts2l2/JpF+jcoAY5fJ15+fQCQGZco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptpn3ooISk+hbFBLcoiG4r9S5KcxBa6gl30Hi3aaOSA=;
        b=bk4uz0eLHEBZi1io2E/7z5vKV7jhcIT5zpUOWkxtDzdWh4wcV6bQGm/csgBNGt7laY
         ujb4NnziVURtra9jxskgOQljn0a95sOzhaBuKh9akl9bSnhWmlWzeMftDEDlx0zyavnM
         TwwQDFQ7eX7j+0UUlbaDJxA3upuF4uUpCOMlCU5VPWeM1wmYXGDfzyQY39prNnoSkUZQ
         A4YxunrutWLNTSELpQJ8Fu3qfEbQpkZlVr146FswnsLsDbHo7dN1+zkPFO0ID09sfA4B
         NUQir3nx/BMUFvcnH4mFFIi6GzhR5P3uBPqkIdZ4zpoypBPrMdA6zf3MhoKkoRQuYe+K
         Lz6w==
X-Gm-Message-State: AJcUuke71O8j0tamurwFawFCJ2vDj9OUHfygeZbcvYXi9G/8jQQ2mAr9
        L+syrYOVQZMtVlqiRtU4PhH0Dw==
X-Google-Smtp-Source: ALg8bN4BMPopXnF5/hPiXcfRQVBjG6Ho5TBz4wZWrSK6WbzYOudIxy7Uel6KiDkFFmuUUhWZFddcmw==
X-Received: by 2002:a19:c995:: with SMTP id z143mr19626325lff.79.1548766914500;
        Tue, 29 Jan 2019 05:01:54 -0800 (PST)
Received: from localhost (c-573670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.87])
        by smtp.gmail.com with ESMTPSA id 15-v6sm3969541lje.18.2019.01.29.05.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 05:01:53 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] btrfs: relocation: fix unused variable
Date:   Tue, 29 Jan 2019 14:01:46 +0100
Message-Id: <20190129130146.11934-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When CONFIG_BRTFS_ASSERT isn't enabled, variable root_objectid isn't used.

fs/btrfs/relocation.c: In function ‘insert_dirty_subv’:
fs/btrfs/relocation.c:2138:6: warning: unused variable ‘root_objectid’ [-Wunused-variable]
  u64 root_objectid = root->root_key.objectid;
      ^~~~~~~~~~~~~

Reworked by adding a runtime check in the assfail function instead of
the '#ifdef CONFIG_BTRFS_ASSERT #else ...", so the compiler sees the
condition being passed into an inline function after preprocessing.

Fixes: 7b837199c581 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 fs/btrfs/ctree.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index de23a7ea396d..ad7d079f2cae 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3521,21 +3521,18 @@ do {								\
 	rcu_read_unlock();					\
 } while (0)
 
-#ifdef CONFIG_BTRFS_ASSERT
-
 __cold
 static inline void assfail(const char *expr, const char *file, int line)
 {
-	pr_err("assertion failed: %s, file: %s, line: %d\n",
-	       expr, file, line);
-	BUG();
+	if (IS_ENABLED(CONFIG_BTRFS_ASSERT)) {
+		pr_err("assertion failed: %s, file: %s, line: %d\n",
+		       expr, file, line);
+		BUG();
+	}
 }
 
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
-#else
-#define ASSERT(expr)	((void)0)
-#endif
 
 /*
  * Use that for functions that are conditionally exported for sanity tests but
-- 
2.19.2

