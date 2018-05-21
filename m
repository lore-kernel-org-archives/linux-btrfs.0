Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbeEUFTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 01:19:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 206FBAD4E
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 05:19:32 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: lzo: Add comment about the how btrfs records its lzo compressed data
Date: Mon, 21 May 2018 13:19:25 +0800
Message-Id: <20180521051927.3715-3-wqu@suse.com>
In-Reply-To: <20180521051927.3715-1-wqu@suse.com>
References: <20180521051927.3715-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although it's not that complex, but such comment could still save
several minutes for newer reader/reviewer.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0667ea07f766..d0c6789ff78f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -17,6 +17,29 @@
 
 #define LZO_LEN	4
 
+/*
+ * Btrfs LZO compression format
+ *
+ * Regular LZO compressed data extent consists of:
+ * 1.  Header
+ *     Fixed size. LZO_LEN (4) bytes long, LE32.
+ *     Records the total size (*includes* the header) of real compressed data.
+ *
+ * 2.  Segment(s)
+ *     Variable size. Includes one segment header, and then data payload.
+ *     One regular LZO compressed extent can have one or more segments.
+ *
+ * 2.1 Segment header
+ *     Fixed size. LZO_LEN (4) bytes long, LE32.
+ *     Records the total size of the segment (*excludes* the header).
+ *
+ * 2.2 Data Payload
+ *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
+ *
+ * While for inlined LZO compressed data extent, it doesn't have Header, just
+ * *ONE* Segment.
+ */
+
 struct workspace {
 	void *mem;
 	void *buf;	/* where decompressed data goes */
-- 
2.17.0

