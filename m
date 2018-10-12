Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48CFC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED3D21470
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Z9sT6E3i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ED3D21470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbeJMDIE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37571 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbeJMDIE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id d14-v6so15064117qto.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=LupJVcNaGZD7v7kwZmH4pcQfZSwxchu3Okq8BUpSizQ=;
        b=Z9sT6E3imDMgkTGOwBcSxwLvdQ0ARxuBB6Ep433QcBtsEvM8gK18PTXBLkPSj0UkmQ
         zsaZ7Cq92Ss2Ml0Y5oRxbAi6hqH2jPLmZy++ZXakEd98ekWELw2pqEjWUEtOkCNuKAwf
         0M3nrwnUPB0h76OUUGvs33rfM5SAAbcBAIe4lcBLoOed53bFhOzpeDQ7AFemMmsYhMNO
         jpOmRcy7KmWbVGBgEe1onSgjzHIk09KvJrh0W/0Gr2UMS7J66GuGB1346AYfAlTutmyI
         rd6Uz157DVz66GWFxGUB2FK6vOtJySt45mlloWWuRwU2G8cAqV6w0YZK2YpdpOyzrkXW
         2d+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=LupJVcNaGZD7v7kwZmH4pcQfZSwxchu3Okq8BUpSizQ=;
        b=mKNEDeHZ1GlKM7coBP1G3IZb0iXgM0b8UAJSCyRvGJ2TD3Qz73lNIj4rH3FqOY1M0I
         yBYPAW4q/u6CVAYkzDJKW6i9rqS1PSLaMY50KZdN0O+7WDXoZW01Y6IW7o3/u1Qq7f6B
         amw+oRKCIS6xGBScj/sV0wrdbeKYPMX7EkIvOpmduMF4G+a1dYlXAelC60QrD8GtGgbq
         OIwUSzGtIUJDUXQnAEd607omUgz9+sfYTSH6JBq1WYyziY8Bejh+J+1qY5Iz14nVNOz7
         bkik3OzyI/JdRHtwTF/uNhDoWawj85Ci3JEXLY3XRxgMiqr1e3D62A1UMQzbcgwiR7XZ
         emDg==
X-Gm-Message-State: ABuFfoinzUXnsyMje6Mwj1p7Sw6zeDc4hzL93binFfR0RwBoq5ybCp+S
        XlEo9WbGTJHjDsjmgvH2yACAF8wr9ZE=
X-Google-Smtp-Source: ACcGV63JASmwY2WzdF5HTHJrk3vazIaaJlDGjhordg0ukTCW06gP4dQdYUWM1L7ZzCJxnj1TI0B84A==
X-Received: by 2002:ad4:40cb:: with SMTP id x11mr2716638qvp.52.1539372842551;
        Fri, 12 Oct 2018 12:34:02 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z46-v6sm1591181qth.87.2018.10.12.12.34.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:01 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 28/42] btrfs: handle delayed ref head accounting cleanup in abort
Date:   Fri, 12 Oct 2018 15:32:42 -0400
Message-Id: <20181012193256.13735-29-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 529c2aefbbf4..5b5a28b69fa9 100644
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
@@ -7227,7 +7226,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
-	cleanup_ref_head_accounting(trans, head);
+	btrfs_cleanup_ref_head_accounting(trans->fs_info, delayed_refs, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

