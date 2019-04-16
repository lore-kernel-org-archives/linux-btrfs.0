Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55963C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A8AC206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfDPQmr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:36674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730101AbfDPQmq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74270B116;
        Tue, 16 Apr 2019 16:42:45 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 18/18] btrfs: trace functions for btrfs_iomap_begin/end
Date:   Tue, 16 Apr 2019 11:41:54 -0500
Message-Id: <20190416164154.30390-19-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This is for debug purposes only and can be skipped.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/dax.c               |  3 +++
 include/trace/events/btrfs.h | 56 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 2740c15286ee..de3ebc75f0b2 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -104,6 +104,8 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 	u64 srcblk = 0;
 	loff_t diff;
 
+	trace_btrfs_iomap_begin(inode, pos, length, flags);
+
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
 
 	iomap->type = IOMAP_MAPPED;
@@ -164,6 +166,7 @@ static int btrfs_iomap_end(struct inode *inode, loff_t pos,
 {
 	struct btrfs_iomap *bi = iomap->private;
 	u64 wend;
+	trace_btrfs_iomap_end(inode, pos, length, written, flags);
 
 	if (!bi)
 		return 0;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ab1cc33adbac..8779e5789a7c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1850,6 +1850,62 @@ DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
 	TP_ARGS(bg_cache)
 );
 
+TRACE_EVENT(btrfs_iomap_begin,
+
+	TP_PROTO(const struct inode *inode, loff_t pos, loff_t length, int flags),
+
+	TP_ARGS(inode, pos, length, flags),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	u64,	pos		)
+		__field(	u64,	length		)
+		__field(	int,    flags		)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
+		__entry->pos		= pos;
+		__entry->length		= length;
+		__entry->flags		= flags;
+	),
+
+	TP_printk_btrfs("ino=%llu pos=%llu len=%llu flags=0x%x",
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->length,
+		  __entry->flags)
+);
+
+TRACE_EVENT(btrfs_iomap_end,
+
+	TP_PROTO(const struct inode *inode, loff_t pos, loff_t length, loff_t written, int flags),
+
+	TP_ARGS(inode, pos, length, written, flags),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	u64,	pos		)
+		__field(	u64,	length		)
+		__field(	u64,	written		)
+		__field(	int,    flags		)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
+		__entry->pos		= pos;
+		__entry->length		= length;
+		__entry->written		= written;
+		__entry->flags		= flags;
+	),
+
+	TP_printk_btrfs("ino=%llu pos=%llu len=%llu written=%llu flags=0x%x",
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->length,
+		  __entry->written,
+		  __entry->flags)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.16.4

