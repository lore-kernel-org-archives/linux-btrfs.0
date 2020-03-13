Return-Path: <SRS0=6pDE=46=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85620C5ACBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D38E2074F
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cExnlxlz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCMVMc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 17:12:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44433 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgCMVMb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Mar 2020 17:12:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id h16so8843213qtr.11
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2020 14:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=K+1pSzqV4/zQnJjX/QqtA1LtarNMde6WNqPr27gBpoU=;
        b=cExnlxlz8JQ7w2wK1WYVLvSLlRuCsVgtFCRqisjCLZZVotADmW0b00SRbwNDj8yfT3
         wbadY9zbN4G/OTyTnbsSMHDrtwcx8PA0EyfLA7FD4389Fxydwnant8LLHxwrY7VOG061
         smsxHWmmKety/OZ9AEaCiZwwPXFawuU+Aa/4BgBv3eDMKunRvj3dPNd3ga9DV58UVgVs
         /SRwK7ztYeWlZpA5sKAB/9025/vLMlkO0Zhk+g5Nt0UOp1P3eSXFoHeYMtH+3JClQDC7
         dgIJ5RX8Yz6y/NXYTGiWYeHofTkkNwrSTVL28rgXuiXUJBGSSoQ2sh/tkmv3tEPz7W4r
         X0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+1pSzqV4/zQnJjX/QqtA1LtarNMde6WNqPr27gBpoU=;
        b=DxrVvvNZ0u0runzwsz0tXbwAK5VeVsJck1pHQ5dPuY32+i8Kf0kWQIQo0OmcU/d5wZ
         easQt71FMuiTIxOhAh22AaI4e4bAlPDHNWWyEu9hRMN3KnmIYc0a/6ULFvXSZvEoMPDi
         98wPeX8XpVwYTeDHzSWoUfg01v0wXuFUdNZ3kZYNCEcH3jl4DgxMf25MdDlr/M0MX0eM
         mtPScOjgzgyXsFEsniO4w/gjRAIeAsEN4fCtm2ii3u9BOJ2U3A2sCg1beUW7sV7+AOvT
         pJ5T1QKByeC5ABu0LclHACYqGULXZ+PzzivvW/aulymsWwtUpDBLpIHF8mFtP03wHOBL
         LuAQ==
X-Gm-Message-State: ANhLgQ1scVt/n5ECb4d9WzB0qDrQkFzFXEk8bdpCGCNxofgVb64G5IJh
        w036SvuDGoFMr5c+Fa4ad+fYZ0iK45Q3Rg==
X-Google-Smtp-Source: ADFU+vvvsLHN2uDRzkhhN2dbr4SromrdoxJNoV7TMFBU5v+OGJRKLs/UoqVDCM/DU2ssHacRnL2XtQ==
X-Received: by 2002:ac8:175d:: with SMTP id u29mr14886860qtk.150.1584133950412;
        Fri, 13 Mar 2020 14:12:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l60sm9312710qtd.35.2020.03.13.14.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:12:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 4/5] btrfs: run delayed refs less often in commit_cowonly_roots
Date:   Fri, 13 Mar 2020 17:12:19 -0400
Message-Id: <20200313211220.148772-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313211220.148772-1-josef@toxicpanda.com>
References: <20200313211220.148772-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We love running delayed refs in commit_cowonly_roots, but it is a bit
excessive.  I was seeing cases of running 3 or 4 refs a few times in a
row during this time.  Instead simply update all of the roots first,
then run delayed refs, then handle the empty block groups case, and then
if we have any more dirty roots do the whole thing again.  This allows
us to be much more efficient with our delayed ref running, as we can
batch a few more operations at once.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3e7fd8a934c1..c3b3b524b8c3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1646,12 +1646,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		goto fail;
-	}
-
 	/*
 	 * Do special qgroup accounting for snapshot, as we do some qgroup
 	 * snapshot hack to do fast snapshot.
@@ -1698,12 +1692,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		goto fail;
-	}
-
 fail:
 	pending->error = ret;
 dir_item_existed:
-- 
2.24.1

