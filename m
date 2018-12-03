Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6718C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6372920834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="W2cESaGM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6372920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbeLCPUu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:50 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35762 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPUu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:50 -0500
Received: by mail-yb1-f195.google.com with SMTP id z2-v6so5419302ybj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kGdy1v9lj83bGenqQECPukc02qedRDiXFUktHQZr0jA=;
        b=W2cESaGMGPtij3yN9CS4udGTR7cRjSHs+oprgagbME+Qm5RckBAQVF5jSJxFDOnSmR
         RPc9CEHCqBSDyGbQrd+w18vXGvuiXEvwZKtFa2isduUrFRZy3VLMwdUfw2Ci6wf2v4Ja
         VxbYhIH7m+LX1DPeW6e/6Fmvxq7O8oTSoDiJ4hOk40OrHbXdYdcu850Kq4yR16FnNn6Q
         PFv4m1IR2MQ7yfNpPC7RF3B6bY5RTfhcJ45obfD/QtXKgAkuJkIPYDw19oOyv+EDIHG5
         dtpuvMbwZ/XzbF8r3Wii7PFnCT3TK8I76XVaP7QkaOgyR9n3Kp1xVLR5zvC9hNpi1pDv
         j5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kGdy1v9lj83bGenqQECPukc02qedRDiXFUktHQZr0jA=;
        b=uF6kd7h4Tz42I9ofHph+IcxPggucgHeDUErIVGq6crdbf47xllJGjQgk0rTlAAdnWn
         OO7KVR+sAfFlljZZLLOt64ouo4yin5PzxH1XC8oLoMf3gzq6qQuvctUvS4TFTODrrM9z
         pfS27uvOFkBoEh6AtxJ7b3bM6SA/GB2Ykr/KZgiU2qxWfv6VKx7kuC2VkXZZYt8ysJ/f
         lBaZDAlQs1pe50iknS3nNMFWvI8N2xTz3SVT7jiJxfIuBbb6JZfsFEJhpEMuwYFE8+nV
         bsG+IeJQSPKVR1rcECSVAHc1xvklCogmJstb5wDysOmSEL1/qeku8wOJ7PWD4i7/t7sC
         YnIw==
X-Gm-Message-State: AA+aEWZERvBsZSYCe7xBy60FvVi1/qCQPqDQJGaov7mSU0lb7vYKg+H8
        LX0qEAGsZZvnaYqganJYcp5+vt8NMTs=
X-Google-Smtp-Source: AFSGD/Wv2ay1stsx4cqem/0bo+SHyROM7PAPNZ0HQ7kWFAl40GLiWP0KPTiHAH7zAgEXuZi7zqZUDQ==
X-Received: by 2002:a25:9185:: with SMTP id w5-v6mr16177951ybl.138.1543850449073;
        Mon, 03 Dec 2018 07:20:49 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o14sm6010631ywo.52.2018.12.03.07.20.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:48 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/10] btrfs: only track ref_heads in delayed_ref_updates
Date:   Mon,  3 Dec 2018 10:20:32 -0500
Message-Id: <20181203152038.21388-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  Fix the accounting to only be
adjusted when we add/remove a ref head.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b3e4c9fcb664..48725fa757a3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -251,8 +251,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -467,7 +465,6 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.14.3

