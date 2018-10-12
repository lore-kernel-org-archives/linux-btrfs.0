Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A156AC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E4352087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0f7x9n3z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E4352087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbeJMDHI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39995 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeJMDHI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id b4-v6so15035359qtc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=0f7x9n3zgieKfRC3UgRX4ExEzt57PcehiQaAHUSajpjKvs/RkfaNxFbxSvxWYC864Y
         8QCkDNrw3fBjXVp5uxt9zJ+EQBkO7oftXmMKiiJjj4MpMHLRYt6C3fZH1cbGY50b9nQc
         ViDniPQQR8D0JVct6IC2tgiRBbit5LJDB3XGpXZCiSEvjQyqraqBDDqn798vlt6nZKrJ
         9+238CshwBue05X13GPSZVDqLt50RQJ8a1todhoCl7n3H8AnmTK4nTYkmGJpcVkeuTjD
         EEi6O9k+u7CFkm/2MsGqIVGfB6IHAWh2IaY1lTaEjLthzTCf/ULsnzy10s5/4/UgKeGl
         chWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=PfhYWiXtMXIg/9nF/+1Cx2pVtQ29NadBpzGi+iubFfK92+LFVOs/w+lw1YeAltz1Xn
         D4TL2p8a/zC5vELNWcz7araXT28sRdPG7O1+pPFK9RWBbjH3p9Zu/VrueTLW9eX9GPgG
         +1mbBMEhG0eUM65mhehgcj02gLCIwBpkw+20D3uDjFeuNoKVzhklCcbF/2uuLCDU7Ebr
         iSkEb/DxmorZqANjE4YzsRAGcW26FkrXiPm/deu+4aCiFRMjllNB3ecDPMfVtR7rIlS6
         NVK7yofIRSW1piRHUvJOf1vNXt7ripjZwKs5vcccd7EL9hYiw0Am9s7yYwd6OmUcLZJI
         tIZg==
X-Gm-Message-State: ABuFfojazS3N/Xj1NTqytgmTbxVmUdPaMGisz+yVQg+PVpZTT35gRFSx
        kU/JRO935JqsdvwUkf2WcKHW3FNbiLY=
X-Google-Smtp-Source: ACcGV62nfF9JF/Ayu2skCxpcAHgcr6y7HnPmdcKvw744tGu0eNZdM/7S4h/YHSi6vNhkBx92R+qZmQ==
X-Received: by 2002:ac8:721a:: with SMTP id a26-v6mr7145958qtp.64.1539372787168;
        Fri, 12 Oct 2018 12:33:07 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j125-v6sm1093251qke.61.2018.10.12.12.33.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:06 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/42] btrfs: only track ref_heads in delayed_ref_updates
Date:   Fri, 12 Oct 2018 15:32:18 -0400
Message-Id: <20181012193256.13735-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

