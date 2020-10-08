Return-Path: <SRS0=iNTY=DP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD3FC433E7
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED4221D6C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XYcpewhS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgJHUtG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgJHUtF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2020 16:49:05 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32500C0613D3
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2020 13:49:04 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id c23so6337081qtp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2020 13:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=roK6vwcrJtcBOUWkSd+sQsSCFg/WX2OHqDirvmbON7w=;
        b=XYcpewhSZg+b5EVzt78eRPg8xTvN5tfVsZHLQ/rkOhSkC+fLJrBougBf0fLJ/TmaqR
         IOZzdOYgcPpehbXdYhE+B55ZIYnPXs31TWd1wl7HuwQ7oEnKMrqiyKT+G2lcs0cT2/sw
         4PyCq358+tq5Hgn5h7TckLzF90+NygtKIP8uJH7Puwq0y531mUIeM8f54PKIBh+NxuTj
         edrBvOxQil+WMYLGKhRf7QzSnyaFz/To43xSABaloTG+nwWTDim3N22mY0GML+VGzJIT
         x/dR5dSiLyA75xbkjed1gam12a1PVWWCRKB2TLmwMoODGu22THswujKV9Lvc2di78Gqi
         1FOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=roK6vwcrJtcBOUWkSd+sQsSCFg/WX2OHqDirvmbON7w=;
        b=FPgeoGaPjWpFGpi2FbczBGFyRDkexVfos0ATWhLQWR5qZ+jggpJU/PsSSimNcjtxsr
         /DOZKSuTLm+1aU2iN9hT+LX+ykcU7i4rejbpl4sVDd1HJQ0Ogqu+e7Dx8h57baiop0FP
         jrMBelRB1AHVT5ARCjhYicmmzg20CjbbfrHWZJucb/HxwJmF/Qo9YB2YwFYBmV+8n9v4
         8LEOdPc8kLiu+P7Ug/VTReVYmUZtQwLBRxACyK7OIKnOgrge1Fje5gPHfI9/IZ35xV++
         tbQ8lbS9AhxEhcyeJWUSjgroWPjEgu6ZhM4HRIilo7bUzn3+b7mKiZXx1bxHr1YiFkVd
         P7vA==
X-Gm-Message-State: AOAM532KXNfqNZtTyG3oLc9n8ZTagFVwRb5Hiy2dO5mQ+yhcjBUmODDR
        yXXtcJqo9vLrkFNdz52HXB9+Yj5HO+AYNNXh
X-Google-Smtp-Source: ABdhPJy1Ml9mG98fbKp6XY2bHg38EgERN9t7kF/45SRvr+MleDXGsJzgkZHHUwLnvp2BLm7wVgBwxQ==
X-Received: by 2002:ac8:570f:: with SMTP id 15mr9975082qtw.203.1602190143118;
        Thu, 08 Oct 2020 13:49:03 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id i62sm4815473qkf.36.2020.10.08.13.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:49:02 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 03/11] btrfs: introduce a FORCE_COMMIT_TRANS flush operation
Date:   Thu,  8 Oct 2020 16:48:47 -0400
Message-Id: <a5a4a2dd1dbb4686175e796c9a20f9ad9cc59222.1602189832.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1602189832.git.josef@toxicpanda.com>
References: <cover.1602189832.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sole-y for preemptive flushing, we want to be able to force the
transaction commit without any of the ambiguity of
may_commit_transaction().  This is because may_commit_transaction()
checks tickets and such, and in preemptive flushing we already know
it'll be helpful, so use this to keep the code nice and clean and
straightforward.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             | 1 +
 fs/btrfs/space-info.c        | 8 ++++++++
 include/trace/events/btrfs.h | 3 ++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e817b3b3483d..84c5db91dc44 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2654,6 +2654,7 @@ enum btrfs_flush_state {
 	ALLOC_CHUNK_FORCE	=	8,
 	RUN_DELAYED_IPUTS	=	9,
 	COMMIT_TRANS		=	10,
+	FORCE_COMMIT_TRANS	=	11,
 };
 
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 96d40f8df246..a215470c1887 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -737,6 +737,14 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 	case COMMIT_TRANS:
 		ret = may_commit_transaction(fs_info, space_info);
 		break;
+	case FORCE_COMMIT_TRANS:
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+		ret = btrfs_commit_transaction(trans);
+		break;
 	default:
 		ret = -ENOSPC;
 		break;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index eb348656839f..0a3d35d952c4 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -99,7 +99,8 @@ struct btrfs_space_info;
 	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
 	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
 	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
-	EMe(COMMIT_TRANS,		"COMMIT_TRANS")
+	EM(COMMIT_TRANS,		"COMMIT_TRANS")			\
+	EMe(FORCE_COMMIT_TRANS,		"FORCE_COMMIT_TRANS")
 
 /*
  * First define the enums in the above macros to be exported to userspace via
-- 
2.26.2

