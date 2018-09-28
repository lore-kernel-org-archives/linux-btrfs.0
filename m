Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF09C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEBED215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0zJ8DkUQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEBED215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbeI1Rmo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38190 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id z13-v6so6144982qts.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=SPKf73KNGAa6s3Pq3EYrX+Ny6AS9kkFExw/KdZENJxk=;
        b=0zJ8DkUQr3aW1g/iHvsqSVMmRXrO/eKievaTdO6lOKeToiPtXsLjbcBCDDFYImyO7D
         akNgYJANygRbmfx5AWorFRdWSMiNHG+S6JS5nxGQ8A8oau5EK5cJFnZ/Me8lz9lQ9yvQ
         FXhv6ZGjJ0Ev9V3fxWfttyYFCDjuaRvR9qt9hFv0s1QxlPb4cabggCqEMPgKmJ+lZ1c9
         8eCMtw61oDUCDXzjdilyQ8u0gHj/SWKACIKacq2n+lQR1fkInw1T26c2vtcbWzvN8DJD
         yHF4szzSckkPMWN/Swubw/5uOvB3vdxO6/2qoIyZM8Nor/NbpZM6UoLFC9CCpApLRGwf
         dWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=SPKf73KNGAa6s3Pq3EYrX+Ny6AS9kkFExw/KdZENJxk=;
        b=OS7Kpg21uAf4eKKxutt3tV8ajzNEzazISZ1XM4AOkgoatAkJ38SEondO0OD9FOCP0A
         SWtK1XjfMKcTQohBwcHCsu5JSG9LJmuuY8I+5X0d/S1Iy65U9hNmjn6RP1EKX341mmrQ
         kmYH9iL2CzFzvosTy3yr5SGi7q9DAv9teLt0XyXr1Evp4mrTZjf9j0IK76aGU3fZmMqS
         hfDycI/xhv7uIsMDEoogn8ISHFudX9HZE3teDQecVS3IxeYYAxiOi9jw+5jA0q1o/VpQ
         Wz/EN+3ovN1jnrxxmslQalxVJF8n7V8rQMMFnCLvmNeuLs3ho1goy0XN8wZimsv3Jco3
         X0jw==
X-Gm-Message-State: ABuFfohEJTr/6ctUCEIqLDVNzpEWKzhv57as+2Eu7eR9/0tvs24lKaIO
        6uYIUS+iqObl1P61NDP3E0Ln4g==
X-Google-Smtp-Source: ACcGV61M1LgCPpK32JIppLQx7pmKYOo4K66RQu9IxXeD0mN8HTg00AZQI32MJMVIqFkZL2ypqspaOg==
X-Received: by 2002:a0c:91fd:: with SMTP id r58-v6mr1170861qvr.30.1538133566309;
        Fri, 28 Sep 2018 04:19:26 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s51-v6sm3213687qta.71.2018.09.28.04.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:25 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 33/42] btrfs: fix insert_reserved error handling
Date:   Fri, 28 Sep 2018 07:18:12 -0400
Message-Id: <20180928111821.24376-34-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We were not handling the reserved byte accounting properly for data
references.  Metadata was fine, if it errored out the error paths would
free the bytes_reserved count and pin the extent, but it even missed one
of the error cases.  So instead move this handling up into
run_one_delayed_ref so we are sure that both cases are properly cleaned
up in case of a transaction abort.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ac282eb535a8..922dd509591a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2405,6 +2405,9 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 					   insert_reserved);
 	else
 		BUG();
+	if (ret && insert_reserved)
+		btrfs_pin_extent(trans->fs_info, node->bytenr,
+				 node->num_bytes, 1);
 	return ret;
 }
 
@@ -8253,21 +8256,14 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
-	if (!path) {
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
+	if (!path)
 		return -ENOMEM;
-	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      &extent_key, size);
 	if (ret) {
 		btrfs_free_path(path);
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
 		return ret;
 	}
 
-- 
2.14.3

