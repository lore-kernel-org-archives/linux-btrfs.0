Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF0CC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01718215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="fRkvgD9T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01718215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbeI1RmU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36830 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id e26-v6so6167660qtq.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MzDmzB2k3QZIyenv0r3E5KuNr4U54ItlfnVj2WDyMrY=;
        b=fRkvgD9Tm5fiueF2TUbneyJxwl+/0Cowu0WADeq2v6arQSrd0LYfIBCINPBn3bvQq4
         8x8MmB9sgRVQVb55yq+TXPMnNqJkiwJqiWcT3BCDyVYKUOgjcC7B7pJx2mo9HHtmB0x/
         IVabXuodqC3t/H61F5I8K/2jA9SQ25LG1Hp4XS8CMp8K4+ms4BtA+u7Hsjlea9JXNLc0
         ig0ocS52GtGRq/4qYJl4XaQ348Ne0A5vOQdAp5GHz37huJwkXarIUMxkg7VhumVML8k6
         EIgj4j3fNU6jwnKNGl5cbhzeHImdFfoKNyOds2vmRdHesgTNm67ZL+ID7HJSFotD6zri
         5TGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MzDmzB2k3QZIyenv0r3E5KuNr4U54ItlfnVj2WDyMrY=;
        b=aHhupkjye97o5uxBcz+5dkph3EabsdGaY+Q95T9IqXhK++ffsv+qyF6XTAJerL4fHx
         We8pjWCiCuLEO7JOrfDtoKZcIiSc1L0Q422U7OPcbd+CjAEkv781EOYP1mT6k04Ky1wu
         senwZz20KI6O5uaDCZZ8MbL2/hNY0LMjF0PPreq0utpJwrfdnZ30EyVXwjgdwyd/HK9O
         LRMzZL1yNaafC64jFwmDLveIXDsOSqCmXxRQvNoCfVqvRMrl48rli15W9RAfN+gmBq25
         X8W39mJ4pe2Ise7u+31k54qPvLZXRR9beZyvZNOg3syLYjrPtZm1sU4rSuH48LALbmMw
         ITtw==
X-Gm-Message-State: ABuFfog8QJo/jBikQqz/yQQ4UnL0GLyEwq3zcAemwbkECAOnVoKVRpUC
        y6Y1FWT/k7WkR/X/Y9W0FWhKgw==
X-Google-Smtp-Source: ACcGV63NO/uep9xRQOix8R+JJuYaabg2d2U9ouTkivv0q4Y/luZsHE1hFGEydFHU6mUApeing+Pfvw==
X-Received: by 2002:aed:2c64:: with SMTP id f91-v6mr11819172qtd.310.1538133542543;
        Fri, 28 Sep 2018 04:19:02 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s73-v6sm3227842qkl.65.2018.09.28.04.19.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:01 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 20/42] btrfs: don't use ctl->free_space for max_extent_size
Date:   Fri, 28 Sep 2018 07:17:59 -0400
Message-Id: <20180928111821.24376-21-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

max_extent_size is supposed to be the largest contiguous range for the
space info, and ctl->free_space is the total free space in the block
group.  We need to keep track of these separately and _only_ use the
max_free_space if we don't have a max_extent_size, as that means our
original request was too large to search any of the block groups for and
therefore wouldn't have a max_extent_size set.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index eb64b28196b8..40503438ef6c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7492,6 +7492,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
+	u64 max_free_space = 0;
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -7787,8 +7788,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			spin_lock(&ctl->tree_lock);
 			if (ctl->free_space <
 			    num_bytes + empty_cluster + empty_size) {
-				if (ctl->free_space > max_extent_size)
-					max_extent_size = ctl->free_space;
+				max_free_space = max(max_free_space,
+						     ctl->free_space);
 				spin_unlock(&ctl->tree_lock);
 				goto loop;
 			}
@@ -7955,6 +7956,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret == -ENOSPC) {
+		if (!max_extent_size)
+			max_extent_size = max_free_space;
 		spin_lock(&space_info->lock);
 		space_info->max_extent_size = max_extent_size;
 		spin_unlock(&space_info->lock);
-- 
2.14.3

