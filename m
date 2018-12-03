Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD27C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AC820834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="df6/LLql"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22AC820834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbeLCPZL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:11 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36223 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:11 -0500
Received: by mail-yb1-f196.google.com with SMTP id w203so1586222ybg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=iwTvMK0gGUVyoCFdtpRx1Deu3QpUxgWMXXQOJa7rTfc=;
        b=df6/LLqlRqmZrEbseIBgfVFgwLLvVFigTNWVI09G541xHSrrfByBgRB6fGAAUBF+v7
         b3sxhrC1bHSMwb4uzM/gVVxXpZ7cWkGYyVXECSlOmXSWBcqXpsP/q+yQ6QIra8fNM+TP
         /aceNtKfPvhepQm1tldHrWNuP4WZAoeNg2HPvuZiHCLzqIrRDFlx9QWB8mE50Yy9fFsF
         g12WWOakI1kaUvEqESxtM+pJpxG7+2N9cd1b6nuRReTPGBdXMkKnR9kGrFbqC+FE8m1A
         JpJtIf+RwpWbwr/lKYuOLz332fhfR8NFqyqzby74i3X2qVzhkHL+Hn2OvN3vPXoRKYDO
         9tVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=iwTvMK0gGUVyoCFdtpRx1Deu3QpUxgWMXXQOJa7rTfc=;
        b=k/pJX2hCM0XChZmwq2HNhPvVhqkXd+KNacYNIozv7W+w7Zqalo0zJdjz3sUJSbQI3A
         /si0wF0KCeIhduvRT+u8aP6HISHEu7ePYb95txt5kcsfpOkYWWtygoCxd9u7RoyV+gTh
         sN9T4RAYfa2W5zL9OD/aqAoHaJjqDIx2ywH2vUsCwJjpkqpba/cwX0C4QInNAuX9ZZxm
         cnU1xOyUFvUEKk0pHDZo8Cmh4rajRg3A/fJT4EgrDV/Quqt7rQMdIDKQUNP/YWpOQyce
         JJmbgbtWo8vPLgb1vkZewglRNfLNDC0PmaHHh92WeVg3DVXARafoLWyQnjRLe3iSGRA9
         2pWA==
X-Gm-Message-State: AA+aEWYJ+dInAei3ybgBlfVie5SIgiB/T+rKg1zYLTDcgrGb3/3camwH
        TnVOHNuU2wRE0qJ9LKrPeh47+B0F2qI=
X-Google-Smtp-Source: AFSGD/Xmlkzyye6reICm+zF93dSwEiXNyJxeJhGwkDCagiRQZjdh1N9wzeBZOf48Y2aBPBHIskT3SQ==
X-Received: by 2002:a25:3005:: with SMTP id w5-v6mr15679085ybw.365.1543850708415;
        Mon, 03 Dec 2018 07:25:08 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s185sm1335636yws.69.2018.12.03.07.25.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:07 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 4/8] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Date:   Mon,  3 Dec 2018 10:24:55 -0500
Message-Id: <20181203152459.21630-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With my change to no longer take into account the global reserve for
metadata allocation chunks we have this side-effect for mixed block
group fs'es where we are no longer allocating enough chunks for the
data/metadata requirements.  To deal with this add a ALLOC_CHUNK_FORCE
step to the flushing state machine.  This will only get used if we've
already made a full loop through the flushing machinery and tried
committing the transaction.  If we have then we can try and force a
chunk allocation since we likely need it to make progress.  This
resolves the issues I was seeing with the mixed bg tests in xfstests
with my previous patch.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             |  3 ++-
 fs/btrfs/extent-tree.c       | 18 +++++++++++++++++-
 include/trace/events/btrfs.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 30da075c042e..7cf6ad021d81 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2750,7 +2750,8 @@ enum btrfs_flush_state {
 	FLUSH_DELALLOC		=	5,
 	FLUSH_DELALLOC_WAIT	=	6,
 	ALLOC_CHUNK		=	7,
-	COMMIT_TRANS		=	8,
+	ALLOC_CHUNK_FORCE	=	8,
+	COMMIT_TRANS		=	9,
 };
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 667b992d322d..2d0dd70570ca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4938,6 +4938,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		btrfs_end_transaction(trans);
 		break;
 	case ALLOC_CHUNK:
+	case ALLOC_CHUNK_FORCE:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -4945,7 +4946,9 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		}
 		ret = do_chunk_alloc(trans,
 				     btrfs_metadata_alloc_profile(fs_info),
-				     CHUNK_ALLOC_NO_FORCE);
+				     (state == ALLOC_CHUNK) ?
+				     CHUNK_ALLOC_NO_FORCE :
+				     CHUNK_ALLOC_FORCE);
 		btrfs_end_transaction(trans);
 		if (ret > 0 || ret == -ENOSPC)
 			ret = 0;
@@ -5081,6 +5084,19 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 				commit_cycles--;
 		}
 
+		/*
+		 * We don't want to force a chunk allocation until we've tried
+		 * pretty hard to reclaim space.  Think of the case where we
+		 * free'd up a bunch of space and so have a lot of pinned space
+		 * to reclaim.  We would rather use that than possibly create a
+		 * underutilized metadata chunk.  So if this is our first run
+		 * through the flushing state machine skip ALLOC_CHUNK_FORCE and
+		 * commit the transaction.  If nothing has changed the next go
+		 * around then we can force a chunk allocation.
+		 */
+		if (flush_state == ALLOC_CHUNK_FORCE && !commit_cycles)
+			flush_state++;
+
 		if (flush_state > COMMIT_TRANS) {
 			commit_cycles++;
 			if (commit_cycles > 2) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 63d1f9d8b8c7..dd0e6f8d6b6e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1051,6 +1051,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 		{ FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR"},	\
 		{ FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS"},		\
 		{ ALLOC_CHUNK,			"ALLOC_CHUNK"},			\
+		{ ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE"},		\
 		{ COMMIT_TRANS,			"COMMIT_TRANS"})
 
 TRACE_EVENT(btrfs_flush_space,
-- 
2.14.3

