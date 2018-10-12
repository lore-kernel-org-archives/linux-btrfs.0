Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43408C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D5592087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sSc9ygjJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D5592087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbeJMDHw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46516 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJMDHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id d8-v6so15041765qtk.13
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=sSc9ygjJPsMtOsf7c2ES0lIvSLUj1HHBm0ojY9Iy6SNHSazo9rROwR3Ouh3eZvM6KM
         BPpnvSgIL9TFNa319KAb5Osciyhl9bOW9WT2ZmP3FIKNfkQMJUqmFzI9oF8Q64DY0ifl
         /wd3rFilAVpIH16Nn8Fj/budwb3zft/SehmD/Z8Z5PHxHBCBSEDYbfs4ludiEkLxe1j/
         7DVvSe4ZboKAx2U7PDnrbco+cWYfWqdM0f75g6KQnqro2yucwWcqAaCLnIb1GfzSu0AJ
         fcQa32UGBI94XdWDyNa5CUJY5MSiDXl3ZC7JaCzHLhGAEkJz6K+6K9Nj8Us3YrWOytjw
         n9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=CJx0XrMgaseYCPdcR27dNkX+iDhA8gQom5246W9UlhwCTH10L692ujjj96VbRZOVYt
         su0P+vQIdf+YFMbZGJ7WrZqrQILOffAtJRklvqm5at2r+UJVIc8pXdNW9GVKvpccpRD+
         /l+sNXbrM4PaS877yix0UwRzJ7FpkWRhuxowo8ZqaufUzmM8iRcFYrAlhP1NmpUl5vYs
         7SSX8r2GL+pBlZO7aAUxP1gPXt47uFxVul1vFotPAVuNtqcgSq5lVHu3zACtk1XArnUB
         4A/N+D/u9d38beMBKiQ0wTZ90fmCzI3lhrEk03ApC7JTtostRKhz0fwPv62aT9+8ko8z
         gLPg==
X-Gm-Message-State: ABuFfohs2DrzxQmZCe/IzBU0FcFXdTbnYiRvJ1C+8CUPWNxGzE/mPkoL
        4swld2iEPmQjA4KvEpLLauY44yA3WXE=
X-Google-Smtp-Source: ACcGV62ukNDpYosL8wAQAoqyQEojcp4Ct2EBZ21EhME99X2WLEWA48x688fReADXzFOXOIHM/U+lqA==
X-Received: by 2002:aed:3807:: with SMTP id j7-v6mr7181883qte.140.1539372830771;
        Fri, 12 Oct 2018 12:33:50 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y51-v6sm1486841qth.66.2018.10.12.12.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:49 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 22/42] btrfs: only run delayed refs if we're committing
Date:   Fri, 12 Oct 2018 15:32:36 -0400
Message-Id: <20181012193256.13735-23-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I noticed in a giant dbench run that we spent a lot of time on lock
contention while running transaction commit.  This is because dbench
results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
they all run the delayed refs first thing, so they all contend with
each other.  This leads to seconds of 0 throughput.  Change this to only
run the delayed refs if we're the ones committing the transaction.  This
makes the latency go away and we get no more lock contention.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a0f19ca0bd6c..39a2bddb0b29 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1925,15 +1925,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	/* make a pass through all the delayed refs we have so far
-	 * any runnings procs may add more while we are here
-	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	cur_trans = trans->transaction;
 
 	/*
@@ -1946,12 +1937,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
 
@@ -2022,6 +2007,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		spin_unlock(&fs_info->trans_lock);
 	}
 
+	/*
+	 * We are now the only one in the commit area, we can run delayed refs
+	 * without hitting a bunch of lock contention from a lot of people
+	 * trying to commit the transaction at once.
+	 */
+	ret = btrfs_run_delayed_refs(trans, 0);
+	if (ret)
+		goto cleanup_transaction;
+
 	extwriter_counter_dec(cur_trans, trans->type);
 
 	ret = btrfs_start_delalloc_flush(fs_info);
-- 
2.14.3

