Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750823AbeEUFTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 01:19:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90646AD4E
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 05:19:34 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: lzo: Harden inline lzo compressed extent decompression
Date: Mon, 21 May 2018 13:19:27 +0800
Message-Id: <20180521051927.3715-5-wqu@suse.com>
In-Reply-To: <20180521051927.3715-1-wqu@suse.com>
References: <20180521051927.3715-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike regular lzo compressed extent, inline extent doesn't have Header
and only has one Segment.
And further more, inlined extent always has csum in its leaf header,
it's less possible to have corrupted data.

Anyway, still add extra segment header length check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 4c75dcba3f04..28788f6f0add 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -425,6 +425,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	size_t in_len;
 	size_t out_len;
+	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
 	int ret = 0;
 	char *kaddr;
 	unsigned long bytes;
@@ -434,6 +435,10 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	data_in += LZO_LEN;
 
 	in_len = read_compress_length(data_in);
+	if (in_len > max_segment_len) {
+		ret = -EUCLEAN;
+		goto out;
+	}
 	data_in += LZO_LEN;
 
 	out_len = PAGE_SIZE;
-- 
2.17.0

