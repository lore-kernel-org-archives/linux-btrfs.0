Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754369AbeEWIXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 04:23:10 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C0CDAEDF
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:23:09 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/4] btrfs: lzo: Harden inline lzo compressed extent decompression
Date: Wed, 23 May 2018 16:23:01 +0800
Message-Id: <20180523082301.29874-5-wqu@suse.com>
In-Reply-To: <20180523082301.29874-1-wqu@suse.com>
References: <20180523082301.29874-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For inlined extent, we only have one segment, thus less thing to check.
And further more, inlined extent always has csum in its leaf header,
it's less possible to have corrupted data.

Anyway, still check header and segment header.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 4f4de460b08d..8604f6bc0a29 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -437,15 +437,24 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	size_t in_len;
 	size_t out_len;
+	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
 	int ret = 0;
 	char *kaddr;
 	unsigned long bytes;
 
-	BUG_ON(srclen < LZO_LEN);
+	if (srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)
+		return -EUCLEAN;
 
+	in_len = read_compress_length(data_in);
+	if (in_len != srclen)
+		return -EUCLEAN;
 	data_in += LZO_LEN;
 
 	in_len = read_compress_length(data_in);
+	if (in_len != srclen - LZO_LEN * 2) {
+		ret = -EUCLEAN;
+		goto out;
+	}
 	data_in += LZO_LEN;
 
 	out_len = PAGE_SIZE;
-- 
2.17.0

