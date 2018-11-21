Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB3BC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA21A214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="GP3jVao6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA21A214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbeKVFi4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:56 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41567 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFi4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:56 -0500
Received: by mail-yb1-f195.google.com with SMTP id t13-v6so2632871ybb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=0C6Y1CelPQxNMboOxlsh7yFIuIZxS7fsGHquMg4krs8=;
        b=GP3jVao6llel7QABb2qeNj5WObmWw0PQ7k6mDsb2y7iKJEss4Xk+SCn+V8Pc2R4en2
         y9pqwVAI4gPKoRCHpyiuOZE4eRiEbbk52kyxDuR5NKMT30VBbULr1mVsEr8JO/4zU/G/
         g0qK5/ETnPpwaYd7Ut9MvJ8QIQ4yHDU8A5p4JjKiroLH9wevZBxjD4IyN7iZKdopV1hm
         ftMOu3xqvUAAW8OmaglUhNW76R2xSYkgACb09UQ+eKzZ/XsK6Kbg7l7a9xjAk4xxY5I3
         s2iSzzzfui99YqIJ5R/mfOnciuYg0czjt4SKSBd0gfjuE8OoG3EUaqrAWJ4z2WJPABpl
         oLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=0C6Y1CelPQxNMboOxlsh7yFIuIZxS7fsGHquMg4krs8=;
        b=Fq6Z1euO6jwdBrlaBb/N86P72zwNLwN5W7yLyDURxr4tU8RCj3ZORGWhi0CMChN3o7
         soFwlnqg0IB10vR/RZmKkT1KMGinuNznTECkHbY/RdNpy9rIMDNAbWWtE4af9S0A8TWa
         ZK4N0+1wesYrmkfX14d1n15aENRwWLWWHhIB0g08nrSlTqctgqCAwcNXgPh8c0fuGrSm
         9bEfy0PbEb8jvAajIexwX5n6SV9Fw1hBrbeGK0nRNgE6Nq0JBUcUZxgzqe201lNWfPSE
         xNOGcBpVbEX7OCPVY5pkEw4i5ooGlszEz524YassoMiCzZOk7f8mQGoTH3io3J+OeF0J
         c7Eg==
X-Gm-Message-State: AA+aEWYcoJ58xXtvNDNixZguyfQJpCLCcXQJDePMA2N0gZX5fB4byN6u
        CyUQOIvGDPjrMJYWmZOAMIQnxd9wl6A=
X-Google-Smtp-Source: AFSGD/WHMVfX0V6vCYKlA4nptWZ+joOnQNJwir0donvqOZWq2sX17a5xAArifticsTqT2I7tnyCsgQ==
X-Received: by 2002:a25:bc01:: with SMTP id i1-v6mr7497321ybh.239.1542827003208;
        Wed, 21 Nov 2018 11:03:23 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v136-v6sm11336431ywv.19.2018.11.21.11.03.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:22 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 4/8] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Date:   Wed, 21 Nov 2018 14:03:09 -0500
Message-Id: <20181121190313.24575-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
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
index 0c6d589c8ce4..8ccc5019172b 100644
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
index a91b3183dcae..e6bb6ce23c84 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4927,6 +4927,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		btrfs_end_transaction(trans);
 		break;
 	case ALLOC_CHUNK:
+	case ALLOC_CHUNK_FORCE:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -4934,7 +4935,9 @@ static void flush_space(struct btrfs_fs_info *fs_info,
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
@@ -5070,6 +5073,19 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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

