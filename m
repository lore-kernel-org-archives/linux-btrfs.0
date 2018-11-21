Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE796C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95A6B214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="p4uaYaD8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95A6B214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbeKVFl2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:28 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45576 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:28 -0500
Received: by mail-yw1-f65.google.com with SMTP id d190so2668596ywd.12
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cR41VZhNf/30aNDR9wwgeVsNkTnsAPanvCYJGlZyjvA=;
        b=p4uaYaD8J+cVPVxl16RuncQFeoQffwJRpXqFkpkbi58USjW3g+OdTPsagssSbfwisx
         tKc3GQGhUW7d1M9uVI2DAG+XxRdoZcCoNShs3/HwF6iCeGSLstNJTF/CYwDgumUsgUGY
         QbepuRzaxh8yOKS8RwnPLOVyvaXLSdNMZIzRLqxnYNQoY6YE+bTIbviLA78ohDertudr
         PIGc+J0N353A244nvnZgq/Bu0xORoKl4PkHW2SE1+SY7AfaXBfPAcDMocsBziTj4Ctyr
         RnsEx53YqzLY7srQqUHmsR4sxMUb7R0vaOaRfdY2NSbYfqRJFKyUNqIUeQA7RxgTguxR
         YWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cR41VZhNf/30aNDR9wwgeVsNkTnsAPanvCYJGlZyjvA=;
        b=LZCPoo/KMrs1aGeezIkQtFpG3NOalvGN8zi4u0Z1041E8eQ3rBrHG3cVCxdmC3uiQI
         GnBud7J0rfeScC0Yn4oz282EbD7VKxYNsW+FTZgy5sshyHNaBdxjbjjwI+r+4ch+xLEQ
         5LrFrdDlPHBA2MQBICpT1mOzT+0ESY2MKDoHcOcWWiw+I5CIlJ5SByqhzSj+6orSp53k
         GJnZDNKxJYx6jRbUeozyVONZat41h0f+ZgbOoKE0g3BU+7kZ9sY4zdHWvgwJSRx25aqb
         eSTy8bRveymlbN87S44VERFn1fFQT5jVqMGOSFufj8fOW8JekH5Q2IWwvyXxdTQrGYYN
         zjMQ==
X-Gm-Message-State: AGRZ1gLRGt7ky9R6Hk0KonEZ40pHMvkbCINJTch5Ti/Oxw3m7MydgyCX
        u+01MC3v8gdl/27xE3djtdJ3jJfDy5w=
X-Google-Smtp-Source: AJdET5dcF9iE5rkbqHdBquJBwAnpOegzxdM4nQ7r1BNRGWA9hUkO1/gig66rZAcuN1cd6HcKhb47tw==
X-Received: by 2002:a81:a4d1:: with SMTP id b200mr7454109ywh.316.1542827154717;
        Wed, 21 Nov 2018 11:05:54 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g70sm670457ywe.105.2018.11.21.11.05.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:54 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 4/7] btrfs: call btrfs_create_pending_block_groups unconditionally
Date:   Wed, 21 Nov 2018 14:05:42 -0500
Message-Id: <20181121190545.24798-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first thing we do is loop through the list, this

if (!list_empty())
	btrfs_create_pending_block_groups();

thing is just wasted space.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0f8880ee5dd..b9b829c8825c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3004,8 +3004,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 	if (run_all) {
-		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans);
+		btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first_cached(&delayed_refs->href_root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a4682a696fb6..826a15a07fce 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -845,8 +845,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1937,8 +1936,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cur_trans->delayed_refs.flushing = 1;
 	smp_wmb();
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	ret = btrfs_run_delayed_refs(trans, 0);
 	if (ret) {
-- 
2.14.3

