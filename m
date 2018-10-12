Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB23C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258182087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="2HFFGqV0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 258182087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbeJMDIK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:10 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37584 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeJMDIJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id d14-v6so15064398qto.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=2HFFGqV0bAxAaOijWNshjE6G/88Qxic6X1sRVPFM+yr2ufTDIVKOfskbiPZF/jySdz
         ioCEJkxvsbJxF2+O3+6IuZmmgRmh1DGvTb++EBLly2oZwBu9ebl6Aq+ij+2G18UxwTpW
         gQDxJ2BTF1xv0EXfe2y0A4W/0p5fHzem58OMrAQypH9+lZGinkFEjKhWbCkYUPrpIfaz
         2gMNvkLcEYQSd24IM+h08M8roeqzxFWNdTdHk4Or/aW/srvTvDnDDdCdYoqe90Fc+1Dw
         TzWesY1YZpDzFPCyPLhTZ0/xyt3j7g8jm9uDa5AOXZIhPoYsZvMBMwa3I3Vg/DexSSlp
         haTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=QERhAsMuwPK+AdAwyJj72omT/Nm4pA3YfB3zJfJrnZeoCC/vs4VVn+wF5x2ZAK0fcl
         VKWz1TMG7dENTR6O5iCz2vpXvpeMvf2RjMQMgon+D/N7voBOJEuOT3d+n6H1udjkE+P3
         bjvwDINO8SqBjxMN84FxdciPyP2I+9/VlI0jFQ3TJcw8hNIKl28hsQF8tesxYfRn/zrx
         uRfnwgun0iNWm6e1jC0eQm6P8WgYGRqSEPt5BN28t8biTPJJcU++LEReC8O/yuHNZInd
         p874mIPHjNItgZ8MK8D0kJ8C4fS+fgPArI8YBPXtha/G0u8dUxFC4PXj7iqz3q2Bcw5s
         dKrg==
X-Gm-Message-State: ABuFfogSl1C9LW9xnxvGtCZ1QzehGQN7Y9k09WuaPAC+yJI8tyS/jJNQ
        1KV9kZTGQ0Br72D9MjzESP94IvDszHI=
X-Google-Smtp-Source: ACcGV602pW3005r1d1Qjhbenv9cdAaQ+RxK/U/137oG2v4HcE4dc6zI8aO6FzXq3EQbvdoCQuF/D3w==
X-Received: by 2002:a0c:fd8c:: with SMTP id p12-v6mr7104537qvr.198.1539372848521;
        Fri, 12 Oct 2018 12:34:08 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b134-v6sm1519145qka.45.2018.10.12.12.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:07 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 31/42] btrfs: cleanup pending bgs on transaction abort
Date:   Fri, 12 Oct 2018 15:32:45 -0400
Message-Id: <20181012193256.13735-32-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We may abort the transaction during a commit and not have a chance to
run the pending bgs stuff, which will leave block groups on our list and
cause us accounting issues and leaked memory.  Fix this by running the
pending bgs when we cleanup a transaction.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 46ca775a709e..9168efaca37e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2280,6 +2280,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans);
+	/* This cleans up the pending block groups list properly. */
+	if (!trans->aborted)
+		trans->aborted = ret;
+	btrfs_create_pending_block_groups(trans);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-- 
2.14.3

