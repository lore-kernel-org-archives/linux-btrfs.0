Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253E4C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E130B2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="oPkG/N9G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E130B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbeJMDIR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:17 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40369 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeJMDIQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:16 -0400
Received: by mail-qk1-f196.google.com with SMTP id a13-v6so8345884qkc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=oPkG/N9GSND2Hn2d4ZXschpHbq9qm0Q/I76A1Zi5E1rGHy6ENLGgqD5gBFZrdKWlQM
         NK1FgM2/N9gfTmAn1S81IvSBGPjvgVy6REnwo78ca9buuB3iNvsxEeAhY5b4Pb3wDADP
         Gbpx5bJgKFqoy2+DCntfoAlpsOHLgdwLimMJ6IhsEjtnSAIh9te1B5zq13m4MVTWTvDm
         fGwL1lerBWW11aRDFxxUAnoZLRAiXj9nmtxRrlFgNNZ/NFeUTg4unWBjFPgFIbPcUflZ
         Q7yKeDueIcj8eZPT6hRL9T2FrHfuor9S1qmJvLXFXeuhtHBWC99dc524iT6f6BiFHVV9
         BaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=OqfLtFnbR7obkJg2YFDtP7QAbr83A4ueCI5fQlSXYm/hR1UKLQOvlTaV/Jk1AJMoLl
         gbGHdV826/pJULN07FRwMTrGjwIzztK5WxZ27kwzX7EeARr7Wn7bVsf1s8xQ/kwZER12
         FYKqnNu3/G2ng0awk+9Ccgk3TAWxo0ADd+l8ZdYQ85njnU0hRMVqDd8/bDWJiDnzlpIu
         zWY0cVZp0l/x1IU0XUd7GQul/sg84JRCESt+uOiI9wpQY8a9rPqEq87KZViR+I9Olu95
         46AXOCF8+bttljotYzUSUYHe8vBysOL/PcXfod1jNbLOXpm3OmW2Y32HyXITn8sHg+Qb
         3maQ==
X-Gm-Message-State: ABuFfoiOvQQPfeU3iZEZOuWKuljddwAw0FfZ/3KqDj6c2HFOeS1wzqfv
        voM0T/0Y2Vf/S8lO5Qjv/0DzoV3T+Ps=
X-Google-Smtp-Source: ACcGV63CVQoPGc5OIrfbu1vYe56DWVD9X64kArsv0y0oRABiEXxZ/LpzDSgK98MKkfiuSQ0vofI+CA==
X-Received: by 2002:ae9:e30e:: with SMTP id v14-v6mr7098104qkf.356.1539372855768;
        Fri, 12 Oct 2018 12:34:15 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m64-v6sm1209232qkf.18.2018.10.12.12.34.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:14 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 34/42] btrfs: wait on ordered extents on abort cleanup
Date:   Fri, 12 Oct 2018 15:32:48 -0400
Message-Id: <20181012193256.13735-35-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we flip read-only before we initiate writeback on all dirty pages for
ordered extents we've created then we'll have ordered extents left over
on umount, which results in all sorts of bad things happening.  Fix this
by making sure we wait on ordered extents if we have to do the aborted
transaction cleanup stuff.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54fbdc944a3f..51b2a5bf25e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4188,6 +4188,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 		spin_lock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
+
+	/*
+	 * We need this here because if we've been flipped read-only we won't
+	 * get sync() from the umount, so we need to make sure any ordered
+	 * extents that haven't had their dirty pages IO start writeout yet
+	 * actually get run and error out properly.
+	 */
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-- 
2.14.3

