Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AADBC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9BE20651
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555316954;
	bh=QACJuIGVJERHD8Vv+YhJ597ermYcp0o3c4Wf96fNxO8=;
	h=From:To:Subject:Date:List-ID:From;
	b=AhPuG1tgHZxrvKYIyPo6Qp/BCFnkhISbY3Y2+PoLVvWeufMXj8ML196jDjARb4Sw3
	 O/+TdBPwEE3hBlvVxp+RqFBPM7HMDDIm2LfyFlrnpVIOOy3n3wMPqPxaR1wk0DkPsG
	 DPlB1CSvC10PyLVunseai9TA/58sXD1PnZd34CY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfDOI3N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfDOI3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:29:13 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9018820651
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 08:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555316953;
        bh=QACJuIGVJERHD8Vv+YhJ597ermYcp0o3c4Wf96fNxO8=;
        h=From:To:Subject:Date:From;
        b=l76ATE3DK+NZ/bcjED/X7B9PEs5SZE4LfAza//hSmKzebJDtMPH7SWxvWaYhKWdiS
         maE1qMRatTI4s7DsF8RmEourf/mPBcPq6C6oapPTk8rilHZgr215zcixiJiT3JGXbC
         klrXsifD4KkDLN+TEWhaWBG4YKQPzzPrIWMhI7nc=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allocate ulists in btrfs_check_shared() using GFP_KERNEL
Date:   Mon, 15 Apr 2019 09:29:10 +0100
Message-Id: <20190415082910.2073-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

As of commit bb739cf08e8f32 ("btrfs: btrfs_check_shared should manage its
own transaction") btrfs_check_shared() manages its own transaction, it
no longer receives a transaction handle as parameter. Since it is used
only in the fiemap path, the ulists it needs to use are allocated before
it grabs a transaction handle and we are not holding any locks that could
cause a deadlock in case reclaim happens during a memory allocation, we
can use the GFP_KERNEL flag to allocate the ulists instead of GFP_NOFS.
So do that switch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/backref.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 876e6bb93797..377978bb8845 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1481,8 +1481,8 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 		.share_count = 0,
 	};
 
-	tmp = ulist_alloc(GFP_NOFS);
-	roots = ulist_alloc(GFP_NOFS);
+	tmp = ulist_alloc(GFP_KERNEL);
+	roots = ulist_alloc(GFP_KERNEL);
 	if (!tmp || !roots) {
 		ulist_free(tmp);
 		ulist_free(roots);
-- 
2.11.0

