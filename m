Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD95C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8308E20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zbkMj1Zr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8308E20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeLCPU4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:56 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39880 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbeLCPU4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:56 -0500
Received: by mail-yb1-f196.google.com with SMTP id w17-v6so5412877ybl.6
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=39z1AfoM6BOmXC4kNZBHFD4W9bTksWGoXViO/fokQuo=;
        b=zbkMj1ZrYnCqqUcW9l+C/5jKLzUxIMG/6rZmzf4EkJiPLu+jf7kEcIGin+jZDHuthR
         9hJPZhRht6NU7bcbSfDNjOe/rMekxO5gx8UfeypzvFI8WPYe9V8LFDgL1jKZo8e3bmh+
         KfLQlRRUgGQD6htkKu1Xf57pJWixQInJM8Hh6+8fT8sbvNRt1TN5JjfCZazCOBouCf6Y
         BeLbtaC/e1tucNToPrbuFp7GkveVuJ38OqaPQcAqj+qxZ+jp5X4CgwUX/SHJ91ftlleP
         eVPsUq9Z1ZT0S72R3GjRXcVTw+jGV1AczXNfoasceQLZuzfEs13j23P39MfbkTxbDUsg
         RCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=39z1AfoM6BOmXC4kNZBHFD4W9bTksWGoXViO/fokQuo=;
        b=J0mAN1CewJ7ETxdgXIHwlyLJZFtl6LNH6+kVZt4ZG4KC9tDED1VrlITEckNNofWPpm
         4jkEiwRzoJ//cIWW/+mMM8leLy9NhqzSVcY3DbXjnKxIgWrE1NGsXNGtBR4MGnSScueI
         tdFSyXh8b7fVO9mVYgHihyaMUcAGES2pRlo6BsQpxOiuQGbGBimqVoSwcLe2DrYln9MJ
         KdtE9vqV5jy3gLv+myRQXCjLbxyaV0fw1mjoHrqZhKSAfRYSztlNse9Mx8/PwTrdqRSq
         y2LJIrARVuFFMesi+bh7Qpfg+TGEGxiRDPAmOlbKQp14tnFHVPHNuiKQ6p2MG83uls0M
         E3ag==
X-Gm-Message-State: AA+aEWaF2g3+5ag831Ja2C1KwCsTbhgfGp40uqMkXoDLno5KTE4w6JbA
        hEPGNfh6p6r1LDAq9oCL6favOo5y0lo=
X-Google-Smtp-Source: AFSGD/Wgeo4gbPu/kByB8TrMzKlwaYEBBG3pUnS6So7M0Iwgzjhl9cb1Zq+uKueuKV4GruFvDPVAxg==
X-Received: by 2002:a25:cbcb:: with SMTP id b194-v6mr15609784ybg.96.1543850454128;
        Mon, 03 Dec 2018 07:20:54 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r62sm4588140ywd.4.2018.12.03.07.20.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:53 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 07/10] btrfs: add new flushing states for the delayed refs rsv
Date:   Mon,  3 Dec 2018 10:20:35 -0500
Message-Id: <20181203152038.21388-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A nice thing we gain with the delayed refs rsv is the ability to flush
the delayed refs on demand to deal with enospc pressure.  Add states to
flush delayed refs on demand, and this will allow us to remove a lot of
ad-hoc work around checking to see if we should commit the transaction
to run our delayed refs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             | 10 ++++++----
 fs/btrfs/extent-tree.c       | 14 ++++++++++++++
 include/trace/events/btrfs.h |  2 ++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 52a87d446945..2eba398c722b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2745,10 +2745,12 @@ enum btrfs_reserve_flush_enum {
 enum btrfs_flush_state {
 	FLUSH_DELAYED_ITEMS_NR	=	1,
 	FLUSH_DELAYED_ITEMS	=	2,
-	FLUSH_DELALLOC		=	3,
-	FLUSH_DELALLOC_WAIT	=	4,
-	ALLOC_CHUNK		=	5,
-	COMMIT_TRANS		=	6,
+	FLUSH_DELAYED_REFS_NR	=	3,
+	FLUSH_DELAYED_REFS	=	4,
+	FLUSH_DELALLOC		=	5,
+	FLUSH_DELALLOC_WAIT	=	6,
+	ALLOC_CHUNK		=	7,
+	COMMIT_TRANS		=	8,
 };
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 63ff9d832867..5a2d0b061f57 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4938,6 +4938,20 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		shrink_delalloc(fs_info, num_bytes * 2, num_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
+	case FLUSH_DELAYED_REFS_NR:
+	case FLUSH_DELAYED_REFS:
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+		if (state == FLUSH_DELAYED_REFS_NR)
+			nr = calc_reclaim_items_nr(fs_info, num_bytes);
+		else
+			nr = 0;
+		btrfs_run_delayed_refs(trans, nr);
+		btrfs_end_transaction(trans);
+		break;
 	case ALLOC_CHUNK:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8568946f491d..63d1f9d8b8c7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1048,6 +1048,8 @@ TRACE_EVENT(btrfs_trigger_flush,
 		{ FLUSH_DELAYED_ITEMS,		"FLUSH_DELAYED_ITEMS"},		\
 		{ FLUSH_DELALLOC,		"FLUSH_DELALLOC"},		\
 		{ FLUSH_DELALLOC_WAIT,		"FLUSH_DELALLOC_WAIT"},		\
+		{ FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR"},	\
+		{ FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS"},		\
 		{ ALLOC_CHUNK,			"ALLOC_CHUNK"},			\
 		{ COMMIT_TRANS,			"COMMIT_TRANS"})
 
-- 
2.14.3

