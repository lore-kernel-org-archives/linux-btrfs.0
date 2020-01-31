Return-Path: <SRS0=Umwe=3U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82ACC3F68F
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jan 2020 22:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83DC20CC7
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jan 2020 22:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DZcWOy/5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgAaWg0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 17:36:26 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36019 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgAaWgZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Jan 2020 17:36:25 -0500
Received: by mail-qk1-f193.google.com with SMTP id w25so8247835qki.3
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2020 14:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oPYxQWUatMHclwU0kDL2t7eqZfxhtfFwQr2wE2TCs3Q=;
        b=DZcWOy/5mIaQ7MAun3PqoOnliM6uppmfy+IM+afr+Vr/cdX1+QQeJvWAMpvcUNZQ35
         sbRgM/kL1bATvl/v4LqIW+/sch92wBf+fjueNSlFewdU1i3CAQxXCK35vPt0kDHb2Gy3
         ALLqJfiKuvJ3BGBQBOL7O3YVQAsyWtSUDoqIjnSxpWvI1yHPbJ3lpQVKVwYuzngQenlP
         oPziWvQ+HXrU4WVxe+SxZoUXedrfJRIcRF2JAyglhx3MHh539tSsApID+ZCvqQkSBnM5
         g5iUMaZizw79tR2bWm4x9XAnNO3CLRONJdXcX6q2DcMVTEDGQIhsV7hdX93aJCmHaiJa
         /6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPYxQWUatMHclwU0kDL2t7eqZfxhtfFwQr2wE2TCs3Q=;
        b=RYawt2BaK70K00PTCQe2F9AyNNcG4UPQ5+IFzmKKv+Soq2XooD1gH6LI9nJ3Nnn0Ex
         d7v0EuNOP449tGrqVxkA7bf/dg6OrtgrWIJJVyEbll6O67RAiVuO++QTPnu9uRAqg/hf
         2RntUiW37sJ1b7DFYyblSibJ+FI1rh939DSHYr6eAzTATW2kmadWIdznMM4VVQCsQb7Y
         6xT+ZqNdIQXUkkQNElbVfxh8fbaDoN4aQwzPYs3eIRTjlKARWmEfREFV5yyCiochcD1+
         fP664FArq6ZqzN+kqRc4PQYH2DJrXrUEpLFDd9bSvkMw3jwrMy6saIoFxEptfHNoGkow
         xRSQ==
X-Gm-Message-State: APjAAAVU7BwQEeKEKD416kamLbKzeqFns3NcGMBMahmgty8FeUwsVWsA
        O8/QE8dC98WcdiemW0eUJ6BUQk4Ljqr8HQ==
X-Google-Smtp-Source: APXvYqxsOmGl6ipuyb1SXFYM5CM2Y8dbZ6UgOrwcVRjhlwvUz2RUheBGz+DAj6Qct/9Iaqo1yNN21A==
X-Received: by 2002:a37:7685:: with SMTP id r127mr13352484qkc.166.1580510183459;
        Fri, 31 Jan 2020 14:36:23 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z34sm5712947qtd.42.2020.01.31.14.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:36:22 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/23] btrfs: make shrink_delalloc take space_info as an arg
Date:   Fri, 31 Jan 2020 17:35:54 -0500
Message-Id: <20200131223613.490779-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131223613.490779-1-josef@toxicpanda.com>
References: <20200131223613.490779-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently shrink_delalloc just looks up the metadata space info, but
this won't work if we're trying to reclaim space for data chunks.  We
get the right space_info we want passed into flush_space, so simply pass
that along to shrink_delalloc.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/space-info.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 924cee245e4a..17e2b5a53cb5 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -349,10 +349,10 @@ static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
 /*
  * shrink metadata reservation for delalloc
  */
-static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
-			    bool wait_ordered)
+static void shrink_delalloc(struct btrfs_fs_info *fs_info,
+			    struct btrfs_space_info *space_info,
+			    u64 to_reclaim, bool wait_ordered)
 {
-	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
 	u64 delalloc_bytes;
 	u64 dio_bytes;
@@ -378,7 +378,6 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 	}
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
-	space_info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 
 	delalloc_bytes = percpu_counter_sum_positive(
 						&fs_info->delalloc_bytes);
@@ -580,7 +579,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(fs_info, num_bytes,
+		shrink_delalloc(fs_info, space_info, num_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
 	case FLUSH_DELAYED_REFS_NR:
-- 
2.24.1

