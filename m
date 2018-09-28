Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956B6C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57902215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sKYZKAYW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57902215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbeI1Rm3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:29 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37286 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1Rm3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:29 -0400
Received: by mail-qk1-f196.google.com with SMTP id c13-v6so3570651qkm.4
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=rvsXCa4Gbgrz3G3GJWzyW6ZCwXPWHXoo2lvIWdgxiik=;
        b=sKYZKAYWXip5EtXzV1gCTggr1INyI+c0vwJRJ2ApWUdJLY/M4rx3Ukpd05P7UKmalh
         m4Rgb+MP8jcjz25A1A23foU/0x8xO5qFbPRpbl8acmmOg28FVDz0Kfj/SrusMU6wQSc3
         h6iSZ82fexUN1MfZ3rAVNyX06VrvxCx3J9iYUXQ7TIf6vS9uUsqZm2NySNOxsJMYCmeL
         9lKlkRA9DRGrZUOf5ZWhtMVYRjR/5w7ateQndbq+Xgx9mYNFec+3rKaJ+Io2WcQABSe6
         uJxMvqOxl9qCP93lTOQFfKJ2XbYe6KtjV19u85/eWbUVn2Nubv28+SLuLAbjmn5bDmsW
         AseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=rvsXCa4Gbgrz3G3GJWzyW6ZCwXPWHXoo2lvIWdgxiik=;
        b=NMMvAw3ly8ocbwnMzGH3aD9V4zapZiQitxugBB156qL2+MoOrvsG+FHxtIEH7PhwDL
         vwEeNZeO1cX1fN1Vwj0Fcnyj7/bZ/y543Oke+Dif8a91nXF2iHljjNMDAYP4yqob6yVD
         u8GSmYwnzm0nQCJ9kESBXday0tGTyQFnFJLdtvweP22bKO7EFGcW9RGAizkA6h8qw42i
         LayJOIUHrDQ5ncDCHRaSnbo3KH22Xf0QMVhZn9l4dw6V1Rm59SbSIPENv4qr4y1qhROE
         4l8mfhDh1i5ce/rFKCuCkHCiDDneKvTH75IHMuUB5ZAKGwlzaYmNa4CkQpZImfsZKN0j
         FW4A==
X-Gm-Message-State: ABuFfoiTyBzP780W03wcSbe62JcU6vgV4gMFWP0WMx8sMEQUHp/hFLWR
        79AxN9zBOpmho0VcVbKCL8K0Wg==
X-Google-Smtp-Source: ACcGV61NEgXmkeJMGERdWlqtvQSEwITzbQRt+DDY5jOI5ZLDYFpAHW7vdt0dJDih6e1fZZcRcVQgUg==
X-Received: by 2002:a37:8786:: with SMTP id j128-v6mr11414992qkd.32.1538133551385;
        Fri, 28 Sep 2018 04:19:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f23-v6sm2596552qtp.5.2018.09.28.04.19.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:10 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 25/42] btrfs: pass delayed_refs_root to btrfs_delayed_ref_lock
Date:   Fri, 28 Sep 2018 07:18:04 -0400
Message-Id: <20180928111821.24376-26-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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
index 01bfb02101c1..34105bc5eef7 100644
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

