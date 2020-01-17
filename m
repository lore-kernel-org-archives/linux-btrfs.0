Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C75C33CB1
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 13:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D52A2073A
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 13:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MBpcXsSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAQNsM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:48:12 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:40492 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQNsM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 08:48:12 -0500
Received: by mail-qv1-f47.google.com with SMTP id dp13so10701174qvb.7
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2020 05:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JbPADWcgzTRqN722WOf0d1fQvjrJwtL0qjrwv8US7iQ=;
        b=MBpcXsSIsX6EdRyJsXMVM5j9XUUKMWo0b2CL7wEkLW64RmFL0fIh7EaNYugjTQ5xjD
         ljAavq+3l8qzFLWyb68yTuoFNgYLzbPsjAuV/UaxzDBtBMg/OPMMVvkZoK1FcRzpES/5
         Sdw46BFIaJOSGrcEzJH5mCx5sCThTCIUUwOatD5hT2QXxZ61fBdsdEMVp6J26bb6gxNP
         k+YqKzRhJt+XTQPrVEl8iRTfI2yfUy2VbuwOZ2scbr7+n+DObQcXpsh/BEH5mCyfopX4
         hdjSDRSQCsPoL0sj1GDyFf6g/aLhO3mIuOGW9LKhzVwKeyat4Om6BzOzt0UPnQac5xha
         rsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JbPADWcgzTRqN722WOf0d1fQvjrJwtL0qjrwv8US7iQ=;
        b=YTe13GKl9lWe6skb5YbDfXLSkj/iGKDyueQKrJUjL+6+4T1ZAsdiS/4fYuWK7bXdg2
         W8uozusv0iL0QEeK6Kh8z+fjCsLPCthIakd1M9zmbYgWSEpmrDn50+iOscBvhzbBuIXI
         ByuG1G3yGBqGX1ER/Sg0dmeGDw+CtowaQlVm8NgsJt+uhpwIfgfiWu7jAjOmdg4pd9GC
         78jwYRsXFpc+ZT5Vf557CKe6UC9cyVMcs4kcAdDnPP+gzzaC3IsLVKBUzad/KEqSqBIt
         4a/OSd7vj+4rS+zJPgENaffUXG1KEYxrEbu7bpoDthOgFalrGn781LGfrV+3yR5K20D0
         jLCw==
X-Gm-Message-State: APjAAAXP1cJaan9YpuNLXhO7ohDyIfBVmgXD3rjxR2bTrQ5ne8R6qXPK
        U8mY0JydaR23F/Ifly7whIVsAtGjZU7zoA==
X-Google-Smtp-Source: APXvYqwgPBuynYJEHx2/WaFgPiC0rtGSfzIk2xQoITAfUg9cwqe9rZ1Qjwt5tSzcvN+GFu3GC54dGw==
X-Received: by 2002:a0c:f412:: with SMTP id h18mr7976595qvl.124.1579268891279;
        Fri, 17 Jan 2020 05:48:11 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r28sm13325784qtr.3.2020.01.17.05.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:48:10 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 06/43] btrfs: kill btrfs_read_fs_root
Date:   Fri, 17 Jan 2020 08:47:21 -0500
Message-Id: <20200117134758.41494-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117134758.41494-1-josef@toxicpanda.com>
References: <20200117134758.41494-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All helpers should either be using btrfs_get_fs_root() or
btrfs_read_tree_root().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 13 +------------
 fs/btrfs/disk-io.h |  2 --
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 136a4d9d5fed..99755d013dab 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1437,17 +1437,6 @@ struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	goto out;
 }
 
-struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
-				      struct btrfs_key *location)
-{
-	struct btrfs_root *root;
-
-	root = btrfs_read_tree_root(tree_root, location);
-	if (IS_ERR(root))
-		return root;
-	return root;
-}
-
 int btrfs_init_fs_root(struct btrfs_root *root)
 {
 	int ret;
@@ -1568,7 +1557,7 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 		return root;
 	}
 
-	root = btrfs_read_fs_root(fs_info->tree_root, location);
+	root = btrfs_read_tree_root(fs_info->tree_root, location);
 	if (IS_ERR(root))
 		return root;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 158fec0eeef2..4e43bd37f9c5 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -60,8 +60,6 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 					struct btrfs_key *key);
-struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
-				      struct btrfs_key *location);
 int btrfs_init_fs_root(struct btrfs_root *root);
 struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
 					u64 root_id);
-- 
2.24.1

