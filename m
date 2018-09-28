Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3D9C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6D0215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BmHiG9g7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F6D0215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbeI1RmH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:07 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45313 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:07 -0400
Received: by mail-qt1-f195.google.com with SMTP id l2-v6so6092683qtr.12
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=aHABd3s47VJA+IGNtJA9Inn+i4GdiqS25/qy6diaJ4I=;
        b=BmHiG9g7knyfBbRejaYbMKh3Y0flDf0Sdb9fWMyFTfiBYmR9hlSVA1oUcl7SwyJ8xf
         l9q12YsynxEVw19MBcvu9RJVvSnPSRytE7gU+N9bzTZ1q1oTawxPRSnD77YTASrdJ7+D
         u+l6Zo56993yh5zsebH8GNvfKwsS2mgIimTvsk7EeG1zMrhFz1KdJbIDBc5HxtiH+43M
         n315NWcw1kSd/RzbcLfaVhUzgV2H3w/eeCptX8W0kKEF+G6yBkMgURssqno79HBGlUFD
         2HxLeORPiFjJ93Q/9fI3HmtA8ZiCLjJGq4xKBQn26R2YWpzavOHzskFFtlAI5cjMI8kU
         jZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=aHABd3s47VJA+IGNtJA9Inn+i4GdiqS25/qy6diaJ4I=;
        b=jVIBiBLV8iq5bJmaaKOw/Iu9lsal2DYYH/XfiYLSxCKlwnRD0VeGW0PZrCxrezat7D
         nuWFOseMcZgBwBxBFkxO2v2rSYYvjPhSpemorDZX9LWkLq2oGqeLjeLTBIXi7b52d+sP
         4rSIbzPtRWH66OI1BQ3Sh4vp+NXPl+ucyS9W85+OxPr6FIQ4FI7NId+PPY4yBMqmjLIS
         XEtgudM6YiMx/td17iFyiFe8/uivsyA6gn4N/JqVR83PB3H3woFIQyLxnMfKlWLy32a1
         z4kh6Elhjqtf13iz6NB92DLyalefvv2UzWMf3eV6jcBHrwDSlUCkBdxfGql1N8adrOM6
         I0EQ==
X-Gm-Message-State: ABuFfohIDqVGVhB+eZl2GUSwFqGivy7J70L1wopqipvdHzfiSYDKiwyj
        A1SmXaFanum6HZn1m+HN+XQFYnPo0Ww=
X-Google-Smtp-Source: ACcGV63bhhCdHMmvvV6wg0P2euP3aL5WmgttnIXS0ZDoojnx4Uw7KavQPqw0HR8XLL51ny9j4HTSug==
X-Received: by 2002:ac8:2866:: with SMTP id 35-v6mr12183272qtr.18.1538133529633;
        Fri, 28 Sep 2018 04:18:49 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l24-v6sm2528065qtk.85.2018.09.28.04.18.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:48 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 13/42] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Date:   Fri, 28 Sep 2018 07:17:52 -0400
Message-Id: <20180928111821.24376-14-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             |  3 ++-
 fs/btrfs/extent-tree.c       | 18 +++++++++++++++++-
 include/trace/events/btrfs.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a2c3b629af2..29db902511c1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2730,7 +2730,8 @@ enum btrfs_flush_state {
 	FLUSH_DELALLOC		=	5,
 	FLUSH_DELALLOC_WAIT	=	6,
 	ALLOC_CHUNK		=	7,
-	COMMIT_TRANS		=	8,
+	ALLOC_CHUNK_FORCE	=	8,
+	COMMIT_TRANS		=	9,
 };
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c0f6110419b2..cd2280962c8c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4914,6 +4914,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		btrfs_end_transaction(trans);
 		break;
 	case ALLOC_CHUNK:
+	case ALLOC_CHUNK_FORCE:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -4921,7 +4922,9 @@ static void flush_space(struct btrfs_fs_info *fs_info,
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
@@ -5057,6 +5060,19 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
index 7d205e50b09c..fdb23181b5b7 100644
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

