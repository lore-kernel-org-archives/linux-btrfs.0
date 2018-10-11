Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33C9C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954CD20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="eTZla7w7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954CD20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbeJLDX1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:27 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39936 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDX1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id b4-v6so11329156qtc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=eTZla7w7cFPTBdvpqJGjVk+CfGa5cQveyXJb85iYTh4cAWBpy3XYuM1iQtAd8F8Jnp
         /NbZBeKjPwMn+23RtNAi868PAjVIbFiyj0cmCIIWWOjaOM6ZTKUuTPPWGVTqaH77qDms
         In+sAO89fQ4J/WeaUvC9QO9QO55HlDAWJYHtCN00bvebbKa9Rgy+ANyhNTkMjE0weP/5
         J/vnCAtgNysJI0i2fZ27j4VeMpbGkgmK+RjtSLAF9NCHfwaqSOj/kShZzTEjPoDwOkMy
         Sgs+P0BunbpSRieq32RxFOuNDlY0QejwcmVXWfWATjjxyweeThl44ANBvEesqFd9ZWfM
         1AsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=NeVOLSFUEMbEK1lK3dx2DVSoWDqf9LjEnEWWXOW00QZhnCbs1ykiMVwxLIecmaKqh7
         Y+DHdQaFPtMFK/dz5gvxn5zlyUPAojIUxyBi1t5ibwOVDoK2OO7IAm4gULx3ySUjVZqG
         bYkDKYMUPCKdx7z3HA0pDHUM4GuE5O5yv9D+qMvVRQfr2yo92u4xXo7P3KQ/IX5ox0yZ
         7CC3QZ4ZLDrJWVdVV76addjZyJF1ZByAOjfOxPO1bW2m56rDv+bPA5Xr1MM3wsLU7eVN
         lrgJu5FGbKIRcv/QtKOY3frmscR1XJTiWGhOnof/oEQs2TcyQyEdPQ2WkIMMNKOibWAD
         IaAw==
X-Gm-Message-State: ABuFfohvwlATPhp1D9sT7jYY6Em2ZbpURJjDjUofNqf6FVXiincBpCqP
        QiXzfkhH5fdZyBDH5EbA207I8Td0Hf0=
X-Google-Smtp-Source: ACcGV62KhV7XgOag9+YpFGfQV9YutTPSarvJK+crLuarQSmfZKI+P9kJj9jijKeQnfaWp5VTTOCklA==
X-Received: by 2002:ac8:6a0a:: with SMTP id t10-v6mr2948726qtr.376.1539287681211;
        Thu, 11 Oct 2018 12:54:41 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t29-v6sm15635933qkt.44.2018.10.11.12.54.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:40 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/42] btrfs: only track ref_heads in delayed_ref_updates
Date:   Thu, 11 Oct 2018 15:53:53 -0400
Message-Id: <20181011195431.3441-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3a9e4ac21794..27f7dd4e3d52 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -234,8 +234,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -460,7 +458,6 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.14.3

