Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46A3C71123
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DC2E2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0A/pmy+f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DC2E2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbeJMDH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41974 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbeJMDH6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id l41-v6so15053456qtl.8
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=iYf43solQFPvuH12W6PP9YSCdqMp0PBiM9fgZKcOmF8=;
        b=0A/pmy+fF/MSShxF+E8A8K4Q1bexMSX/diWGRrLcLjtohaI5gaX7//w2Gm2qUvyWmD
         U9+8rZlO3sVu+WLTWjIKOu0n52nemtCBr9p0A6BmKfEpqinUi6P0tCxjKD6fRDgrXQ3I
         QLovmREkXB+LFtPNCDPyle3Z9xg4jOprXw6vQ7YSXHbNd/0jtOrJUXP7jbXlTD//FjpD
         w3IHAuGvs0/4VfaA8C7KFkKWBHebH11HXlTjrU8ko2fapCJ7NeEquJnvmNdhQO8vvrkw
         4F/B5NEIg0kFmWsnqLziZpQBDbS9cAa8uDrW5g2l6qxErvfqNej0n/DjxQ5SHso2dugR
         9UdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=iYf43solQFPvuH12W6PP9YSCdqMp0PBiM9fgZKcOmF8=;
        b=dxlYzCWCYzRcNJs7WmHahBwQqlQkbfgN/0c1mvzUXyzNvBq4e1n+b98rIGlGJEmiKg
         186ero4UuhY8cWTXQFmWFDPViDJgM4HkQyWXdTJJOhSyDVn0uY/bqVM3BdXD4/uFd8mp
         WTKclYolqO1YXCKVq+zNIAuwMZ5UdNcTr/SdkCvAJ28tD1haBedJ65JjKCy8j2OhCY5G
         6OU0ChsbwhTbXfJNy1LKkmuEydyF8ZtFDNqkDlf5Y8fCZ0IyN8jzq3kqel+Ph8BBlsc/
         33Rpva20ANkEOzVAgxGzeaYoEO47KZWeZoSmFVh6hPPTZ8UK8hCjBUO2b6KTWkbY0oTd
         NEDA==
X-Gm-Message-State: ABuFfoh60RPC8bwzXnf6GIsb8EtuVfPw5/ZrLiIfUAWcySuQXfCctiCD
        SJF7Kr+mTgFlFDshYUEmIqUh7K3lhck=
X-Google-Smtp-Source: ACcGV63QJQMcoF+2gfRY77N9eqxXrT5XbNQ2c4MlMecLldwE35JDTb1MnE6DnkGn/4ELJQs0WYARHA==
X-Received: by 2002:ac8:3414:: with SMTP id u20-v6mr6734532qtb.237.1539372836775;
        Fri, 12 Oct 2018 12:33:56 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s71-v6sm1555623qkl.86.2018.10.12.12.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:55 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 25/42] btrfs: pass delayed_refs_root to btrfs_delayed_ref_lock
Date:   Fri, 12 Oct 2018 15:32:39 -0400
Message-Id: <20181012193256.13735-26-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We don't need the trans except to get the delayed_refs_root, so just
pass the delayed_refs_root into btrfs_delayed_ref_lock and call it a
day.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/delayed-ref.c | 5 +----
 fs/btrfs/delayed-ref.h | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 96ce087747b2..87778645bf4a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -197,12 +197,9 @@ find_ref_head(struct rb_root *root, u64 bytenr,
 	return NULL;
 }
 
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head)
 {
-	struct btrfs_delayed_ref_root *delayed_refs;
-
-	delayed_refs = &trans->transaction->delayed_refs;
 	lockdep_assert_held(&delayed_refs->lock);
 	if (mutex_trylock(&head->mutex))
 		return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 7769177b489e..ee636d7a710a 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -255,7 +255,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 bytenr);
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head);
 static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d7fc07c34ab..529c2aefbbf4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2600,7 +2600,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 			/* grab the lock that says we are going to process
 			 * all the refs for this head */
-			ret = btrfs_delayed_ref_lock(trans, locked_ref);
+			ret = btrfs_delayed_ref_lock(delayed_refs, locked_ref);
 			spin_unlock(&delayed_refs->lock);
 			/*
 			 * we may have dropped the spin lock to get the head
-- 
2.14.3

