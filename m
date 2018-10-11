Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C78C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33C820835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vLn//Hym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D33C820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbeJLDYC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42712 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id g20-v6so6257315qke.9
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=vLn//HymRhBz3ifqOuzuMIGbc82nV4RZ0mhv7FUNJ79nXMLHvyz4dnPZlfweaBnr5X
         otc8UZxKhk4fIa/PoBx7xNFxW1zFDqS66F+X7Y5oV9gplaO8JHHHn+2xfZN6NXYdbICW
         0RuonW5nrnyLrnCwNB4yra/2QkU1+dbgAly3c+Ng3MGH19SQ+6OOQQYnRtj0xIKaa1OB
         qPQJEEEAJybQAyLsJlnvjcLJi3AGpaF181l8f6EvS6CB8vcMd0fgzjluSgV2jBQALJDI
         ER+lZc6s7yHXkyWbPyXC/Bp39B8O35vYK+W4/sKk6enepa1AkBK5GGrtzffh2nZ1/nuB
         /IvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=eeTSbgi2j2ruWkMPMeqc7+NkqohI/skXBeBmdSbWreur26Uuw3B51OzcDjqYxhR7Q4
         GWua69SmjujKRwfdbZxJLOlMqTuc3GCGpbjIEO+IOo5j7/+qzicbSkN7e6tCGFwoA99W
         /mUuQiEVQTonqDzSwCCI5R0rNcbu/65EuA+/xowmJVbf3acYpCiGkIZzChSS7dVEYSZ7
         hAsf62Y4SYf7HGsUQzEbxz8owtyNtidXCmP4OMhemaeM7xxvyWwBbxCYtHU7hKzbyiTq
         gT2UZGF+fxNxGIg8myZKlyZrBSNa82ZiJ7jzvI5ZZMzBtdfcpUdtLqoTsj9LqyPhJhk0
         xQuQ==
X-Gm-Message-State: ABuFfohjQOS7+oIFPMCTiJmhg89GC8dnAg8UUmDDBkcBfXLQkH8uHcJu
        JikekWf3I3Iht3w7jHjzAazFg3mt9D0=
X-Google-Smtp-Source: ACcGV60TVXcO1Yz1E/Ay4q8njlMOAVJ2dPzprdmsvUgonzMBsIIve6ZGBk9Zm+nXNZqfODLXYqhAVA==
X-Received: by 2002:a37:f8f:: with SMTP id 15-v6mr3006273qkp.300.1539287715636;
        Thu, 11 Oct 2018 12:55:15 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x191-v6sm13929123qkb.93.2018.10.11.12.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:14 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 22/42] btrfs: only run delayed refs if we're committing
Date:   Thu, 11 Oct 2018 15:54:11 -0400
Message-Id: <20181011195431.3441-23-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

