Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A85AC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D90220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="v5xhD/f+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D90220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbeJLDYI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:08 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:39307 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:08 -0400
Received: by mail-qk1-f181.google.com with SMTP id q5-v6so6273778qki.6
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=lizMbT7vCIz2W88dy4Yz105drP7CcDdejIERE88viZs=;
        b=v5xhD/f+xmgqZ41UgjJVWwSwCaS+rZJ/nR0QPIhVL418AuQQeEEjyi8EHwVm194c+2
         PobGPkFGWqlniiMUBr8f4ANNGkLe9D7S/qpMRTL16n7S4bn5xK+TXh4nYRcCiVpz6Cpd
         q+uMKbmHXbUqZoFZ6KqfutDyW36sBzTqfAbsJZgDWdr9P3s4oHJFYpBg1scND+cx41nr
         7vCvG0VbrpFE3KAee2Eb94gew6+PKS5nvTb4Bl0dXHngdfvdTTFWoN/6UTa78+P93Y31
         JPWfkrmdtqSrILKLqnOyprImmvOaVI4sk6WNPGrpBsZ/tnDGOJUFowf8Ks9hZzYOmN6s
         4Xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=lizMbT7vCIz2W88dy4Yz105drP7CcDdejIERE88viZs=;
        b=Ll+NiSe4GL2am82yXXWgq4bHRTjpuMDQVL1tsjHqJaJAn/cLFL8WJ1EKXv9sFntUFw
         9QWUeNcyE8q6OUNr3vV4AL4w7Np7rf5L7/m6jV5WnlqfiDMaCtVubrz2Xnv+elffZcQa
         FRrHhCRYh7/iwk8ZT44OR2GFu1REY6DCxNMM4WYL7NKuBkr5rO0n/+Mcx0q8uxDzIgfR
         xqxS0Jbc0pVrk1wRnhFXtVNiqLW7sC9tldp+StxVYckpJrF2vmGHZda7XwciMIC9YXqa
         qUCvdFSHHEkpmAZW8TZvrAxNLcDqZGMaApHUIvCs5SMY1GQVnFQIrT3q7aZ/o31z9z0T
         RY8A==
X-Gm-Message-State: ABuFfoh24dnAe1HAqPYsG36SvfWzFBOc2XLpdMz/hh1GWjhrlxbPXIOw
        dhyC/h5HcW9DjnBXLTHjdSSKiZq9cmE=
X-Google-Smtp-Source: ACcGV63Z5DKT9KrOeyNMhA3NsUjR5jMhQjmvvs0vcPShqOGjEmBMiTn6XZsv4YOP25w7fiAEFHA3Cg==
X-Received: by 2002:a37:5946:: with SMTP id n67-v6mr2991971qkb.202.1539287721256;
        Thu, 11 Oct 2018 12:55:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c36-v6sm20041113qta.56.2018.10.11.12.55.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 25/42] btrfs: pass delayed_refs_root to btrfs_delayed_ref_lock
Date:   Thu, 11 Oct 2018 15:54:14 -0400
Message-Id: <20181011195431.3441-26-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index ec8ede2b1dec..609f49c69c8d 100644
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

