Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C820C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3067720835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jJGlwfg2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3067720835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbeJLDX6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:58 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38035 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDX6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9-v6so11356198qtf.5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u9vRDoMMODgf2y/Ifp4zyo+ltN+0lwuXKLQSeAL0348=;
        b=jJGlwfg2RhpGa7yu/J7ug1ujoStRxyRpcVVadnqBIsZkUY38V5XODQFz6fWXVd0mh9
         vus2TNdUYxO4DktkGkiZez+oR5+px1mTPj9yeo+eYVY5BGWtpioGTxr6uv1EJUdGpjHS
         XycmPq3C/WsudF1Hj+e0hwOdyzgJ776ApPAGMvQfHu1Z3GrdiOWhn/j4K7TvbklXM9dV
         3wALgGku+SGkha+Emb0N7Bss9uQB0UG2+0BuklrZl/Eq4f6Ubmm0G4EvIg8jryg92/GI
         MZ8sLhr9QN0uHRx3rsv0dfqLB12Eyz/ajg0e3dvexcR0GAhAJbt8jlxwHhsV3b5ogOuA
         3YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u9vRDoMMODgf2y/Ifp4zyo+ltN+0lwuXKLQSeAL0348=;
        b=CoUiOQSXQ9FHGtLIyfE7G5Reqi/vNCfxZKIathgQrB175k3ZFVufXZceN3Z8akAUBL
         he1ngqbU4SeNy8XQL5AXe6q53rXhiiN0XhGluhQ6PrVo+usSYwNJGr9SIBNvgCRJTuTu
         9ChkQxKsw9GAr9sTfN3ADYDKPqc4tggWCQBqRwVVCfhcOug98PwR3bMBbILv5rcoVJbi
         9G0VF1EzYTb8QByWhGjoXAVLcwbuwMttP7iPLCpkNLGHyl3KzKjB4exZoES2IHsugCzt
         RzJ/E+nA+MNCIJNDvC+MDM4gEQfftCySklygwNaznZKbiOhlN1OIMspeliZqq6aLHBjc
         XYDw==
X-Gm-Message-State: ABuFfojP/MJiaxOv85o7yTy1VC9jQQIIpAKc4rU0Z08dYgRkljDhzkTm
        5UJjXdVFgIZ6hA29RrV+wFvFKugnayA=
X-Google-Smtp-Source: ACcGV60uIe+3RVv6bNq5OM0uJLt4h/l+XuCLsyLKwct0ysB5HLyh+eDEEQaW5K03wAZxe3bnTe0FCQ==
X-Received: by 2002:a0c:b29d:: with SMTP id r29-v6mr2950126qve.70.1539287711935;
        Thu, 11 Oct 2018 12:55:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c8-v6sm10982505qkb.81.2018.10.11.12.55.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:10 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 20/42] btrfs: don't use ctl->free_space for max_extent_size
Date:   Thu, 11 Oct 2018 15:54:09 -0400
Message-Id: <20181011195431.3441-21-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 6e7bc3197737..4f48d047a1ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7496,6 +7496,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
+	u64 max_free_space = 0;
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -7791,8 +7792,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
@@ -7959,6 +7960,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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

