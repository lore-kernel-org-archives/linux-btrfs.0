Return-Path: <SRS0=KPg5=24=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1273C33C8C
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE18824656
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="VLymX8Gc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgAGQzy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:55:54 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:36882 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgAGQzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2020 11:55:53 -0500
Received: by mail-qv1-f67.google.com with SMTP id f16so145175qvi.4
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2020 08:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HNzBGeTdlhZhaE4b4BtqTOtXUVMvBzVOP9h12TTMqdw=;
        b=VLymX8GcHpUgJAsTeNnVqeDOE6Jj5PFn3SSCKCuvJUCbtg4xebzaleq0uWRHcR4x2u
         eyYY7BS8j7Rostor6jtZtL8KUJE5+NBBiljcmViPjozp19hrOIGskdnRT9y+OT0zXpRG
         1zfqtNV6SzsvmnRtyb0vDwA9G+U9hPxTSYrvQHtxf0I6c0zAG95RkLCWSOWUMtBzP00c
         uNDtgJ16FAtF9It1sGCSIOyb/brtGlK29yfLtqBLZiXbPnuDk8IbzFtn7mlEKHeIzp+A
         q0NERlHYvYTPnbDYyhzO11AVNSB6xqDIyMlhiwalp3KeAtlTibRpWRAg2J/bk/Dd4ren
         M9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HNzBGeTdlhZhaE4b4BtqTOtXUVMvBzVOP9h12TTMqdw=;
        b=egTPx4xC/aeD85zN2ure6KCGWg3m9/2i+m+bEy1/ZO2QrIfs7s+AjIDkrK5t4OC/4u
         Bg89JsEPYmojyq41KypxYoWryWrYupU5JvZknTC1ptcettg8tbCcAwFq7bMyjvRCCQEQ
         RMU3Cv9gqhRs2Gz79heoyIlHMq7q0AX2d2ssyRd6Vg8y1auq3EgNAoCP0gUyKIxUYNiM
         COEDH9wAsNjcHRZJUkywBhEfunIV/U/ahnd2eFHySKVCsryFiB7QdnfWWBgZDf40sNyd
         mCpXimt+aADMIhY6eb7McR4YPOT+hltuBIKYlhMhFDcG0ioNSaem82yah1KPpSVpo4aY
         6yqA==
X-Gm-Message-State: APjAAAX0cn036VRDdXzs8CkcF2uPcu/6hR9CjfjHru/DwmOdg8QzLFoA
        ESouehpeQr8TwyyfyFeOFTH6l25hh45TDw==
X-Google-Smtp-Source: APXvYqxoL+4dVlmv9jxSiR/tkoh++5tjYW2eVDJcfeOvL6S8hnb2+b9QSu1oMr3F8NtlDGk+DiBwcA==
X-Received: by 2002:ad4:4dc9:: with SMTP id cw9mr375496qvb.0.1578416152166;
        Tue, 07 Jan 2020 08:55:52 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w25sm122726qts.91.2020.01.07.08.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 08:55:51 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] ltp/fsx: do size check after closeopen operation
Date:   Tue,  7 Jan 2020 11:55:40 -0500
Message-Id: <20200107165542.70108-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200107165542.70108-1-josef@toxicpanda.com>
References: <20200107165542.70108-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I was running down a i_size problem and was missing the failure until
the next iteration of fsx operations because we do the file size check
_after_ the closeopen operation.  Move it after the closeopen operation
so we can catch problems where the file gets messed up on disk.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 ltp/fsx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 00001117..c74b13c2 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2211,10 +2211,10 @@ have_op:
 		check_contents();
 
 out:
-	if (sizechecks && testcalls > simulatedopcount)
-		check_size();
 	if (closeopen)
 		docloseopen();
+	if (sizechecks && testcalls > simulatedopcount)
+		check_size();
 	return 1;
 }
 
-- 
2.23.0

