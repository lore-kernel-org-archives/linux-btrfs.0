Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EBDC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E36D214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="K9Xq1KCH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E36D214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbeKVFiw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:52 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41922 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFiw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:52 -0500
Received: by mail-yw1-f67.google.com with SMTP id f65so2669462ywc.8
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=nWzyWpJZH1mR0spxKLq9P+l8mel60lXF8fmkywvihFg=;
        b=K9Xq1KCH5oJC8e/BrPisCprcdPq+PVmRLKKCSL1XGlj/e/XZYDmkPR4SHplGfH+cHU
         3Ub33f+pufOyH4/6QcNaQ/bdqlkANlcpqUCo/fB0FjJuWpFWbu+SKeUXdiVSsQwaSjCc
         bYF4c3/INsJCSqSs51RH7gxHgC5dUpUagm2nA0fcmWS4eilLOjhGzf8X7MJOUhWDXu1w
         PXNyHP5VfBpCmC+qVWb4GuiGAPUiYZ+9bXekhfPJkBswo2ctFW7kKG2tw4cws8OBJAkF
         2/AuRUtH8ArwQ5yd82UUvt3Gx8ACO+XNz6Ijfw4uClSC7iM3EWNRgmZugV2AJRmEJ8Ch
         8MgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=nWzyWpJZH1mR0spxKLq9P+l8mel60lXF8fmkywvihFg=;
        b=OvGYbSIEGf4B5RatzUGTsRCER1EPXO7DDdTooIAEkQrBvou4jspSKAxcKknPpNQMgd
         PwyGeVwYKaojuIW5fZZFBqMJ5FdOVTUZxGuD3wMPFquk+Y+SKWrhucgz26i+Kbwf1mXH
         6hQEa4IqJvRpX7eoDtEJQNK4El3jYTc/Z6ciDor3Thuqeifs1jezNjCGW5xIIcRW/jvX
         Pm1Vdwrq2MJoZRApBA0N6YA65wQ6sq5dOwT/UluQQHSANH9hVMt4XY+TH/chgg1OhFoH
         HhWD+3oVtfS9MXP7zng1G4oeiq0JIksYK8CC1Jn2z+YCR9A8E3UYS/6/IWnchFk3gIeA
         vc4Q==
X-Gm-Message-State: AGRZ1gIvkGeeKSHavt2ij3C5SD3glujoVwpwMBnXnQ7FqCPRYKE1gEtJ
        7hkwVundxYt7oeeTmejfW7aL0WJM2Jc=
X-Google-Smtp-Source: AJdET5d0o4GoPZtEwSDeJ2nlSVzArNkIIf1dwd/WuWCoi+VOWeDtMgd+OqDpXiV2gcDt/WqMwnl1QA==
X-Received: by 2002:a81:34d3:: with SMTP id b202mr7787335ywa.241.1542826999619;
        Wed, 21 Nov 2018 11:03:19 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b144sm13328352ywa.33.2018.11.21.11.03.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:18 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/8] btrfs: dump block_rsv whe dumping space info
Date:   Wed, 21 Nov 2018 14:03:07 -0500
Message-Id: <20181121190313.24575-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0dca250dc02e..7a30fbc05e5e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8052,6 +8052,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+#define DUMP_BLOCK_RSV(fs_info, rsv_name)				\
+do {									\
+	struct btrfs_block_rsv *__rsv = &(fs_info)->rsv_name;		\
+	spin_lock(&__rsv->lock);					\
+	btrfs_info(fs_info, #rsv_name ": size %llu reserved %llu",	\
+		   __rsv->size, __rsv->reserved);			\
+	spin_unlock(&__rsv->lock);					\
+} while (0)
+
 static void dump_space_info(struct btrfs_fs_info *fs_info,
 			    struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups)
@@ -8071,6 +8080,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 		info->bytes_readonly);
 	spin_unlock(&info->lock);
 
+	DUMP_BLOCK_RSV(fs_info, global_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, trans_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, chunk_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, delayed_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, delayed_refs_rsv);
+
 	if (!dump_block_groups)
 		return;
 
-- 
2.14.3

