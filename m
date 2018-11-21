Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24582C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD88E214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="onMnJ7zR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD88E214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbeKVFl0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:26 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42447 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFl0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:26 -0500
Received: by mail-yw1-f65.google.com with SMTP id x2so2671524ywc.9
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cjyVjbBoG7sKEOd6P0V8B1uoPTV5nrc874hF4EtA1tc=;
        b=onMnJ7zRoi7uPV07Z54fN3N/de/88LHBSO8+xVcpkBaFkvkqcmbjiihHR9XPZlgKL4
         To4Kyjb+DWMk5hFsv8ROXNsawKY2TmWmPK+almMEfGGzrq7y8ffRxyZbNUEutEQfVXHz
         a/1KqeKC6CsFm5sMPLV+VUyGnIm6uLMvL3qF6pzzMJszea2/e4ijB6bY05yzVCZQd2hS
         uCeIru6a/F/ARL1l0A8ROZnWaSBsiNcgxdDczEb8Fnp6Fo0R/BO8J0rywfNFAS7Jp1LK
         D2kt9Zp+j2raw+awLjzKUQli+SZwO3YTHlsxwR0Q1z3m2pj7ahwf4TTTyjTQ5ddNidq6
         gAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cjyVjbBoG7sKEOd6P0V8B1uoPTV5nrc874hF4EtA1tc=;
        b=Xg6KngpYyd7lIojtOMOuJbXBLHM8iOUjU47MciZGA6ZDreK2jMPmC9FuzE8g/KPkls
         0UwtFBpwIr22Y1pjh6eV06yV5lxuod+O6cLMPHrvrEYRo4S5Y2/XItBw2pG6P74NYPq6
         2KVlbNGXvP0jAoH9+IXC30HCPMys2NSW1DCHsEzoEPzJAPR3yfgLj5p7mv89+rNYDKWs
         l0qJ3kN6KRY4Cjs23mxPmeGQQWPLjlaH2aL03eBIe/pBMMAUDPFUS9ScJ5NPbpn33+oA
         DlIcv40D6Rba2AmQxcbuJbOYzCEyckACiCmZdil6M3t7gsqPlke6e0OcGslkOAW1eQfi
         pHGQ==
X-Gm-Message-State: AGRZ1gLyBSRD/TYo+0uJHXfOzojSZgJ9qsFh4jR8YDLHYbnZYFPFqj/l
        PmYC3x9j9JAaUjztdS1KzmQhesJxj4s=
X-Google-Smtp-Source: AJdET5d08M5de16pZGj0yCHrhr14MscpQKvEY3XFNmUqcxavaMv3itoajZmIAwVOQ1oGQc0L0vaDqA==
X-Received: by 2002:a81:2b04:: with SMTP id r4mr7957844ywr.511.1542827153028;
        Wed, 21 Nov 2018 11:05:53 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u130-v6sm11395418ywa.71.2018.11.21.11.05.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:52 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/7] btrfs: handle delayed ref head accounting cleanup in abort
Date:   Wed, 21 Nov 2018 14:05:41 -0500
Message-Id: <20181121190545.24798-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
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
index 8ccc5019172b..709de7471d86 100644
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
@@ -2643,6 +2644,10 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
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
index 7d02748cf3f6..8e7926c91e35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4223,6 +4223,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (pin_bytes)
 			btrfs_pin_extent(fs_info, head->bytenr,
 					 head->num_bytes, 1);
+		btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
 		btrfs_put_delayed_ref_head(head);
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e31980d451c2..a0f8880ee5dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2457,12 +2457,11 @@ static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
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
@@ -2540,7 +2539,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	cleanup_ref_head_accounting(trans, head);
+	btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
 
 	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
@@ -7218,7 +7217,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
-	cleanup_ref_head_accounting(trans, head);
+	btrfs_cleanup_ref_head_accounting(trans->fs_info, delayed_refs, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

