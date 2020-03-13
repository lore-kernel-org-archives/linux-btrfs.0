Return-Path: <SRS0=6pDE=46=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6E0C4CECE
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B3C2074F
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Je+wIMKw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCMVKD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 17:10:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39889 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMVKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Mar 2020 17:10:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id f17so7557578qtq.6
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2020 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xk9lFCtQ8lNTpXS61zgK0X57G1PTpwkRWLcA6W64bIc=;
        b=Je+wIMKwWPkCNWT3Xj3rbk/W30d8oGMYNr7gkRsm5ALQEExZ2DS5W/cFjX952v0ANn
         QV/PJBTFGhMmlvAiVGTwoKKKd2rCl8qZ++RV8v0ZHTH8rrpTtz0kbclP1OOKbbhs1R2o
         qxrPCZSjyHj1GuNdxRTjhH2b9ov7zv1NtthaTd8F9DUx6TuIRbNNAEmyZ93tsNC97RAq
         d5JbPjlrkjSJwAlYgeJW5aPHdvyc/85mfQYAM5WzkeSvPC/9Z+PRO85T/N5zHhvWba/X
         +upjNfFa+7R6b+41wtJ/h/tAVEfAf4rbgjVWZp836+WNXWPAUjgqKBkkNCVWjWOpoDys
         lhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xk9lFCtQ8lNTpXS61zgK0X57G1PTpwkRWLcA6W64bIc=;
        b=ai6v5QG7r3k3oP/OgVKhxAeGuyvwMX1emMTfElLAPURROmvr+oI98+hILzdK2Pt1/7
         lZyZ+OO93be3+uJrgtm+/wQ0tGxt04O86Hh+ycjaDLLFinKw6aoYBsf6l9jj96xIQcUJ
         7vo3FLdXsNTSHMlWV0BLCheN/w4dgEu/w3iarfg14yHfr7Oku58pnm3iLCJPsqVEeFAo
         fSP9Qlb7w0mKdR7M8TbqyFLW6EQIe1CHzDb4RjJGKU5JDAp7TgPtqvZho0oCJjbY+vXM
         p/wU7t17PQxrq1PpD+Ho7DG8hSYDBBbHUZp0f0DhRqGCCHPP/ykR9LWqJrbB1vR+yZQB
         94sA==
X-Gm-Message-State: ANhLgQ3FaTMRluZMGBr5yFf81mVY2CPfJZVqqkrn9iwqbxx782KysH+a
        OR086doBfAtyXxcq+zyiLkJu0SFHWg5mnA==
X-Google-Smtp-Source: ADFU+vs7IUaeOlB152c1WRme2aaP3CkM7t07tYLfFiErSKUu50mYM5u9fXui6D4zZ9tPtyfzfd46ug==
X-Received: by 2002:aed:31c1:: with SMTP id 59mr14203118qth.370.1584133799409;
        Fri, 13 Mar 2020 14:09:59 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a84sm8893725qkb.90.2020.03.13.14.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:09:58 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/2] btrfs: do not use READA for running delayed refs
Date:   Fri, 13 Mar 2020 17:09:53 -0400
Message-Id: <20200313210954.148686-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313210954.148686-1-josef@toxicpanda.com>
References: <20200313210954.148686-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

READA will generate a lot of extra reads for adjacent nodes, but when
running delayed refs we have no idea if the next ref is going to be
adjacent or not, so this potentially just generates a lot of extra IO.
To make matters worse each ref is truly just looking for one item, it
doesn't generally search forward, so we simply don't need it here.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a24ef1cef9fa..8e5b49baad98 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1469,7 +1469,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* this will setup the path even if it fails to insert the back ref */
 	ret = insert_inline_extent_backref(trans, path, bytenr, num_bytes,
@@ -1494,7 +1493,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, path, bytenr, parent, root_objectid,
@@ -1604,7 +1602,6 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	}
 
 again:
-	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 1);
 	if (ret < 0) {
@@ -2999,7 +2996,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
-- 
2.24.1

