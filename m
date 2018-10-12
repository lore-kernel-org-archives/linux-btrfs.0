Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72E6C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A279F2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="L+N44KSl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A279F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbeJMDHp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:45 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43449 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbeJMDHp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:45 -0400
Received: by mail-qk1-f195.google.com with SMTP id 12-v6so8330285qkj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YPU1+9kFJB8jUn5q1U/VWyfL9ar9cpfy/opBHehMoyg=;
        b=L+N44KSlgTRVrVQY1oPt+aLD38/F4sM/0E+fygpe1dD49axIO2HGoquHCGsBZgwwiq
         74bl1EQ1sScwV3DMs7uB0bN8jPYuJybBUd0JJkK2OtdHs9jgIbRAU0ETD2gZTaz7Aq26
         WuSSXXrdB39iwh0Xy8nBBDkZA9wwjC/s4dJsDENM9LUyC09NxmhUwa7G/pGF/EV9EICC
         DCMh1mOPCuA051IaVWnVLhOWdIUcFsL+PISP91J/mk+ccFHMGc3B0vZhzbWQ2o7H2McC
         lX2pT+Zke720omGJRdYqf4GRnRY/YFJpieocCt52wdrzcbWFh2y5DlOM5kQL5Br6BwW2
         fPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YPU1+9kFJB8jUn5q1U/VWyfL9ar9cpfy/opBHehMoyg=;
        b=BgSgkdA+NtRzQx9BuHVzZj9UP8PsFZQmcalkhrZUHdb/VDWMDjfyd0HqvkuQfwSDPC
         gkaFGwPor8NrIom3hzDVuwliBrrKI2yFv8u+S3YP0/USpHLwHCpxnFTJjWcRZevOr4nT
         rp7g2pWofmbaZwd6hSiUCipWEZXB6QOpqrIXIqp59RZZKO3Si7/g44mFQll3Z5D2vTZW
         RlJvV21pXHl/cNGW7jaIux0NEPolkc6sb4Mv3T/Kl/la4fiQ2X26rstFZ56lTgSncL1+
         IyBOf5iuol5xJWzLwUJZtuyr58UPV/dJaAg06+Enu0RZvOtRvT9LL0GyDqPW79f30jTA
         ME1g==
X-Gm-Message-State: ABuFfoij/yEelYpSsdI083PYELgnX7AUZ5QPzp52nO747gMwDVDp3z9K
        WnF6phYSSPvl1GK7yrwU9kYTb8okek4=
X-Google-Smtp-Source: ACcGV62mEs9B1W6pTtcUop2PEkIfOWAwEu4aGi+NooXnNRXRRpBRdb/pNwpk96YaO3y75bunHQsj9w==
X-Received: by 2002:a37:ba42:: with SMTP id k63-v6mr7048989qkf.103.1539372823809;
        Fri, 12 Oct 2018 12:33:43 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d12-v6sm1528890qte.75.2018.10.12.12.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:42 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 19/42] btrfs: set max_extent_size properly
Date:   Fri, 12 Oct 2018 15:32:33 -0400
Message-Id: <20181012193256.13735-20-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
 fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e077ad3b4549..2dd773e96530 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1770,6 +1770,13 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	return -1;
 }
 
+static inline u64 get_max_extent_size(struct btrfs_free_space *entry)
+{
+	if (entry->bitmap)
+		return entry->max_extent_size;
+	return entry->bytes;
+}
+
 /* Cache the size of the max extent in bytes */
 static struct btrfs_free_space *
 find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
@@ -1791,8 +1798,8 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 	for (node = &entry->offset_index; node; node = rb_next(node)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		if (entry->bytes < *bytes) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			*max_extent_size = max(get_max_extent_size(entry),
+					       *max_extent_size);
 			continue;
 		}
 
@@ -1810,8 +1817,8 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		}
 
 		if (entry->bytes < *bytes + align_off) {
-			if (entry->bytes > *max_extent_size)
-				*max_extent_size = entry->bytes;
+			*max_extent_size = max(get_max_extent_size(entry),
+					       *max_extent_size);
 			continue;
 		}
 
@@ -1823,8 +1830,10 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 				*offset = tmp;
 				*bytes = size;
 				return entry;
-			} else if (size > *max_extent_size) {
-				*max_extent_size = size;
+			} else {
+				*max_extent_size =
+					max(get_max_extent_size(entry),
+					    *max_extent_size);
 			}
 			continue;
 		}
@@ -2684,8 +2693,8 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	err = search_bitmap(ctl, entry, &search_start, &search_bytes, true);
 	if (err) {
-		if (search_bytes > *max_extent_size)
-			*max_extent_size = search_bytes;
+		*max_extent_size = max(get_max_extent_size(entry),
+				       *max_extent_size);
 		return 0;
 	}
 
@@ -2722,8 +2731,9 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	while (1) {
-		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
-			*max_extent_size = entry->bytes;
+		if (entry->bytes < bytes)
+			*max_extent_size = max(get_max_extent_size(entry),
+					       *max_extent_size);
 
 		if (entry->bytes < bytes ||
 		    (!entry->bitmap && entry->offset < min_start)) {
-- 
2.14.3

