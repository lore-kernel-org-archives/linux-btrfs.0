Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35FFC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD442087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JiA4tXB5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CD442087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbeJMDHQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39002 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:16 -0400
Received: by mail-qk1-f196.google.com with SMTP id q5-v6so8348083qki.6
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=SMLqLDnd0lkJbGe6WWsh7Fynol7PpuIRXW5wGtVdu70=;
        b=JiA4tXB5jnsd48iUHAZwfVJ6PUADW4w5Cuo7wzBIDS/iaJteAPuQCcN0ir4DGYRioH
         W1CcbJk49OqgAj8dccaNil4/VMrm7ZO1xfDpngrzjuFEMcaL1JjkAoSUfzqBHBywsYpm
         m4nVEYeZOzn2ksbh/0TYcPrHGy6uhC86nGsFfY5UBwLpH5Ub6QsJ4V1AIEFS6tfZbnl2
         u6is3DuiC2ccivYeu92WIwrobZULY2h4V1relhguvsbQTroJXksNByr1Hc1gCpquMJeM
         YOjOuMdDb6gefrwwXNSX2fl/+gDPdjkEpepiayibufuT/tz5yR7wfptrF366OWfcavWn
         CBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=SMLqLDnd0lkJbGe6WWsh7Fynol7PpuIRXW5wGtVdu70=;
        b=Y/lN8RstCkFcN7+GPEe0Xest/WP4mDOXx030VjOGfk0MTWT3HZAxDjq0yVyteG453m
         xrwFLx4pPP4t35nT6mjmL9Xi9aeBPXLlNURUJ16argXHHxqUFqYBaPrXgQxQjwgPASN9
         MBu4P0mUzFKpDRPeHKCTkymXCdOQgj4teWvJCxtINneHRnFl7Qs+0v4914fD4gt+vjtQ
         nLIJgnONjtA3epPwZ5ixzPI6vKvPKFCbBetAFIouv3xTjvdj9zoQs+6P7v1cfFNoXKQZ
         Ag1kaDEACcgbkbMbcUZUgC/gBarW1Dw6VoTqg9sN59Ot1N2J+vQfxKSimEG00QXO2GjD
         GjVw==
X-Gm-Message-State: ABuFfojG13tNmddBZ0FTw7tAdHstsjBMs+52/liaz5PZPilf+QoGGkL5
        jMZZKDaHfrfV3eWQjd1H3WqAoM93r8g=
X-Google-Smtp-Source: ACcGV619OoQMsl9ypAHr1JBEGTIuvbT/TIFiU4uFYT0zPqdwtNfoMWe3EEsinRLAUGXeuRuKEP84Ew==
X-Received: by 2002:a37:2b8d:: with SMTP id r13-v6mr6762818qkr.259.1539372794883;
        Fri, 12 Oct 2018 12:33:14 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w81-v6sm1645347qka.87.2018.10.12.12.33.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:13 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 08/42] btrfs: dump block_rsv whe dumping space info
Date:   Fri, 12 Oct 2018 15:32:22 -0400
Message-Id: <20181012193256.13735-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 4aab49debfc3..8b00c658deb3 100644
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

