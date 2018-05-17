Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbeEQG2I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:28:08 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
Subject: [PATCH 2/4] btrfs: lzo: Add comment about the how btrfs records its lzo compressed data
Date: Thu, 17 May 2018 14:27:51 +0800
Message-Id: <20180517062753.25973-3-wqu@suse.com>
In-Reply-To: <20180517062753.25973-1-wqu@suse.com>
References: <20180517062753.25973-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0667ea07f766..3d2ae4c08876 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -17,6 +17,29 @@
 
 #define LZO_LEN	4
 
+/*
+ * Btrfs LZO compression format
+ *
+ * Regular LZO compressed data extent is consist of:
+ * 1.  Header
+ *     Fixed size. LZO_LEN (4) bytes long, LE16.
+ *     Records the total size (*includes* the header) of real compressed data.
+ *
+ * 2.  Segment(s)
+ *     Variable size. Includes one segment header, and then data payload.
+ *     One btrfs compressed data can have one or more segments.
+ *
+ * 2.1 Segment header
+ *     Fixed size. LZO_LEN (4) bytes long, LE16.
+ *     Records the total size of the segment (*excludes* the header).
+ *
+ * 2.2 Data Payload
+ *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
+ *
+ * While for inlined LZO compressed data extent, it doesn't have Header, just
+ * one Segment.
+ */
+
 struct workspace {
 	void *mem;
 	void *buf;	/* where decompressed data goes */
-- 
2.17.0

