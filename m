Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98633C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FABB20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sGu+DSqB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FABB20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbeJLDYN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38084 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9-v6so11357220qtf.5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=zIQ3GFsTodaoX0WP9NBZI59U9Zr/d1xI6Oori98CGvk=;
        b=sGu+DSqBzmhV9SJQQuQrTakrHBYnxnaKmfPEeD9It8LHGOMNaWYO0YItLehIEpuEel
         ktrBqAAnrFjO0hfLkQM2LwjFqV0iPfqCKCNxeNZKzE982M6/JZKxHXucaBsNaiEhBvvr
         xbZw5W8inPmnPu9Kql6KYsdg6IVpN9HiGsefeYBByonbEVvsdFm7wGEKkfrsj73u9xq0
         mAeavjgpsPz0lDeZ3B98tVSRyUHWxElHNWbVFWmjM1eShLRF7f/TN68rde/LuYxp0pDI
         SOIDVbgW5iuPtF2jTsoUnIFY29wfyXfX6mT+uZdfjuqWHNtle3BtGjhHR3rGOkxhaPgB
         AOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=zIQ3GFsTodaoX0WP9NBZI59U9Zr/d1xI6Oori98CGvk=;
        b=J6KurfDNWTe6ROAcKXu6VLu39iUUgB0kpeTWGZ3FKL3SOG1Q4QsiDXkXd0p4QH1XSu
         L7Lem1wEMBGzJBC4v4780uG0muquL+dapTfQiCQP+B4n9JOUqBV3wPEYpsbSlG+zTLh4
         3RDoM5GIMpewn2elU+LaP4czu+zz4uqBhR4gZYWVoskA1GtUpNS7ehjoTWHq9fbljvW5
         mSS1cnA3WQHrR5LqAxLCWoLH5oyRwAgsVqRqUS5dgOGymBXHJ2cY44AWlcjupMt3EHpO
         JMy0BswnHXz9JvsuyqKtyRAZ8yc4LoAPcICUuYnKuEMvCcP+XAPXBEMg8deo14BrX3qR
         oHnw==
X-Gm-Message-State: ABuFfoge8d+NN3q0lFLA30fZR0BVZOx1YrVQEfPrUy3sKlh2Qpul10Ec
        9581WgCvTq7ETh6ULC8lrzunFbf5zs4=
X-Google-Smtp-Source: ACcGV60aD8J7hmyepG5uTFYrmjYXdjtFpWnFhmw1o1UDsJDfl869fWhz5pqfaS4iuNQl4jiiHcAKEQ==
X-Received: by 2002:aed:2867:: with SMTP id r94-v6mr3039654qtd.112.1539287726521;
        Thu, 11 Oct 2018 12:55:26 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m71-v6sm13170311qke.71.2018.10.11.12.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:25 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 28/42] btrfs: handle delayed ref head accounting cleanup in abort
Date:   Thu, 11 Oct 2018 15:54:17 -0400
Message-Id: <20181011195431.3441-29-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 609f49c69c8d..3ca42f4cd462 100644
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

