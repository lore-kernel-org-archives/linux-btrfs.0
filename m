Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBDDC11F66
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jun 2021 08:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E7861DC1
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jun 2021 08:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhF2IyI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jun 2021 04:54:08 -0400
Received: from m12-18.163.com ([220.181.12.18]:41754 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232429AbhF2IyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jun 2021 04:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Cue9Tz+26Mw1WyK0oj
        /mT043sOqq/LAAEDvO/pxLwCQ=; b=EyqH6XMLY1TTtVyEmyFSD4aYV+o91mSI+s
        n8CWW4x+GLv1huQ/R9oY+bNhguWjE0iWF7NzSJGSsPidluyM4DaB+CX3ZBPlDM32
        0y3UmQjyTfUg5hMnY8pmhJhY4Jd3u5NhKs95+b+NdRlPqjbYk6tBDC15Ygmf+al8
        ssVdR9nX8=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowADX3Mzm3tpg8GJEsA--.41226S2;
        Tue, 29 Jun 2021 16:50:47 +0800 (CST)
From:   lijian_8010a29@163.com
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] fs: btrfs: extent_map: removed unneeded variable
Date:   Tue, 29 Jun 2021 08:50:25 +0000
Message-Id: <20210629085025.98437-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EsCowADX3Mzm3tpg8GJEsA--.41226S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr45Jw43Aw15JrWUZw43KFg_yoWfCrb_JF
        4xAr97GF45Kw4Y9ryqkwnrXrWvqr4UuF1aq3yUtrnxAr1UXa1UZws2yrn8tayrCr4UAF9r
        GF4qqF1jkF1xujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5bmRUUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiHQfAUFSIrVxuhwAAsO
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: lijian <lijian@yulong.com>

removed unneeded variable 'ret'.

Signed-off-by: lijian <lijian@yulong.com>
---
 fs/btrfs/extent_map.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 4a8e02f7b6c7..70d3e76e30c5 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -296,7 +296,6 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 		       u64 gen)
 {
-	int ret = 0;
 	struct extent_map *em;
 	bool prealloc = false;
 
@@ -328,8 +327,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
-	return ret;
-
+	return 0;
 }
 
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em)
-- 
2.17.1


