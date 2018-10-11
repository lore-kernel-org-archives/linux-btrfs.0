Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE36C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E5220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="eZ42Hfhc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05E5220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeJLDX4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44996 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDX4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id c56-v6so11328292qtd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=unYdeV0h0D7vZF7/WYt36r/3Sg+lYY+VUgHQLhqzUMw=;
        b=eZ42HfhcqWQUvBF2Yinm8WUofbjgnWa8MGrmWZ4pFMpqPcoJJ//XvMBncqJCefAuj0
         lsgtquwQbZmYEFR4g32MuEcUF/NBewQIp15lEl1T3vRujBaUQ1CzG3RWUCZTVnMg5R5v
         0Q5GXimGYlqj4SjlTctv2x5QS9YhMMfgNmJQnKNIswSAOFg2gK+xgxSBLMc8qJdIUmoD
         u8WqDg9sezB/8GGJF6KN7fnT7FLwthl6+Z4r4X1HCIO7147y3mLTnqxcmUvUynlJEodW
         /PV9J/CzbmyzZOHGpu/8rrae4/X/sWSGBaRrJ29E+c8K/doqAf9gES7utbf1JDqFfhxB
         cStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=unYdeV0h0D7vZF7/WYt36r/3Sg+lYY+VUgHQLhqzUMw=;
        b=hZA29Vufa9JQYgvhsAzi6TkVbyYDa3JqqTfZQ0oKVvliWTQE2ZqkSNsXh2Crga+FkR
         9Zof3r9mIXlr0p/cVkSfBTZnQz6elarOUenmeJ+zqOVYeQz0kM151sevvgaJyqEGmv4b
         lI1MhHN9A2e4VpbkgNcqoTmTwj9bygWlvYHpBA2UacHVW2ZJKUQjerYr/S+a3SE9rbA/
         jMLJgek5PF69XwefioDqze+z2K6+DJSv8sdRkJEMBnM1rf9DmbRuBKKrCopAALXWT+/a
         1aThJT37C3JT4FIKXyUzzGaUhWFPJM+GP6zAhaxASVb2RH7dTklyJJYsmCLGOsCLOTCO
         qskg==
X-Gm-Message-State: ABuFfojyQXM7/pVay0CgoWo82EPKmU7NuKrw514iA/ScTC19h3L96wwj
        GdTKvRgmOr1b4FHYJa4amW01rA==
X-Google-Smtp-Source: ACcGV60lS2TtmgK2ZvxZ+JZQ2EhPXvCkV3iv5fyCmxYBFSc2Phr6dsso8SKMtPwUDFc/RnVZVGYpZQ==
X-Received: by 2002:a0c:8545:: with SMTP id n63-v6mr3019575qva.205.1539287709990;
        Thu, 11 Oct 2018 12:55:09 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y26-v6sm13448316qty.52.2018.10.11.12.55.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 19/42] btrfs: set max_extent_size properly
Date:   Thu, 11 Oct 2018 15:54:08 -0400
Message-Id: <20181011195431.3441-20-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We can't use entry->bytes if our entry is a bitmap entry, we need to use
entry->max_extent_size in that case.  Fix up all the logic to make this
consistent.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/free-space-cache.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e077ad3b4549..2e96ee7da3ec 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1770,6 +1770,18 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	return -1;
 }
 
+static void set_max_extent_size(struct btrfs_free_space *entry,
+				u64 *max_extent_size)
+{
+	if (entry->bitmap) {
+		if (entry->max_extent_size > *max_extent_size)
+			*max_extent_size = entry->max_extent_size;
+	} else {
+		if (entry->bytes > *max_extent_size)
+			*max_extent_size = entry->bytes;
+	}
+}
+
 /* Cache the size of the max extent in bytes */
 static struct btrfs_free_space *
 find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
@@ -1791,8 +1803,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 	for (node = &entry->offset_index; node; node = rb_next(node)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		if (entry->bytes < *bytes) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			set_max_extent_size(entry, max_extent_size);
 			continue;
 		}
 
@@ -1810,8 +1821,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		}
 
 		if (entry->bytes < *bytes + align_off) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			set_max_extent_size(entry, max_extent_size);
 			continue;
 		}
 
@@ -1823,8 +1833,8 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 				*offset = tmp;
 				*bytes = size;
 				return entry;
-			} else if (size > *max_extent_size) {
-				*max_extent_size = size;
+			} else {
+				set_max_extent_size(entry, max_extent_size);
 			}
 			continue;
 		}
@@ -2684,8 +2694,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	err = search_bitmap(ctl, entry, &search_start, &search_bytes, true);
 	if (err) {
-		if (search_bytes > *max_extent_size)
-			*max_extent_size = search_bytes;
+		set_max_extent_size(entry, max_extent_size);
 		return 0;
 	}
 
@@ -2722,8 +2731,8 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	while (1) {
-		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
-			*max_extent_size = entry->bytes;
+		if (entry->bytes < bytes)
+			set_max_extent_size(entry, max_extent_size);
 
 		if (entry->bytes < bytes ||
 		    (!entry->bitmap && entry->offset < min_start)) {
-- 
2.14.3

