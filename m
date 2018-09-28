Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7272CC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A81215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Gsofs28l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32A81215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbeI1Rmf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38103 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1Rmf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id 204-v6so2899771qkd.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=WfeTrzL+iK+qU6MThxl04x4RCBEh/Z5V2g9l9HBhkpE=;
        b=Gsofs28lRId9Cgh/lz6SrMfmEBz01DeEUwo+wc2dWJwMtJ0zP90Ocg8nk3VtL7CzNq
         ozgROBT93s/RGDSulsuvwyKoLTHEGX0GUdzDMc5ZYXVJHedsMOr4Y044DkMO8qVVPSO8
         Zy0jEqjNUXBwI1YVzw7qzoVsiKn9JgRXwH2Sjf+7OQJx65ZaNJvUES2gV33etKGI8Feh
         AHWnnF55DJmp3dvhXAvAmLBi24ITufsIueoXqKQdFvr+bo1+B4BDpoNN6/W9bjxrVf9O
         FihU2WH8WoYzwV+7OD9RHQFCW0qj1xdQ0zsu+NAzz3Z+RJO8N98EF2F/aOZP3SZ0Beth
         62TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=WfeTrzL+iK+qU6MThxl04x4RCBEh/Z5V2g9l9HBhkpE=;
        b=TJNbdipvKCryiQjUh80sBLS/SkTusnEEHy/383z4VY7xbfE/JED3s3e+sIrS1M0FG0
         QsokIBUQ2I1azup1cay830kTETc8AF93akyqoNdEcuxXy9zdRCGWxkMNDijDu2RjCpfI
         shU05Xpbcf1PTyJqJXIuAFsn5bLKbMZsqlwc8K2YZNAsk/mTSloWWU4Soh/qoR9WIimH
         XxVazTVfK9AgbTKFi7j9wH2jqo3VhbxszeGNX4/sLrl/fUicu8r+oQ6B+QwoZVq0RWXA
         UDJdHpsG4bDDOi2B9EnxFfaQj+k3qA6g+cOikihwXJeDEo6rzZdT4uKaAgjm7ijOyqCz
         1TgA==
X-Gm-Message-State: ABuFfoigAn4N2kLzLTRcHlysQZrkTUKsWa9sr8rr2bb7oIXzWxId2jTu
        ZT+FFTI3hopppEtAP8hIPXYPWw==
X-Google-Smtp-Source: ACcGV61hbjYDNy4m8G5wUzkc44lgtqpElA4fYHLEiRZ9BbrQxHRSguGINbgvNUnr3zd1bqbXC/pyAQ==
X-Received: by 2002:a37:a107:: with SMTP id k7-v6mr11325367qke.276.1538133556988;
        Fri, 28 Sep 2018 04:19:16 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c15-v6sm2509317qkm.42.2018.09.28.04.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:16 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 28/42] btrfs: handle delayed ref head accounting cleanup in abort
Date:   Fri, 28 Sep 2018 07:18:07 -0400
Message-Id: <20180928111821.24376-29-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We weren't doing any of the accounting cleanup when we aborted
transactions.  Fix this by making cleanup_ref_head_accounting global and
calling it from the abort code, this fixes the issue where our
accounting was all wrong after the fs aborts.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h       |  5 +++++
 fs/btrfs/disk-io.c     |  1 +
 fs/btrfs/extent-tree.c | 13 ++++++-------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29db902511c1..e40356ca0295 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -35,6 +35,7 @@
 struct btrfs_trans_handle;
 struct btrfs_transaction;
 struct btrfs_pending_snapshot;
+struct btrfs_delayed_ref_root;
 extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
@@ -2623,6 +2624,10 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   unsigned long count);
 int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
 				 unsigned long count, u64 transid, int wait);
+void
+btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
+				  struct btrfs_delayed_ref_root *delayed_refs,
+				  struct btrfs_delayed_ref_head *head);
 int btrfs_lookup_data_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fe1f229320ef..54fbdc944a3f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4240,6 +4240,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (pin_bytes)
 			btrfs_pin_extent(fs_info, head->bytenr,
 					 head->num_bytes, 1);
+		btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
 		btrfs_put_delayed_ref_head(head);
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 34105bc5eef7..7245a198ad31 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2475,12 +2475,11 @@ static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
 	return ret ? ret : 1;
 }
 
-static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
-					struct btrfs_delayed_ref_head *head)
+void
+btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
+				  struct btrfs_delayed_ref_root *delayed_refs,
+				  struct btrfs_delayed_ref_head *head)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_delayed_ref_root *delayed_refs =
-		&trans->transaction->delayed_refs;
 	int nr_items = 1;
 
 	if (head->total_ref_mod < 0) {
@@ -2558,7 +2557,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	cleanup_ref_head_accounting(trans, head);
+	btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
 
 	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
@@ -7223,7 +7222,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
-	cleanup_ref_head_accounting(trans, head);
+	btrfs_cleanup_ref_head_accounting(trans->fs_info, delayed_refs, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

