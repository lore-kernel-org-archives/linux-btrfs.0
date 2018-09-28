Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94D9C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B17A215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Yv2f3IeL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B17A215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbeI1RmC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46158 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id q12-v6so3530730qkl.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+HzhX5veQVR7KYguCDJIe+MJkMCf434goypDockwhKY=;
        b=Yv2f3IeLb0lelUrvrsnzmAzNzjBYP7ID/Sf6aD9tQIVsJTggG0w7xY/N1uBwyxAd4I
         u6zZWzhbYNYY4ankDK09cfyc+CICrSUJVpAw7hBM24KgDCj6OJyJcNPkXO6on+4QjlyQ
         rEsJT/ieOJpedFzQrObbu2Ku1WfJqyOffoIDjdfhapx/UjWYN2dqjDWJ4UCre40AJHfv
         RgWMM55OcBVFGqUoZOHUlrLMTusMx2s4SYFuBghA+1M6WfmAOqO/rUNEgvvlME8EA2O5
         itHNUy4dAAZKbzsEr6gv9c2RvhXVrtzNa+ZxjRTURPVw8gPIbSjGnTVgKWPcLGr1/VwD
         oVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+HzhX5veQVR7KYguCDJIe+MJkMCf434goypDockwhKY=;
        b=rUE8gF2EyuS8iA3mVHibonM0VeMlvTw2QQUifDJxqm/DgRLjZirJv1tiNqw/CuWBF2
         GnQbV6zealTYWizangiQFmbPy5b9B+IwxMjuz98S9vXJHv6EqtBNY6wx9u0WLW8MCfAI
         CVgk9oQgHem/593vEKdXInEcIx3tlp7BhePyuY/AdFUdFc2twaqeQlF4Kqfp78RGqPRh
         V99E9zPwTp48UMcuy6Yn4/T+8+NqFVCma2dSz5L/Yotj1SzUBi2d6abMcbJuR4AAETid
         1xwsAsqVGjUbq5jmb/x2i8F4aGdXIsWi+i/emyHmYCPrv/rKVZg77UuhTYSG5fLlDw5P
         eBEw==
X-Gm-Message-State: ABuFfojFe7nE2aQxytrNEsdcobARwUeA5CeuGd5+17GP5PXANLwBZjiZ
        cbyzAtvvBmqjg+J0ynmiI43fs+bB/+w=
X-Google-Smtp-Source: ACcGV60xMtDNKU9hxUosg8ZkY7YbMZ/L8HhT46lel3/jQM90hDP/Kva+Soc3igIw3/hK7bnSaZHjVA==
X-Received: by 2002:a37:aac5:: with SMTP id t188-v6mr11490373qke.250.1538133524032;
        Fri, 28 Sep 2018 04:18:44 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t15-v6sm2578317qke.74.2018.09.28.04.18.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:43 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 10/42] btrfs: protect space cache inode alloc with nofs
Date:   Fri, 28 Sep 2018 07:17:49 -0400
Message-Id: <20180928111821.24376-11-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we're allocating a new space cache inode it's likely going to be
under a transaction handle, so we need to use memalloc_nofs_save() in
order to avoid deadlocks, and more importantly lockdep messages that
make xfstests fail.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/free-space-cache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c3888c113d81..e077ad3b4549 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -10,6 +10,7 @@
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
 #include <linux/error-injection.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -47,6 +48,7 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct inode *inode = NULL;
+	unsigned nofs_flag;
 	int ret;
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
@@ -68,7 +70,13 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	btrfs_disk_key_to_cpu(&location, &disk_key);
 	btrfs_release_path(path);
 
+	/*
+	 * We are often under a trans handle at this point, so we need to make
+	 * sure NOFS is set to keep us from deadlocking.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
+	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(inode))
 		return inode;
 
-- 
2.14.3

