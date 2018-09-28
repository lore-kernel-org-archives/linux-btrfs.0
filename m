Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A607C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6E3215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="K7XZJUnT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A6E3215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbeI1Rl6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:58 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34987 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id z14-v6so6183533qtn.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=rkuApPuIkmKt2plAeQOPYfOXk6MNyqgwWrbGueCragM=;
        b=K7XZJUnTzbtV4H88ycFBxSCsRcDYYILLLzEdYCMt03gkkIzhTVR3sJJUMmptXTtfsg
         NbN0vvVXQ7lmdVZQAwTDkD0YnGRDBj2rigrD3DDp1HAHoeTXx3hzlgQ3HKvnn/+0ShWJ
         WR8lFZ8nc79dKRBiD8+rZ6hJFfHH5xMwsuu9K9DG46vnr9KZJZFUJYX7Z1U1vEgd7lmT
         NxrR6P5vXEW4DbUR1QonPPdQHgCXh6mv/zOB936oPsZTgO8+3J+Ghyhype/wH5EAyFLG
         Jgm3OsVBjKkJ6AYoHSumSupi+bhIZ/eRTsdcv/w7IQVkMJpaGusYTu7yK3eqlS5P9XcE
         3ryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=rkuApPuIkmKt2plAeQOPYfOXk6MNyqgwWrbGueCragM=;
        b=PGKCiQjsBRjvqdYCnMhT6j6+3xVWEgR3pFhxBhdg6wOwKGwFA22NbBGNdMIPLqJ7/G
         Ju+dzNE8v2hTOplxcQFIskWh9EYBPO3ARc1rpzotULsD2L0NLAiOdrMEbDxuoGnvA1bd
         g0sID2y9AlvAnHRScNXDOHM7Z5twqVUo9xU626tMdfDF6OwUKPLMrJ1InZvNj6vzdSlk
         t0vpaI78NnVZTEsAIicyikMvc3HYIRiLb3ZlrXegClPkOfwdrYJgZdFpfego6yFB+7Kw
         gNnx18YzbrKKKPuMs5RvRBzA72aY8jITbH4pnl6HSriWbRllrNu3LzENCEhiDmqVKRhV
         bdoA==
X-Gm-Message-State: ABuFfog+PpdRExo+cs4rq0irwbcaD8yhvDb7QbJLVui0XzEdU76NpkFY
        E45p4PAJk/oFXfF5nrXNqrR0L/LvDus=
X-Google-Smtp-Source: ACcGV62Byyeam3x3ZNKuM4dQjkZoVcQGKRUtSOUJDzyxAWIspRpUjCXaw+/Cn2Dvksx9txMYvdMiXg==
X-Received: by 2002:a0c:9e2a:: with SMTP id p42-v6mr11431093qve.54.1538133520350;
        Fri, 28 Sep 2018 04:18:40 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f10-v6sm2387876qtq.52.2018.09.28.04.18.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:39 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/42] btrfs: dump block_rsv whe dumping space info
Date:   Fri, 28 Sep 2018 07:17:47 -0400
Message-Id: <20180928111821.24376-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
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

