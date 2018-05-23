Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754365AbeEWIXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 04:23:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 356C5AEDF
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:23:06 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/4] btrfs: lzo: Add comment about the how btrfs records its lzo compressed data
Date: Wed, 23 May 2018 16:22:59 +0800
Message-Id: <20180523082301.29874-3-wqu@suse.com>
In-Reply-To: <20180523082301.29874-1-wqu@suse.com>
References: <20180523082301.29874-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although it's not that complex, but such comment could still save
several minutes for newer reader/reviewer.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0667ea07f766..ec5db393c758 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -17,6 +17,41 @@
 
 #define LZO_LEN	4
 
+/*
+ * Btrfs LZO compression format
+ *
+ * Regular and inlined LZO compressed data extents consist of:
+ * 1.  Header
+ *     Fixed size. LZO_LEN (4) bytes long, LE32.
+ *     Records the total size (*includes* the header) of real compressed data.
+ *
+ * 2.  Segment(s)
+ *     Variable size. Each segment includes one segment header, with data
+ *     payload followed.
+ *     One regular LZO compressed extent can have one or more segments.
+ *     While For inlined LZO compressed extent, only *ONE* segment is allowed.
+ *     One segment represents at most one page of uncompressed data.
+ *
+ * 2.1 Segment header
+ *     Fixed size. LZO_LEN (4) bytes long, LE32.
+ *     Records the total size of the segment (*excludes* the header).
+ *     Segment header *NEVER* crosses page boundary, thus it's possible to
+ *     have pending zero at page end.
+ *
+ * 2.2 Data Payload
+ *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
+ *
+ * Example:
+ * Page 1:
+ *          0     0x2   0x4   0x6   0x8   0xa   0xc   0xe     0x10
+ * 0x0000   |  Header   | SegHdr 01 | Data payload 01 ...     |
+ * ...
+ * 0x0ff0   | SegHdr  N | Data payload  N     ...          |00|
+ *                                                          ^^ pending zero
+ * Page 2:
+ * 0x1000   | SegHdr N+1| Data payload N+1 ...                |
+ */
+
 struct workspace {
 	void *mem;
 	void *buf;	/* where decompressed data goes */
-- 
2.17.0

