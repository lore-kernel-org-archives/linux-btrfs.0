Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEDBC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2304620835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Ifri+2a6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2304620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbeJLDXf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:35 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35201 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:35 -0400
Received: by mail-qt1-f193.google.com with SMTP id v19-v6so11357204qtg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=lr4oPNsJzTCgyemE9htPT5VmmZwFNCKLK46w3mgICjE=;
        b=Ifri+2a6WTOu9XtHQCNpcURG4yU7x9WaMeqe8xf6GBJxTQzrSKQroWKHgjamhjM8LP
         Hoi8V0Yt1swnUTSFhiRNCbZV/dvqK8mYOVx3vqLE5NNJR9t8fn7ap99om4JQ+/EU8wOk
         gQkrqcxde4bmBPuwTO382aBquX8dMe3PBQ76wLKy6I0OIADhKuNv7uz5PRvtcBmcgZH9
         IHbCpfu223BYaSu+Ep7B47vLZhglygkbINvCKwJ8XP/M2O2Qnq3/ScHz5aklv0zch1Fd
         CNUl/IK+9dnDpvvbzo5+Yeax53jPPyS9wKhJhp642W0Bkay9UMJtcERTODqYuMUmvs1O
         uwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=lr4oPNsJzTCgyemE9htPT5VmmZwFNCKLK46w3mgICjE=;
        b=AGRq6msAwDocvcNyAT7f3Ai9l5DbYlPx7hkiOrQvJ/El80lG4YT+0xnuSjBLxdz3Xb
         1jWsDcPIYjE4/Ih6h9FD8/VcO8vvTIVL8dj+90x1LJRWQfQ7xKO0Tb1xWb/ZfLLNDY8p
         N4sTIOiD5mF/q6hHjZ+PyN+aLuwf62t5faSBs9cd/spTVsXXYSNpmidVyB11OYkCadwb
         vpN1QP9LE0/3tv69CPCqGZvUwVp1xo01XCzsPhveey2hshZbHmdUf058wRq6SsaS9wnI
         XWeMZ3sutbuUD45AzmlRZ/daW/JuQ5+TOeyL7/DEJ2VsDv5vJe/Br2lKjtBTBfweWmVf
         NGAA==
X-Gm-Message-State: ABuFfojOfGpvPp/V1/SJTlbtAe0W7/eT9K4L1PIgYnIjQ2ogILMH25jx
        hVNp8C2DvfuvE9WqOl0bjJ4mhnnAki4=
X-Google-Smtp-Source: ACcGV636oLkonoK2QNe+nNEiZA25yyC5KFAzkSNuz1ckplz8fQ9rVp/xTwJmvc7uSubL20U+PPGmPg==
X-Received: by 2002:a0c:997a:: with SMTP id i55-v6mr3132449qvd.71.1539287689025;
        Thu, 11 Oct 2018 12:54:49 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c44-v6sm17790093qtb.53.2018.10.11.12.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:48 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/42] btrfs: dump block_rsv whe dumping space info
Date:   Thu, 11 Oct 2018 15:53:57 -0400
Message-Id: <20181011195431.3441-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index da73b3e5bc39..c9913c59686b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7918,6 +7918,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
@@ -7937,6 +7946,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
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

