Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21994C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7FA215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XsW1EyeU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF7FA215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbeI1RmS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43566 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id q41-v6so1329473qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=unYdeV0h0D7vZF7/WYt36r/3Sg+lYY+VUgHQLhqzUMw=;
        b=XsW1EyeUClvQ8Ps1JysRieIV87VDLs0ErMS+B7yT4CeDndSP7K1nVKLn3/Kx6NjMUY
         Amx5EIRgVfuNxFszFMLiI4SIMeyTQVzK2k7KZ7BSXEWO1Qc1APUbXt82Na6EH2mSK6dE
         6aIpVHd64hSZJ5fx5vkWnrWG+82eT1LXhT8USmnrJeOjAClPrRqTOpYgqfzyFYT9nbkF
         PyysXX4M5rV7tKe7OAGGNIJcYpDWQyPNxO4b8kXq611oHBZza81qUidarcQn2rpBadEc
         UQ8+qN+AvYCAvw2nN1sX0shTTj3Njkt/g+MbTEFaZ0l55U1+OSzh5/hMdnOeqr5P636c
         v4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=unYdeV0h0D7vZF7/WYt36r/3Sg+lYY+VUgHQLhqzUMw=;
        b=nYzaifeeuoCRjzXAuN6ap6NOjCRySzR8b6PftT95OQ8n7svjT3FxGAWivyRNxTja2q
         nip5ccs8sNucIBzzIOHt5XBs9YrE8RtHf0mLn/DNxEluQPLoKOcKs6yuewIXnw4LAUac
         2P09hYcTUe4ne3FSTIJPebTI1uJBKmDbi+ruyoEquF1TFlBc+2sbfPKo+cCXsm0M6cdp
         N8wEko/N1ikxy19Vov7SkqviLIgMLR03ODS+UVxVN3r/hqC+ufVZpVONyuNsPnULH5c2
         Ml/Yjd72jLPzSPaXbU4Hp8UidwD8LshZVgCCRHsmD6CVh5OPXFtyBBm5EhC4oTdlcZaf
         GK2A==
X-Gm-Message-State: ABuFfoj49YhLNK7o7DEOLmYNP49RYtYOd/Gdho6L2uRhCS2i/EUkvGIp
        yRqLsc/VP5pQ91VnrB2nKt/8+w==
X-Google-Smtp-Source: ACcGV61bawu+SWB9HFk6xAA6D9xUrcpKtG3BusKM3WIeBc6la9louPV0fmn0unFm3JsZ2dWX0OEJKg==
X-Received: by 2002:ac8:3ac3:: with SMTP id x61-v6mr2585262qte.85.1538133540738;
        Fri, 28 Sep 2018 04:19:00 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k126-v6sm2587158qkb.91.2018.09.28.04.18.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:59 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 19/42] btrfs: set max_extent_size properly
Date:   Fri, 28 Sep 2018 07:17:58 -0400
Message-Id: <20180928111821.24376-20-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

